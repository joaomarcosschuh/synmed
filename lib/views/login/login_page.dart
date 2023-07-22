import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meu_flash/views/login/register_page.dart';
import 'package:meu_flash/services/session_services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_flash/views/login/first_login.dart';
import 'package:meu_flash/views/main_view_page.dart';
import 'package:meu_flash/services/stats/dailystats_service.dart';
import 'package:meu_flash/models/dailystats_model.dart';
import 'package:meu_flash/services/stats/streak_service.dart';
import 'package:meu_flash/stores/stats_store.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(background: Colors.black),
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late FirebaseAuth _auth;
  late GoogleSignIn _googleSignIn;
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService();
  String? _email;
  String? _password;

  bool _isLoading = false;

  final StatsStore _statsStore = StatsStore();

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _googleSignIn = GoogleSignIn(
      clientId: '857412064219-pu3bdvj397f74ek5jifmj91i3io48nrn.apps.googleusercontent.com',
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        setState(() {
          _isLoading = true;
        });
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _email!,
          password: _password!,
        );
        User? user = userCredential.user;
        DocumentSnapshot userDoc = await _userService.getUser(user!.uid);
        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>?;
          if (userData != null && userData.containsKey('username')) {
            // Get the current date
            DateTime now = DateTime.now();

            // Check if the user has already logged in today
            if (userData['lastLoginAt'].toDate().day != now.day) {
              // This is the first login of the day
              await _userService.updateLastLoginAt(user.uid, now);

              String statsId = '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}';
              DailyStatsService dailyStatsService = Provider.of<DailyStatsService>(context, listen: false);
              StreakService streakService = Provider.of<StreakService>(context, listen: false);
              DailyStatsModel? dailyStats = await dailyStatsService.getDailyStats(user.uid, statsId);
              if (dailyStats == null) {
                dailyStats = DailyStatsModel(
                  xpDia: 0,
                  cartoesVistos: 0,
                  streak: 0,
                );
                await dailyStatsService.createDailyStats(
                  user.uid,
                  statsId,
                  dailyStats,
                );
              }
              await streakService.checkAndUpdateStreak(user.uid);

              await _statsStore.loadStats(user.uid, statsId);
              await _statsStore.checkAndUpdateStreak(user.uid);
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainViewPage()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => FirstLoginPage()),
            );
          }
        }
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;
      DocumentSnapshot userDoc = await _userService.getUser(user!.uid);
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>?;
        if (userData != null && userData.containsKey('username')) {
          // Get the current date
          DateTime now = DateTime.now();

          // Check if the user has already logged in today
          if (userData['lastLoginAt'].toDate().day != now.day) {
            // This is the first login of the day
            await _userService.updateLastLoginAt(user.uid, now);

            String statsId = '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}';
            DailyStatsService dailyStatsService = Provider.of<DailyStatsService>(context, listen: false);
            StreakService streakService = Provider.of<StreakService>(context, listen: false);
            DailyStatsModel? dailyStats = await dailyStatsService.getDailyStats(user.uid, statsId);
            if (dailyStats == null) {
              dailyStats = DailyStatsModel(
                xpDia: 0,
                cartoesVistos: 0,
                streak: 0,
              );
              await dailyStatsService.createDailyStats(
                user.uid,
                statsId,
                dailyStats,
              );
            }
            await streakService.checkAndUpdateStreak(user.uid);

            await _statsStore.loadStats(user.uid, statsId);
            await _statsStore.checkAndUpdateStreak(user.uid);
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainViewPage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FirstLoginPage()),
          );
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
        child: Padding(
          padding: EdgeInsets.all(54.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'lib/assets/logo/static_logo.png',
                height: 200,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white), // Change the button border color to white
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white), // Change the button border color to white
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      onSaved: (value) => _email = value,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white), // Change the button border color to white
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white), // Change the button border color to white
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onSaved: (value) => _password = value,
                      textAlign: TextAlign.center,
                      obscureText: true,
                    ),
                    SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white, // Change the button background color to white
                        ),
                        child: Text(
                          'Log in',
                          style: TextStyle(fontSize: 24, color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _loginWithGoogle,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // Change the button background color to red
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'lib/assets/google_logo.png',
                              height: 24,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Entrar com o Google',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      child: Text(
                        'Criar nova conta',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
