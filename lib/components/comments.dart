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
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //comment
          Text(text),
          const SizedBox(
            height: 5.0,
          ),
          //user, time
          Row(
            children: [
              Text(
                user,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const Text(" • "),
              Text(
                time,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          )
        ],
      ),
    );
  }
}
