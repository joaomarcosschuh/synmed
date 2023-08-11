import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import 'package:provider/provider.dart';
import 'stores/flashcards_store.dart';
import 'stores/progress_store.dart';
import 'stores/selected_decks.dart';
import 'views/study/study_page.dart';
import 'views/loading.dart';
import 'views/category/category_page.dart';
import 'views/profile/profile_page.dart';
import 'services/stats/dailystats_service.dart';
import 'services/stats/streak_service.dart';
import 'stores/stats_store.dart';
import 'stores/auth_store.dart';
import 'package:video_player/video_player.dart';
import 'views/login/choose_login.dart';
import 'views/login/login_page.dart';
import 'views/login/first_login.dart';
import 'views/main_view_page.dart';
import 'views/intro/intro_vid.dart';
import 'views/chat/chat_page.dart';
import 'views/create/creating_cards_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization =
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  @override
  Widget build(BuildContext context) {
    final defaultProfileImageProvider =
    AssetImage('lib/assets/profile_picture.png');

    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return App(defaultProfileImageProvider: defaultProfileImageProvider);
        } else {
          return MaterialApp(
            theme: ThemeData(
              primaryColor: Color.fromRGBO(20, 41, 61, 1),
              scaffoldBackgroundColor: Color.fromRGBO(20, 41, 61, 1),
              appBarTheme: AppBarTheme(
                  backgroundColor: Color.fromRGBO(20, 41, 61, 1)),
            ),
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}

class App extends StatelessWidget {
  final AssetImage defaultProfileImageProvider;
  final flashcardsStore = FlashcardsStore();
  final progressStore = ProgressStore();
  final selectedDecks = SelectedDecks();
  final statsStore = StatsStore();
  final authStore = AuthStore();

  App({required this.defaultProfileImageProvider});

  @override
  Widget build(BuildContext context) {
    final dailyStatsService = DailyStatsService();
    final streakService = StreakService(dailyStatsService);

    if (kIsWeb) {
      // Set the color of the address bar when running on the web.
    } else if (Platform.isAndroid || Platform.isIOS) {
      // Set status bar color for Android and iOS
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(0xFF14293D),
      ));
    }

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
        theme: ThemeData(
          primaryColor: Color.fromRGBO(20, 41, 61, 1),
          scaffoldBackgroundColor: Color.fromRGBO(20, 41, 61, 1),
          appBarTheme: AppBarTheme(
              backgroundColor: Color.fromRGBO(20, 41, 61, 1)),
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
          '/chat': (context) => ChatPage(),
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
                case '/chat':
                  return ChatPage();
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
