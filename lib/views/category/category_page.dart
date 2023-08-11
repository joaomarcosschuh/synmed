import 'package:flutter/material.dart';
import 'package:meu_flash/controllers/get_categories.dart';
import 'package:meu_flash/models/deck_checkbox.dart';
import 'package:provider/provider.dart';
import 'package:meu_flash/stores/selected_decks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                                return ListTile(
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage(
                                      'lib/assets/${category.toLowerCase()}.jpg',
                                    ),
                                  ),
                                  title: Text(category),
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
        );
      },
    );
  }
}
