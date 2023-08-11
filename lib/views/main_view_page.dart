import 'package:flutter/material.dart';
import 'package:meu_flash/views/profile/profile_page.dart';
import 'package:meu_flash/views/category/category_page.dart';
import 'package:meu_flash/views/chat/chat_page.dart';
import 'package:meu_flash/views/study/study_page.dart';
import 'package:meu_flash/views/create/creating_cards_page.dart';
import 'package:meu_flash/views/study/navigation_menu.dart';
import 'package:meu_flash/views/study/category_header.dart';
import 'package:meu_flash/controllers/get_categories.dart';
import 'package:meu_flash/models/dailystats_model.dart';
import 'package:meu_flash/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu Flash',
      theme: ThemeData(
        primaryColor: Color(0xFF14293D),
        scaffoldBackgroundColor: Color(0xFF14293D),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainViewPage(),
    );
  }
}

class MainViewPage extends StatefulWidget {
  @override
  _MainViewPageState createState() => _MainViewPageState();
}

class _MainViewPageState extends State<MainViewPage> {
  int _selectedIndex = 0;
  final _pages = [
    CategoryPage(),
    ProfilePage(),
    ChatPage(),
    CreatingCardsPage(),
  ];

  int streak = 0;
  int totalXP = 0;
  late String userUid;
  late String photoUrl = '';
  Map<String, Set<String>> categories = {};

  final GlobalKey _headerKey = GlobalKey(); // Add a GlobalKey

  @override
  void initState() {
    super.initState();
    retrieveUserUid();
    retrieveStreakValue().then((value) {
      if (mounted) {
        setState(() {
          streak = value;
        });
      }
    });

    retrieveTotalXP().then((value) {
      if (mounted) {
        setState(() {
          totalXP = value;
        });
      }
    });

    retrieveUserPhoto();
    fetchCategoriesAndDecks();
    fetchUserData(); // Add this line to fetch user data
  }

  Future<void> retrieveUserUid() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userUid = user.uid;
    }
  }

  Future<int> retrieveStreakValue() async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .doc('/users/$userUid/statistics/streak')
        .get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      return data['streak'] as int;
    } else {
      return 0;
    }
  }

  Future<int> retrieveTotalXP() async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .doc('/users/$userUid/statistics/streak')
        .get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      return data['totalXP'] as int;
    } else {
      return 0;
    }
  }

  Future<void> retrieveUserPhoto() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (mounted) {
        setState(() {
          photoUrl = user.photoURL ?? '';
        });
      }
    }
  }

  Future<void> fetchCategoriesAndDecks() async {
    GetCategories getCategories = GetCategories();
    Map<String, Set<String>> fetchedCategories =
    await getCategories.fetchCategoriesAndDecks();
    setState(() {
      categories = fetchedCategories;
    });
  }

  Future<void> fetchUserData() async {
    final DocumentSnapshot userSnapshot =
    await FirebaseFirestore.instance.doc('/users/$userUid').get();

    if (userSnapshot.exists) {
      final data = userSnapshot.data() as Map<String, dynamic>;
      setState(() {
        currentUser = UserModel.fromDocumentSnapshot(userSnapshot);
      });
    } else {
      // Handle the case where the user data doesn't exist.
      // You can show an error message or create a default UserModel object.
      setState(() {
        currentUser = UserModel.defaultUser();
      });
    }
  }

  UserModel? currentUser; // Use nullable type with '?' to indicate it can be null

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      // Handle the case when currentUser is null, you can show a loading indicator or a placeholder
      return CircularProgressIndicator();
    } else {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            backgroundColor: Color(0xFF14293D),
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
        ),
        body: Column(
          children: [
            // New header using the CategoryHeader with GlobalKey
            CategoryHeader(
              categories: categories,
              headerKey: _headerKey,
              dailyStatsModel: DailyStatsModel(
                xpDia: 0, // Replace 0 with the actual value if available
                cartoesVistos: 0, // Replace 0 with the actual value if available
                streak: streak,
              ),
              user: currentUser!, // Use '!' to assert that currentUser is not null
            ),

            Expanded(
              child: _pages[_selectedIndex],
            ),
          ],
        ),
        backgroundColor: Color(0xFF14293D),
        bottomNavigationBar: NavigationMenu(
          selectedIndex: _selectedIndex,
          onItemTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      );
    }
  }
}
