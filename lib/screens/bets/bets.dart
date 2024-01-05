import 'package:flutter/material.dart';
import 'package:ibet/models/bet.dart';
import 'package:ibet/screens/bets/add_bet.dart';
import 'package:ibet/screens/bets/bet_info.dart';
import 'package:ibet/screens/bets/search_bet.dart';

class BetsScreen extends StatefulWidget {
  const BetsScreen({super.key});

  @override
  State<BetsScreen> createState() => _BetsScreenState();
}

// list of bets
final List<Bet> _bets = [
  // create fake data
  Bet(
    betuid: '123123',
    betopener: '123123',
    ends: DateTime.now(),
    name: 'billabord 100',
    description: 'taylor swift again number 1',
    entrypoints: 30,
    options: ['asd', 'asdwwda', 'ASDWss'],
    users: ['123123', '12341'],
  ),
  Bet(
    betuid: '123123',
    betopener: '123123',
    ends: DateTime.now(),
    name: 'billabord 100',
    description: 'taylor swift again number 1',
    entrypoints: 30,
    options: ['asd', 'asdwwda', 'ASDWss'],
    users: ['123123', '12341'],
  ),
];

class _BetsScreenState extends State<BetsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddBetScreen()));
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Bets'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
          child: ListView.builder(
        itemCount: _bets.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              tileColor: Colors.grey[300],
              title: Text(_bets[index].name),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BetScreen(bet: _bets[index]),
                  ),
                );
              },
            ),
          );
        },
      )),
    );
  }
}
