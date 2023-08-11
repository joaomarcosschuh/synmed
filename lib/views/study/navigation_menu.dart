import 'package:flutter/material.dart';

class NavigationMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTap;

  NavigationMenu({required this.selectedIndex, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Color(0xFF14293D),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset('lib/assets/simbolos/baralhos.png', width: 45, height: 45),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('lib/assets/simbolos/medalha.png', width: 45, height: 45),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('lib/assets/simbolos/professor1.png', width: 45, height: 45),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('lib/assets/simbolos/add.png', width: 45, height: 45),
            label: '',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: onItemTap,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Color(0xFF14293D), // Adicionando a cor de fundo
      ),
    );
  }
}

