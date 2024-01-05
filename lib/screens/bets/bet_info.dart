import 'package:flutter/material.dart';
import 'package:ibet/models/bet.dart';

class BetScreen extends StatefulWidget {
  const BetScreen({super.key, required this.bet});
  final Bet bet;
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
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 200, width: 200),
          Text(widget.bet.name, style: const TextStyle(fontSize: 30)),
          Text(widget.bet.description),
          Text(widget.bet.entrypoints.toString()),
          Text(widget.bet.ends.toString()),
          Text(widget.bet.options.toString()),
          Text(widget.bet.users.toString()),
        ],
      )),
    );
  }
}
