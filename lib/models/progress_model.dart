import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProgressModel {
  String documentId;
  int currentStep;
  String flashcardId;
  Timestamp nextReview;
  String phase;
  double previousInterval;
  int quality;
  int repetitions;
  List<int> steps;
  int lapses;
  int factor;
  bool isLeech;
  String like; // Novo campo 'like'
  String dislike; // Novo campo 'dislike'

  ProgressModel({
    required this.documentId,
    required this.currentStep,
    required this.flashcardId,
    required this.nextReview,
    required this.phase,
    required this.previousInterval,
    required this.quality,
    required this.repetitions,
    required this.steps,
    required this.lapses,
    required this.factor,
    required this.isLeech,
    this.like = 'nao', // Definir valor padrão como 'nao'
    this.dislike = 'nao', // Definir valor padrão como 'nao'
  });

  factory ProgressModel.fromDocument(DocumentSnapshot doc) {
    return ProgressModel(
      documentId: doc.id,
      currentStep: doc['currentStep'],
      flashcardId: doc['flashcardId'],
      nextReview: doc['nextReview'],
      phase: doc['phase'],
      previousInterval: doc['previousInterval'].toDouble(),
      quality: doc['quality'],
      repetitions: doc['repetitions'],
      steps: List<int>.from(doc['steps']),
      lapses: doc['lapses'],
      factor: doc['factor'],
      isLeech: doc['isLeech'],
      like: doc['like'], // Adicionando os novos campos aqui
      dislike: doc['dislike'], // Adicionando os novos campos aqui
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'currentStep': currentStep,
      'flashcardId': flashcardId,
      'nextReview': nextReview,
      'phase': phase,
      'previousInterval': previousInterval,
      'quality': quality,
      'repetitions': repetitions,
      'steps': steps,
      'lapses': lapses,
      'factor': factor,
      'isLeech': isLeech,
      'like': like, // Adicionando os novos campos aqui
      'dislike': dislike, // Adicionando os novos campos aqui
    };
  }

  @override
  String toString() {
    DateTime nextReviewDate = nextReview.toDate();
    String formattedNextReviewDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(nextReviewDate);

    return '''
      documentId: $documentId
      flashcardId: $flashcardId
      currentStep: $currentStep
      nextReview: $formattedNextReviewDate
      phase: $phase
      previousInterval: $previousInterval
      quality: $quality
      repetitions: $repetitions
      steps: ${steps.join(", ")}
      lapses: $lapses
      factor: $factor
      isLeech: $isLeech
      like: $like
      dislike: $dislike
    ''';
  }
}
