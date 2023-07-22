import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:meu_flash/stores/flashcards_store.dart';
import 'package:meu_flash/stores/progress_store.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  Future<void>? _loadingFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadingFuture == null) {
      List<String> selectedDecks = ModalRoute.of(context)!.settings.arguments as List<String>;
      _loadingFuture = _loadData(selectedDecks);
    }
  }

  Future<void> _loadData(List<String> selectedDecks) async {
    await Provider.of<FlashcardsStore>(context, listen: false)
        .fetchFlashcards(selectedDecks);

    List<String> flashcardIds = Provider.of<FlashcardsStore>(context, listen: false)
        .flashcards
        .map((flashcard) => flashcard.flashcardId)
        .toList();

    await Provider.of<ProgressStore>(context, listen: false)
        .fetchProgress(flashcardIds);

    Navigator.pushNamed(context, '/study');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF), // Background color
      body: FutureBuilder<void>(
        future: _loadingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  'lib/assets/intro/intro_load.gif',
                  fit: BoxFit.cover,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred!'));
          } else {
            return Center(child: Text('Done loading!'));
          }
        },
      ),
    );
  }
}
