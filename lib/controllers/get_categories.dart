import 'package:cloud_firestore/cloud_firestore.dart';

class GetCategories {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, Set<String>>> fetchCategoriesAndDecks() async {
    try {
      print('Fetching categories and decks...'); // Aviso sobre a etapa atual
      QuerySnapshot querySnapshot = await _firestore.collection('flashcards').get();
      print('Categories and decks fetched successfully!'); // Aviso sobre a etapa concluída com sucesso

      Map<String, Set<String>> categories = {};
      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String category = data['Categoria'] as String? ?? '';
          String deck = data['Baralho'] as String? ?? '';
          if (categories[category] == null) {
            categories[category] = Set<String>();
          }
          categories[category]!.add(deck);
        }
      }

      return categories;
    } catch (error) {
      print('Error fetching categories and decks: $error'); // Aviso sobre a etapa que gerou um erro
      return {};
    }
  }
}
