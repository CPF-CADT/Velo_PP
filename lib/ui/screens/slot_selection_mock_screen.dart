import 'package:flutter/material.dart';

class SlotSelectionMockScreen extends StatelessWidget {
  final String stationName;

  const SlotSelectionMockScreen({super.key, required this.stationName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Slot Selection')),
      body: Center(
        child: Text(
          stationName,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
