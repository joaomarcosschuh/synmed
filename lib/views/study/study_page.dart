import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meu_flash/stores/flashcards_store.dart';
import 'package:meu_flash/stores/progress_store.dart';
import 'package:meu_flash/stores/stats_store.dart';
import 'package:meu_flash/stores/auth_store.dart';
import 'package:meu_flash/models/dailystats_model.dart';
import 'package:flip_card/flip_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_flash/models/streak_model.dart';
import 'package:meu_flash/views/study/flashcard_widget.dart';
import 'package:meu_flash/views/chat/chat_balloon.dart';

class StudyPage extends StatefulWidget {
  @override
  _StudyPageState createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  int currentIndex = 0;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  bool showChat = false;

  int streak = 0;
  int totalXP = 0;
  late String userUid;
  late String photoUrl = '';

  @override
  void initState() {
    super.initState();
    retrieveUserUid();
    retrieveStreakValue().then((value) => mounted ? setState(() => streak = value) : null);
    retrieveTotalXP().then((value) => mounted ? setState(() => totalXP = value) : null);
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
      if (mounted) {
        setState(() {
          photoUrl = user.photoURL ?? '';
        });
      }
    }
  }

  void onItemTapped(int index) {
    setState(() {
      currentIndex = index;

      if (index == 2) {
        showChat = !showChat;
      } else {
        currentIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final flashcardsStore = Provider.of<FlashcardsStore>(context);
    final progressStore = Provider.of<ProgressStore>(context);
    final statsStore = Provider.of<StatsStore>(context);
    final authStore = Provider.of<AuthStore>(context);

    var flashcards = progressStore.sortedFlashcards
        .map((flashcardId) =>
        flashcardsStore.flashcards.firstWhere((flashcard) => flashcard.flashcardId == flashcardId))
        .toList();

    if (flashcards.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
          child: Text(
            'No more flashcards to study',
            style: TextStyle(color: Colors.black54),
          ),
        ),
      );
    }

    final currentFlashcard = flashcards[currentIndex % flashcards.length];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Color(0xFF14293D),
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                height: 56.0,
                color: Color(0xFF14293D),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset('lib/assets/simbolos/foguinho.png', width: 35, height: 35),
                        SizedBox(width: 8),
                        Text('$streak', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: photoUrl.isNotEmpty
                          ? NetworkImage(photoUrl) as ImageProvider<Object>
                          : AssetImage('lib/assets/profile_picture.png'),
                    ),
                    Row(
                      children: [
                        Text('$totalXP', style: TextStyle(color: Colors.white)),
                        SizedBox(width: 8),
                        Image.asset('lib/assets/simbolos/xp.png', width: 45, height: 45),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'clique na sirene para mais',
                style: TextStyle(color: Colors.grey, fontSize: 16.0),
              ),
              SizedBox(height: 20),
              Expanded(
                child: FlashcardWidget(
                  cardKey: cardKey,
                  flashcard: currentFlashcard,
                  currentIndex: currentIndex,
                  flashcards: flashcards,
                  progressStore: progressStore,
                  statsStore: statsStore,
                ),
              ),
            ],
          ),
          if (showChat) ChatBalloon(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF14293D),
        selectedItemColor: Colors.white60,
        unselectedItemColor: Colors.white38,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset('lib/assets/simbolos/baralhos.png', width: 45, height: 45),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('lib/assets/simbolos/medalha.png', width: 45, height: 45),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('lib/assets/simbolos/professor1.png', width: 45, height: 45),
            label: '',
          ),
        ],
        currentIndex: currentIndex,
        onTap: onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}