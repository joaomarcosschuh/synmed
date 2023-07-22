import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import 'views/login/login_page.dart';
import 'views/login/first_login.dart';
import 'views/main_view_page.dart';
import 'stores/flashcards_store.dart';
import 'stores/progress_store.dart';
import 'stores/selected_decks.dart';
import 'package:provider/provider.dart';
import 'views/study/study_page.dart';
import 'views/loading.dart';
import 'views/category/category_page.dart';
import 'views/profile/profile_page.dart';
import 'services/stats/dailystats_service.dart';
import 'services/stats/streak_service.dart';
import 'stores/stats_store.dart';
import 'stores/auth_store.dart';
import 'views/intro/intro_vid.dart';
import 'package:video_player/video_player.dart';
import 'views/login/choose_login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return App();
        } else {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(), // Display the circular progress indicator while Firebase initializes
              ),
            ),
          );
        }
      },
    );
  }
}

class App extends StatelessWidget {
  final flashcardsStore = FlashcardsStore();
  final progressStore = ProgressStore();
  final selectedDecks = SelectedDecks();
  final statsStore = StatsStore();
  final authStore = AuthStore();

  @override
  Widget build(BuildContext context) {
    final dailyStatsService = DailyStatsService();
    final streakService = StreakService(dailyStatsService);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FlashcardsStore>(
          create: (context) => flashcardsStore,
        ),
        ChangeNotifierProvider<ProgressStore>(
          create: (context) => progressStore,
        ),
        ChangeNotifierProvider<SelectedDecks>(
          create: (context) => selectedDecks,
        ),
        ChangeNotifierProvider<AuthStore>(
          create: (context) => authStore,
        ),
        Provider<StatsStore>(
          create: (context) => statsStore,
        ),
        Provider<DailyStatsService>.value(
          value: dailyStatsService,
        ),
        Provider<StreakService>.value(
          value: streakService,
        ),
      ],
      child: MaterialApp(
        title: 'Meu Flash',
        themeMode: ThemeMode.dark, // Set the themeMode to dark for web (black background)
        darkTheme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: IntroVid(),
        routes: {
          '/loading': (context) => LoadingPage(),
          '/study': (context) => StudyPage(),
          '/category': (context) => CategoryPage(),
          '/firstLogin': (context) => FirstLoginPage(),
          '/mainView': (context) => MainViewPage(),
          '/profile': (context) => ProfilePage(),
          '/chooseLogin': (context) => ChooseLoginPage(),
        },
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              switch (settings.name) {
                case '/loading':
                  return LoadingPage();
                case '/study':
                  return StudyPage();
                case '/category':
                  return CategoryPage();
                case '/firstLogin':
                  return FirstLoginPage();
                case '/mainView':
                  return MainViewPage();
                case '/profile':
                  return ProfilePage();
                case '/chooseLogin':
                  return ChooseLoginPage();
                default:
                  return IntroVid();
              }
            },
          );
        },
      ),
    );
  }
}
