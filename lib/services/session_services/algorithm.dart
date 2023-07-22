import 'package:meu_flash/models/progress_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class StudyAlgorithm {
  static const double EASY_FACTOR = 2.5;
  static const double MEDIUM_FACTOR = 1.9;
  static const double HARD_FACTOR = 1.3;

  static void updateProgress(ProgressModel progress, String quality) {
    double nextInterval = 0;

    if (progress.phase == "Aprendizado") {
      if (quality == 'again') {
        progress.currentStep = 0;
        progress.lapses += 1;
        progress.factor = max(1300, progress.factor - 200);
      } else {
        if (progress.currentStep >= progress.steps.length - 1) {
          progress.phase = "Revisão";
          nextInterval = 1.0; // Initial interval for review phase in days
        } else {
          progress.currentStep++;
        }
      }

      // In learning phase, the steps are in minutes
      if (progress.phase == "Aprendizado") {
        nextInterval = progress.steps[progress.currentStep].toDouble(); // in minutes
      }
    } else {
      switch (quality) {
        case 'easy':
          nextInterval = progress.previousInterval * EASY_FACTOR;
          progress.factor = max(1300, progress.factor - 200);
          break;
        case 'medium':
          nextInterval = progress.previousInterval * MEDIUM_FACTOR;
          progress.factor = max(1300, progress.factor - 100);
          break;
        case 'hard':
          nextInterval = progress.previousInterval * HARD_FACTOR;
          progress.factor = max(1300, progress.factor - 150);
          break;
        case 'again':
          progress.phase = "Aprendizado";
          progress.currentStep = 0;
          nextInterval = progress.steps[0].toDouble(); // in minutes
          progress.lapses += 1;
          progress.factor = max(1300, progress.factor - 200);
          break;
      }
    }

    progress.previousInterval = nextInterval;

    // Update next review based on interval
    Duration nextReviewDuration = progress.phase == "Aprendizado"
        ? Duration(minutes: nextInterval.round())
        : Duration(days: nextInterval.round());

    DateTime nextReview = DateTime.now().add(nextReviewDuration);
    progress.nextReview = Timestamp.fromDate(nextReview);

    // Update repetitions if quality is not 'Again'
    if (quality != 'again') {
      progress.repetitions++;
    }

    // Check for leech
    if (progress.lapses >= 8) {
      progress.isLeech = true;
    }

    print('Updated progress ID: ${progress.documentId}, New values: $progress');
  }
}


