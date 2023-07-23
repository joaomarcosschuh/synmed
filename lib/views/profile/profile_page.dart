import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import '/models/user_model.dart';
import '/models/streak_model.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  int streak = 0;
  int totalXP = 0;
  late String userUid;
  Map<String, bool> dailyLogins = {};

  @override
  void initState() {
    super.initState();

    retrieveUserUid().then((value) {
      retrieveStreakValues().then((streakModel) {
        setState(() {
          streak = streakModel.streak;
          totalXP = streakModel.totalXP;
          dailyLogins = streakModel.dailyLogins;
        });
      });
    });
  }

  Future<void> retrieveUserUid() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userUid = user.uid;
    }
  }

  Future<StreakModel> retrieveStreakValues() async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .doc('/users/$userUid/statistics/streak')
        .get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      return StreakModel.fromMap(data);
    } else {
      return StreakModel(
        streak: 0,
        totalXP: 0,
        dailyLogins: {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      final userStream = FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .snapshots();

      return StreamBuilder<DocumentSnapshot>(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          UserModel user = UserModel.fromDocumentSnapshot(snapshot.data!);

          return Scaffold(
            backgroundColor: Colors.black,
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: user.profilePicture != null
                          ? NetworkImage(user.profilePicture!)
                          : null,
                      child: user.profilePicture == null
                          ? Icon(Icons.person)
                          : null,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '@${user.username}',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              'lib/assets/simbolos/foguinho.png',
                              width: 45,
                            ),
                            SizedBox(height: 10),
                            Text(
                              '$streak Streak',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Image.asset(
                              'lib/assets/simbolos/xp.png',
                              width: 60,
                            ),
                            SizedBox(height: 10),
                            Text(
                              '$totalXP XP Total',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    onDaySelected: null,
                    selectedDayPredicate: (day) {
                      return false;
                    },
                    headerStyle: HeaderStyle(formatButtonVisible: false),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: TextStyle(color: Colors.white),
                      defaultTextStyle: TextStyle(color: Colors.white),
                      weekendTextStyle: TextStyle(color: Colors.white),
                    ),
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, date, events) {
                        String dateString =
                            '${date.day}-${date.month}-${date.year}';
                        if (dailyLogins[dateString] == true) {
                          return Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage('lib/assets/simbolos/circle.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return Text("No user found");
    }
  }
}
