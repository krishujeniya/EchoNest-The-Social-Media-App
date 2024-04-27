// ignore_for_file: file_names, library_private_types_in_public_api, camel_case_types

import 'package:flutter/material.dart';
import 'package:echonest/Screens/Login.dart';
import 'package:echonest/Screens/Register.dart';

class Check extends StatefulWidget {
  const Check({super.key});

  @override
  _CheckState createState() => _CheckState();
  
}

class _CheckState extends State<Check> {
    bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    return L_R(
            showLoginPage: showLoginPage,
            togglePages: togglePages,
          );
  }
}

class L_R extends StatelessWidget {
  final bool showLoginPage;
  final Function() togglePages;

  const L_R({
    super.key,
    required this.showLoginPage,
    required this.togglePages,
  });

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return Login(
        onTap: togglePages,
      );
    } else {
      return RegisterP(
        onTap: togglePages,
      );
    }
  }
}
