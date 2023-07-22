import 'package:cloud_firestore/cloud_firestore.dart';

class FlashcardModel {
  String documentId;
  String deck;
  String category;
  String flashcardId;
  String flashcardQuestion;
  String flashcardAnswer;

  FlashcardModel({required this.documentId, required this.deck, required this.category, required this.flashcardId, required this.flashcardQuestion, required this.flashcardAnswer});

  // Método para converter um documento do Firestore em um objeto FlashcardModel
  factory FlashcardModel.fromDocument(DocumentSnapshot doc) {
    return FlashcardModel(
      documentId: doc.id,
      deck: doc['Baralho'],
      category: doc['Categoria'],
      flashcardId: doc['ID do Flashcard'],
      flashcardQuestion: doc['Pergunta do Flashcard'],
      flashcardAnswer: doc['Resposta do Flashcard'],
    );
  }

  // Método para converter um objeto FlashcardModel de volta em um Map que pode ser usado com o Firestore
  Map<String, dynamic> toDocument() {
    return {
      'Baralho': deck,
      'Categoria': category,
      'ID do Flashcard': flashcardId,
      'Pergunta do Flashcard': flashcardQuestion,
      'Resposta do Flashcard': flashcardAnswer,
    };
  }
}
