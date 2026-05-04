// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
  void Function()? onTap;
  CommentButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(Icons.comment, color: Colors.grey),
    );
  }
}
