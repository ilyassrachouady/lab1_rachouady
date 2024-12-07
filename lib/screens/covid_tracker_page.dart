import 'package:flutter/material.dart';

class CovidTrackerPage extends StatelessWidget {
  const CovidTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('COVID Tracker')),
      body: const Center(
        child: Text(
          'Welcome to the COVID Tracker!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
