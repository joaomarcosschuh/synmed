import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meu_flash/stores/flashcards_store.dart';
import 'package:meu_flash/stores/progress_store.dart';
import 'package:meu_flash/stores/stats_store.dart';
import 'package:meu_flash/stores/auth_store.dart';
import 'package:meu_flash/models/dailystats_model.dart';
import 'package:flip_card/flip_card.dart';

class StudyPage extends StatefulWidget {
  @override
  _StudyPageState createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  int currentIndex = 0;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

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
        body: Center(child: Text('No more flashcards to study', style: TextStyle(color: Colors.black54))),
      );
    }

    final currentFlashcard = flashcards[currentIndex % flashcards.length];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20), // Espaço entre as bordas da tela e os botões
        child: Column(
          children: [
            SizedBox(height: 20),
            Image.asset(
              'lib/assets/logo/static_logo.png',
              width: 266,
              height: 133,
            ),
            SizedBox(height: 20), // Espaço entre o logotipo e o cartão
            FlipCard(
              key: cardKey,
              flipOnTouch: false,
              direction: FlipDirection.VERTICAL,
              front: _buildCardFace(currentFlashcard.flashcardQuestion, true),
              back: _buildCardFace(currentFlashcard.flashcardAnswer, true),
            ),
            SizedBox(height: 20), // Espaço entre o cartão e os botões
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: Size(180, 60), // Tamanho mínimo do botão 'Flip'
              ),
              onPressed: () {
                cardKey.currentState!.toggleCard();
              },
              child: Text(
                'Flip',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20), // Espaço entre o botão 'Flip' e a linha de botões
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: Size(140, 60), // Tamanho mínimo dos botões 'Again', 'Hard', 'Medium', 'Easy'
                  ),
                  onPressed: () {
                    setState(() {
                      progressStore.updateProgress(currentFlashcard.flashcardId, 'again');
                      currentIndex = (currentIndex + 1) % flashcards.length;
                      cardKey.currentState!.toggleCard();
                    });

                    statsStore.updateDailyStatsForStudySession();

                    print('DailyStats updated: ${statsStore.dailyStats.toString()}');
                  },
                  child: Text(
                    'Again',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 10), // Espaço horizontal entre os botões 'Again' e 'Hard'
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: Size(140, 60),
                  ),
                  onPressed: () {
                    setState(() {
                      progressStore.updateProgress(currentFlashcard.flashcardId, 'hard');
                      currentIndex = (currentIndex + 1) % flashcards.length;
                      cardKey.currentState!.toggleCard();
                    });

                    statsStore.updateDailyStatsForStudySession();

                    print('DailyStats updated: ${statsStore.dailyStats.toString()}');
                  },
                  child: Text(
                    'Hard',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 10), // Espaço horizontal entre os botões 'Hard' e 'Medium'
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: Size(140, 60),
                  ),
                  onPressed: () {
                    setState(() {
                      progressStore.updateProgress(currentFlashcard.flashcardId, 'medium');
                      currentIndex = (currentIndex + 1) % flashcards.length;
                      cardKey.currentState!.toggleCard();
                    });

                    statsStore.updateDailyStatsForStudySession();

                    print('DailyStats updated: ${statsStore.dailyStats.toString()}');
                  },
                  child: Text(
                    'Medium',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 10), // Espaço horizontal entre os botões 'Medium' e 'Easy'
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: Size(140, 60),
                  ),
                  onPressed: () {
                    setState(() {
                      progressStore.updateProgress(currentFlashcard.flashcardId, 'easy');
                      currentIndex = (currentIndex + 1) % flashcards.length;
                      cardKey.currentState!.toggleCard();
                    });

                    statsStore.updateDailyStatsForStudySession();

                    print('DailyStats updated: ${statsStore.dailyStats.toString()}');
                  },
                  child: Text(
                    'Easy',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFace(String text, bool showLogo) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Stack(
        children: [
          Container(
            width: 480,
            height: 400,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  text,
                  style: TextStyle(color: Colors.black87, fontSize: 24.0),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          if (showLogo)
            Positioned(
              bottom: 7,
              right: 10,
              child: Image.asset(
                'lib/assets/logo/canto_logo.png',
                width: 100, // Tamanho ajustado do logo
                height: 30, // Tamanho ajustado do logo
              ),
            ),
        ],
      ),
    );
  }
}
