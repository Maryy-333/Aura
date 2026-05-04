import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;
  const Comment({
    super.key,
    required this.text,
    required this.user,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 32, 47, 45),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(bottom: 12, left: 15, right: 15),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // comment
          Text(text, style: TextStyle(color: Colors.white)),

          const SizedBox(height: 5),

          // user , time
          Row(
            children: [
              Text(
                user,
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
              Text(
                " + ",
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
              Text(
                time,
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
