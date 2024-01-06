import 'package:flutter/material.dart';
import 'package:ibet/models/bet.dart';
import 'package:ibet/screens/bets/bet_info.dart';
import 'package:ibet/services/firestore.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final betidController = TextEditingController();
  Bet? bet;
  Widget betWidget = const Text('');

  // init state
  @override
  void initState() {
    super.initState();
    betidController.text = '3UHUsRAQmdT2OLXVx2gg';
  }

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
                  // Check if bet is null
                  if (bet == null) {
                    betWidget = const Text('Bet not found',
                        style: TextStyle(color: Colors.red, fontSize: 20));
                  } else {
                    // Bet is found, update the widget
                    betWidget = InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BetScreen(bet: bet)));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Bet found!',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 20)),
                            Text('Bet name: ${bet.name}'),
                            Text('Bet description: ${bet.description}'),
                            Text('Bet ends: ${bet.ends}'),
                            Text('Bet entry points: ${bet.entrypoints}'),
                          ],
                        ),
                      ),
                    );
                  }
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
