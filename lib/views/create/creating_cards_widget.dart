import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:meu_flash/models/flashcard_model.dart';

class CreatingCardsWidget extends StatelessWidget {
  final GlobalKey<FlipCardState> cardKey;
  final FlashcardModel flashcard;

  CreatingCardsWidget({required this.cardKey, required this.flashcard});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = constraints.maxHeight;

        // Relative sizes
        final cardHeightPercentage = 0.6; // 60% of the screen height

        final cardHeight = screenHeight * cardHeightPercentage;

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
}
