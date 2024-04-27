// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:echonest/Constants/Constants.dart';
class RoundedButton extends StatelessWidget {
  final String btnText;
  final void Function()? onBtnPressed;

  const RoundedButton({super.key, required this.btnText, required this.onBtnPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: ThemeMain,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        onPressed: onBtnPressed,
        minWidth: 320,
        height: 60,
        child: Text(
          btnText,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
