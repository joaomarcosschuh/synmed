import 'package:flutter/material.dart';

class LoadingUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: Image.asset(
              'lib/assets/med1.gif',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

