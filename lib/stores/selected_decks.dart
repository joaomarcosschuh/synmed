import 'package:flutter/material.dart';

class SelectedDecks extends ChangeNotifier {
  Map<String, Set<String>> _selectedDecksByCategory = {};
  String _selectedCategory = "";

  Map<String, Set<String>> get selectedDecksByCategory => _selectedDecksByCategory;
  String get selectedCategory => _selectedCategory;

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void addDeckToCategory(String category, String deck) {
    if (!_selectedDecksByCategory.containsKey(category)) {
      _selectedDecksByCategory[category] = {};
    }
    _selectedDecksByCategory[category]!.add(deck);
    notifyListeners();
  }

  void removeDeckFromCategory(String category, String deck) {
    if (_selectedDecksByCategory.containsKey(category)) {
      _selectedDecksByCategory[category]!.remove(deck);
      if (_selectedDecksByCategory[category]!.isEmpty) {
        _selectedDecksByCategory.remove(category);
      }
      notifyListeners();
    }
  }

  bool isSelectedInCategory(String category, String deck) {
    return _selectedDecksByCategory.containsKey(category) &&
        _selectedDecksByCategory[category]!.contains(deck);
  }
}
