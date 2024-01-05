import 'package:flutter/material.dart';
import 'package:ibet/models/bet.dart';
import 'package:ibet/services/firestore.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // controller for the text field
  final betidController = TextEditingController();
  Bet? bet;
  Widget betWidget = const Text('aaa');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Bet')),
      body: Center(
        child: Column(
          children: [
            const Text('Find bets by bet id given by the creator of the bet:'),
            SizedBox(
              width: 300,
              child: TextField(
                controller: betidController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter bet id',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Bet? bet =
                    await FireStoreService().getBetByID(betidController.text);
                setState(() {
                  // if bet is null, show error message in dialog
                  if (bet == null) {
                    betWidget = const Text('Bet not found',
                        style: TextStyle(color: Colors.red, fontSize: 20));
                  }
                  // if bet is found, show bet
                  betWidget = Column(children: [
                    const Text('Bet found!',
                        style: TextStyle(color: Colors.green, fontSize: 20)),
                    Text('Bet name: ${bet!.name}'),
                    Text('Bet description: ${bet.description}'),
                    Text('Bet ends: ${bet.ends}'),
                  ]);
                });
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 20),
            betWidget,
          ],
        ),
      ),
    );
  }
}
