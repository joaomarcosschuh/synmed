import 'package:flutter/material.dart';
import 'package:meu_flash/models/deck_checkbox.dart';
import 'package:provider/provider.dart';
import 'package:meu_flash/stores/selected_decks.dart';


class DecksPage extends StatelessWidget {
  final String category;

  DecksPage({required this.category});

  @override
  Widget build(BuildContext context) {
    final selectedDecks = Provider.of<SelectedDecks>(context);
    final decks = selectedDecks.selectedDecksByCategory[category] ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: decks.map((deck) {
            return DeckCheckbox(
              deck: deck,
              initialValue: selectedDecks.isSelectedInCategory(category, deck),
              onChanged: (selected) {
                if (selected) {
                  selectedDecks.addDeckToCategory(selectedDecks.selectedCategory, deck);
                } else {
                  selectedDecks.removeDeckFromCategory(selectedDecks.selectedCategory, deck);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
