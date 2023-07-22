import 'package:flutter/material.dart';
import 'package:meu_flash/views/profile/profile_page.dart';
import 'package:meu_flash/views/category/category_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu Flash',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainViewPage(),
    );
  }
}

class MainViewPage extends StatefulWidget {
  @override
  _MainViewPageState createState() => _MainViewPageState();
}

class _MainViewPageState extends State<MainViewPage> {
  int _selectedIndex = 0;
  final _pages = [
    CategoryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: _pages[_selectedIndex],
      backgroundColor: Color(0xFF302B2B),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF302B2B),
        selectedItemColor: Colors.white60,
        unselectedItemColor: Colors.white38,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('lib/assets/icons/cards.png'),
              // Change the image size as needed
              size: 40.0,
            ),
            label: '', // Set label to an empty string
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today), // Use the calendar icon
            label: '', // Set label to an empty string
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        showSelectedLabels: false, // Hide the selected labels
        showUnselectedLabels: false, // Hide the unselected labels
      ),
    );
  }
}
