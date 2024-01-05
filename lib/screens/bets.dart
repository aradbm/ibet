import 'package:flutter/material.dart';
import 'package:ibet/screens/add_bet.dart';
import 'package:ibet/screens/bet_info.dart';
import 'package:ibet/screens/search_bet.dart';

class BetsPage extends StatefulWidget {
  const BetsPage({super.key});

  @override
  State<BetsPage> createState() => _BetsPageState();
}

// list of bets
final List<String> _bets = <String>['Bet 1', 'Bet 2', 'Bet 3'];

class _BetsPageState extends State<BetsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bets'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddBetScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
          child: ListView.builder(
        itemCount: _bets.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            tileColor: Colors.grey[300],
            title: Text(_bets[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BetScreen(betid: index)),
              );
            },
          );
        },
      )),
    );
  }
}
