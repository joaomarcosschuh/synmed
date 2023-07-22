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
  int lapses; // Número de falhas
  int factor; // Fator de dificuldade
  bool isLeech; // Indica se o cartão é um "sanguessuga"

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
    ''';
  }
}
