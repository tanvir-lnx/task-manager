import 'package:flutter/material.dart';

class TaskState extends StatelessWidget {
  final String state;
  final int number;
  const TaskState({required this.number, required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 95,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            number.toString(),
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
          ),
          Text(state),
        ],
      ),
    );
  }
}
