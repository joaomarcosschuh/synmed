import 'package:flutter/material.dart';
import 'package:meu_flash/stores/flashcards_store.dart';
import 'package:meu_flash/stores/progress_store.dart';
import 'package:provider/provider.dart';

class DataFetch extends StatelessWidget {
  final List<String> deckIds;

  DataFetch({required this.deckIds});

  @override
  Widget build(BuildContext context) {
    FlashcardsStore flashcardsStore = Provider.of<FlashcardsStore>(context, listen: false);
    ProgressStore progressStore = Provider.of<ProgressStore>(context, listen: false);

    try {
      print('Fetching flashcards for selected decks...'); // Aviso sobre a etapa atual
      // Buscar os flashcards para os baralhos selecionados
      flashcardsStore.fetchFlashcards(deckIds);
      print('Flashcards fetched successfully!'); // Aviso sobre a etapa concluída com sucesso

      print('Fetching progress for selected flashcards...'); // Aviso sobre a etapa atual
      // Extrair os IDs dos flashcards para buscar o progresso correspondente
      List<String> flashcardIds = flashcardsStore.flashcards.map((flashcard) => flashcard.flashcardId).toList();
      // Buscar o progresso para os flashcards selecionados
      progressStore.fetchProgress(flashcardIds);
      print('Progress fetched successfully!'); // Aviso sobre a etapa concluída com sucesso
    } catch (error) {
      print('Error fetching data: $error'); // Aviso sobre a etapa que gerou um erro
    }

    return Container(); // retorna um widget vazio, já que essa classe só existe para buscar dados
  }
}
