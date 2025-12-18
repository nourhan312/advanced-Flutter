import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  final String data;

  const SecondScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Screen')),
      body: Center(
        child: Text(
          "Received Data: $data",
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
