import 'package:flutter/material.dart';

class AddBetScreen extends StatefulWidget {
  const AddBetScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AddBetScreenState();
}

class _AddBetScreenState extends State<AddBetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Bet')),
      body: const Center(
        child: Text('Add Bet'),
      ),
    );
  }
}
