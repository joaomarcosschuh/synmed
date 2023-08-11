import 'package:flutter/material.dart';
import 'package:meu_flash/controllers/get_categories.dart';
import 'package:meu_flash/stores/selected_decks.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final GetCategories _getCategories = GetCategories();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedDecks>(
      builder: (context, selectedDecks, _) {
        bool hasSelectedDecks =
            selectedDecks.selectedDecksByCategory[selectedDecks.selectedCategory]?.isNotEmpty ?? false;

        return Scaffold(
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 10),
                          blurRadius: 10.0,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.only(left: 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: FutureBuilder<Map<String, Set<String>>>(
                        future: _getCategories.fetchCategoriesAndDecks(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            final categories = snapshot.data!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: categories.keys.map((category) {
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 0.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.black,
                                  ),
                                  child: Theme(
                                    data: ThemeData(
                                      textTheme: TextTheme(
                                        subtitle1: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      unselectedWidgetColor: Colors.white,
                                    ),
                                    child: ExpansionTile(
                                      leading: CircleAvatar(
                                        radius: 20,
                                        backgroundImage: AssetImage(
                                          'lib/assets/${category.toLowerCase()}.jpg',
                                        ),
                                      ),
                                      title: Text(category),
                                      children: [],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(height: 500),
              ],
            ),
          ),
          floatingActionButton: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(bottom: 16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 200.0,
                height: 40.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () {
                    if (hasSelectedDecks) {
                      Navigator.pushNamed(
                        context,
                        '/loading',
                        arguments: selectedDecks.selectedDecksByCategory[selectedDecks.selectedCategory]?.toList() ?? [],
                      );
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        hasSelectedDecks ? "Estudar" : "Selecione um tema",
                        style: TextStyle(
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
