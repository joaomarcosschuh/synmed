import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_flash/models/progress_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meu_flash/services/session_services/algorithm.dart';
import 'package:meu_flash/stores/stats_store.dart';

class ProgressStore extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final StatsStore _statsStore = StatsStore();

  Map<String, ProgressModel> _progress = {};
  List<String> _finishedCards = [];

  Map<String, ProgressModel> get progress => _progress;
  List<String> get finishedCards => _finishedCards;

  List<String> sortedFlashcards = [];

  Future<void> fetchProgress(List<String> flashcardIds) async {
    final user = _auth.currentUser;
    if (user == null) {
      print('No authenticated user found!');
      return;
    }
    var userId = user.uid;

    print('Fetching progress for flashcard IDs: $flashcardIds...');

    _progress.clear();

    for (String flashcardId in flashcardIds) {
      print('Fetching progress for flashcard ID: $flashcardId...');

      DocumentSnapshot documentSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('progress')
          .doc(flashcardId)
          .get();

      if (!documentSnapshot.exists) {
        print('No progress found for flashcard ID: $flashcardId, creating new...');

        ProgressModel newProgress = ProgressModel(
          documentId: flashcardId,
          currentStep: 0,
          flashcardId: flashcardId,
          nextReview: Timestamp.fromDate(DateTime.now()),
          phase: "Aprendizado",
          previousInterval: 0.0,
          quality: 0,
          repetitions: 0,
          steps: [1, 10],
          lapses: 0,
          factor: 0,
          isLeech: false,
        );
        _progress[flashcardId] = newProgress;

      } else {
        ProgressModel progress = ProgressModel.fromDocument(documentSnapshot);
        DateTime nextReviewDate = progress.nextReview.toDate();

        if (nextReviewDate.isAfter(DateTime.now())) {
          print('Skipping flashcard ID: $flashcardId as its next review is in the future!');
          continue;
        }

        print('Progress fetched for flashcard ID: $flashcardId!');
        _progress[flashcardId] = progress;
      }
    }

    print('Progress fetched successfully for flashcard IDs: $flashcardIds!');
    sortFlashcards();
    notifyListeners();
  }

  void sortFlashcards() {
    sortedFlashcards = _progress.entries
        .map((entry) => entry.key)
        .toList();

    sortedFlashcards.sort((a, b) {
      var aProgress = _progress[a];
      var bProgress = _progress[b];
      return (aProgress?.nextReview != null && bProgress?.nextReview != null)
          ? aProgress!.nextReview.toDate().compareTo(bProgress!.nextReview.toDate())
          : 0;
    });

    print("Sorted Flashcards: $sortedFlashcards");
  }

  Future<void> updateProgress(String flashcardId, String quality) async {
    final progressModel = _progress[flashcardId];
    if (progressModel != null) {
      StudyAlgorithm.updateProgress(progressModel, quality);

      print('Updated progress ID: $flashcardId, New values:');
      print(progressModel.toString());

      DateTime nextReviewDate = progressModel.nextReview.toDate();
      DateTime now = DateTime.now();
      if (nextReviewDate.day > now.day ||
          nextReviewDate.month > now.month ||
          nextReviewDate.year > now.year) {
        if (!_finishedCards.contains(flashcardId)) {
          _finishedCards.add(flashcardId);
          sortedFlashcards.remove(flashcardId);
        }
      }

      print("Study Cards: $sortedFlashcards");
      print("Finished Cards: $_finishedCards");

      if (_finishedCards.length >= 10 || sortedFlashcards.isEmpty) {
        await pushProgressToDatabase();
        _finishedCards.clear();
      }

      _statsStore.updateDailyStatsForStudySession();

      notifyListeners();
    } else {
      print('No progress found for flashcard ID: $flashcardId');
    }
  }

  Future<void> pushProgressToDatabase() async {
    final user = _auth.currentUser;
    if (user == null) {
      print('No authenticated user found!');
      return;
    }
    var userId = user.uid;

    for (String flashcardId in _finishedCards) {
      print('Pushing progress to database for flashcard ID: $flashcardId...');

      var progressModel = _progress[flashcardId];
      if (progressModel != null) {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('progress')
            .doc(flashcardId)
            .set(progressModel.toDocument(), SetOptions(merge: true));

        print('Progress pushed to database for flashcard ID: $flashcardId!');
      } else {
        print('No progress found for flashcard ID: $flashcardId');
      }
    }

    // Save daily stats to database
    String statsId = '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}';
    await _statsStore.saveStats(userId, statsId);

    print("Study Cards: $sortedFlashcards");
    print("Finished Cards: $_finishedCards");
  }

  bool isStudySessionFinished() {
    DateTime now = DateTime.now();
    for (var progress in _progress.values) {
      if (progress.nextReview.toDate().isBefore(now)) {
        return false;
      }
    }
    return true;
  }
}
