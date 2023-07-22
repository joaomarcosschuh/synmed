import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_flash/models/flashcard_model.dart';

class FlashcardsStore extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<FlashcardModel> _flashcards = [];

  List<FlashcardModel> get flashcards => _flashcards;

  Future<void> fetchFlashcards(List<String> deckIds) async {
    try {
      print('Fetching flashcards for deck IDs: $deckIds...'); // Aviso sobre a etapa atual

      _flashcards.clear();
      for (String deckId in deckIds) {
        print('Fetching flashcards for deck ID: $deckId...'); // Aviso sobre a etapa atual
        QuerySnapshot querySnapshot = await _firestore.collection('flashcards').where('Baralho', isEqualTo: deckId).get();
        print('Flashcards fetched for deck ID: $deckId!'); // Aviso sobre a etapa concluída com sucesso
        for (var doc in querySnapshot.docs) {
          _flashcards.add(FlashcardModel.fromDocument(doc));
        }
      }

      print('Flashcards fetched successfully for deck IDs: $deckIds!'); // Aviso sobre a etapa concluída com sucesso
    } catch (error) {
      print('Error fetching flashcards: $error'); // Aviso sobre a etapa que gerou um erro
    }
    notifyListeners();
  }
}
