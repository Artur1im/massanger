import 'package:flutter/material.dart';

class MTF extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  const MTF(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            hintText: hintText,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            fillColor: Colors.grey[350],
            filled: true,
            hintStyle: const TextStyle(color: Colors.white)));
  }
}
