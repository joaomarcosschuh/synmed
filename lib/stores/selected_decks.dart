import 'package:flutter/material.dart';

class SelectedDecks extends ChangeNotifier {
  Set<String> _selectedDecks = {};

  Set<String> get selectedDecks => _selectedDecks;

  void addDeck(String deck) {
    _selectedDecks.add(deck);
    notifyListeners();
  }

  void removeDeck(String deck) {
    _selectedDecks.remove(deck);
    notifyListeners();
  }

  void clearDecks() {
    _selectedDecks.clear();
    notifyListeners();
  }
}
