import 'package:flutter/material.dart';

class BetScreen extends StatefulWidget {
  const BetScreen({super.key, required this.betid});
  final int betid;
  @override
  State<BetScreen> createState() => _BetScreenState();
}

class _BetScreenState extends State<BetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bet'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('Bet ${widget.betid}'),
      ),
    );
  }
}
