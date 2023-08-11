import 'package:flutter/material.dart';
import 'package:meu_flash/models/flashcard_model.dart';
import 'creating_cards_widget.dart';
import 'package:flip_card/flip_card.dart';

class CreatingCardsPage extends StatelessWidget {
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  final FlashcardModel flashcard = FlashcardModel(
    documentId: 'documentId goes here',
    deck: 'deck goes here',
    category: 'category goes here',
    flashcardId: 'flashcardId goes here',
    flashcardQuestion: 'Question goes here',
    flashcardAnswer: 'Answer goes here',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF14293D),
      appBar: AppBar(
        title: Text('Creating Cards Page'),
      ),
      body: Center(
        child: CreatingCardsWidget(
          cardKey: cardKey,
          flashcard: flashcard,
        ),
      ),
    );
  }
}
