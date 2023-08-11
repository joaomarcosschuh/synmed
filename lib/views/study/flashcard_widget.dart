import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:meu_flash/stores/progress_store.dart';
import 'package:meu_flash/stores/stats_store.dart';
import 'package:meu_flash/models/flashcard_model.dart';

class FlashcardWidget extends StatelessWidget {
  final GlobalKey<FlipCardState> cardKey;
  final FlashcardModel flashcard;
  final int currentIndex;
  final List<FlashcardModel> flashcards;
  final ProgressStore progressStore;
  final StatsStore statsStore;

  FlashcardWidget({
    required this.cardKey,
    required this.flashcard,
    required this.currentIndex,
    required this.flashcards,
    required this.progressStore,
    required this.statsStore,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = constraints.maxHeight;

        // Relative sizes
        final buttonHeightPercentage = 0.07; // 7% of the screen height
        final cardHeightPercentage = 0.6; // 60% of the screen height
        final spacingPercentage = 0.02; // 2% of the screen height

        final buttonHeight = screenHeight * buttonHeightPercentage;
        final cardHeight = screenHeight * cardHeightPercentage;
        final spacing = screenHeight * spacingPercentage;

        return Column(
          children: [
            Expanded(
              child: Container(
                height: cardHeight,
                child: FlipCard(
                  key: cardKey,
                  flipOnTouch: false,
                  direction: FlipDirection.VERTICAL,
                  front: _buildCardFace(flashcard.flashcardQuestion),
                  back: _buildCardFace(flashcard.flashcardAnswer),
                ),
              ),
            ),
            SizedBox(height: spacing),
            SizedBox(
              height: buttonHeight + spacing, // Include spacing for "Virar" button
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: Size(180, buttonHeight),
                ),
                onPressed: () {
                  cardKey.currentState!.toggleCard();
                },
                child: Text('Virar'),
              ),
            ),
            SizedBox(height: spacing),
            Row(
              // Use a Row to ensure buttons are on the same row
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    height: buttonHeight + spacing, // Include spacing for rating buttons
                    child: _buildAnswerButton('Errei', Color(0xFFB00020), () {
                      _updateCardState(0);
                    }),
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: SizedBox(
                    height: buttonHeight + spacing, // Include spacing for rating buttons
                    child: _buildAnswerButton('Difícil', Color(0xFFFFA000), () {
                      _updateCardState(1);
                    }),
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: SizedBox(
                    height: buttonHeight + spacing, // Include spacing for rating buttons
                    child: _buildAnswerButton('Médio', Color(0xFF388E3C), () {
                      _updateCardState(2);
                    }),
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: SizedBox(
                    height: buttonHeight + spacing, // Include spacing for rating buttons
                    child: _buildAnswerButton('Fácil', Color(0xFF1976D2), () {
                      _updateCardState(3);
                    }),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildCardFace(String text) {
    return Container(
      height: 500,
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10.0)],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color,
        onPrimary: Colors.white,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void _updateCardState(int rating) {
    progressStore.updateProgress(flashcard.flashcardId, rating.toString());
    cardKey.currentState!.toggleCard();
    if ((currentIndex + 1) % flashcards.length == 0) {
      statsStore.updateDailyStatsForStudySession();
      print('DailyStats updated: ${statsStore.dailyStats.toString()}');
    }
  }
}
