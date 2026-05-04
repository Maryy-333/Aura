// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  void Function()? onTap;

  LikeButton({super.key, required this.isLiked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border_outlined,
        color: isLiked ? const Color.fromARGB(255, 191, 26, 54) : Colors.grey,
      ),
    );
  }
}
