import 'package:flutter/material.dart';
import 'package:meu_flash/controllers/get_categories.dart';
import 'package:meu_flash/models/deck_checkbox.dart';
import 'package:provider/provider.dart';
import 'package:meu_flash/stores/selected_decks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meu_flash/models/streak_model.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final GetCategories _getCategories = GetCategories();
  final TextEditingController _searchController = TextEditingController();
  int streak = 0;
  int totalXP = 0;
  late String userUid;
  late String photoUrl;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });

    retrieveUserUid();

    retrieveStreakValue().then((value) {
      setState(() {
        streak = value;
      });
    });

    retrieveTotalXP().then((value) {
      setState(() {
        totalXP = value;
      });
    });

    retrieveUserPhoto();
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
      final streakModel = StreakModel.fromMap(data);
      return streakModel.totalXP;
    } else {
      return 0;
    }
  }

  Future<void> retrieveUserPhoto() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        photoUrl = user.photoURL ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(  // Adicione esta linha
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'lib/assets/simbolos/foguinho.png',
                                width: 40,
                                height: 40,
                              ),
                              SizedBox(width: 5),
                              Text(
                                '$streak',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Center(
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(photoUrl.isNotEmpty
                                  ? photoUrl
                                  : 'lib/assets/profile_picture.png'),
                              radius: 35,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$totalXP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10),
                              Image.asset(
                                'lib/assets/simbolos/xp.png',
                                width: 50,
                                height: 50,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 10),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.black),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 35.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: FutureBuilder<Map<String, Set<String>>>(
                    future: _getCategories.fetchCategoriesAndDecks(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'An error occurred',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        final categories = snapshot.data!.entries
                            .where((e) => e.key.contains(_searchController.text))
                            .toList();
                        return ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index].key;
                            final decks = categories[index].value.toList();
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.black,
                              ),
                              child: Theme(
                                data: ThemeData(
                                  textTheme: TextTheme(
                                    titleMedium: TextStyle(color: Colors.white),
                                  ),
                                  unselectedWidgetColor: Colors.white,
                                ),
                                child: ExpansionTile(
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                    AssetImage('lib/assets/${category.toLowerCase()}.jpg'),
                                  ),
                                  title: Text(category),
                                  children: decks.map((deck) {
                                    return DeckCheckbox(deck: deck, initialValue: false);
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Consumer<SelectedDecks>(
        builder: (context, selectedDecks, _) {
          return FloatingActionButton(
            backgroundColor: Colors.black87,
            onPressed: selectedDecks.selectedDecks.isEmpty
                ? null
                : () {
              Navigator.pushNamed(context, '/loading',
                  arguments: selectedDecks.selectedDecks.toList());
            },
            child: Icon(Icons.play_arrow, color: Colors.white),
          );
        },
      ),
    );
  }
}
