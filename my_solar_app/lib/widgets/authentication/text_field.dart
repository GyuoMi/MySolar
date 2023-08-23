import 'package:flutter/material.dart';


class AuthenticationTextField extends StatelessWidget{
  final controller;
  final String hintText;
  final bool obscureText;

  const AuthenticationTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
});

  @override
  Widget build(BuildContext context) {
    return
      SizedBox(
        width: 300,
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(),
            labelText: hintText
            )
      )

    );
  }
}