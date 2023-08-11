import 'package:flutter/material.dart';
import 'package:meu_flash/stores/selected_decks.dart';
import 'package:provider/provider.dart';

class DecksPage extends StatelessWidget {
  final Set<String> decks;

  DecksPage({required this.decks});

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedDecks>(
      builder: (context, selectedDecks, _) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: ListView.builder(
            itemCount: decks.length,
            itemBuilder: (context, index) {
              String deck = decks.elementAt(index);
              return CheckboxListTile(
                title: Text(deck),
                value: selectedDecks.isSelected(deck),
                onChanged: (value) {
                  if (value == true) {
                    selectedDecks.addDeck(deck);
                  } else {
                    selectedDecks.removeDeck(deck);
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
