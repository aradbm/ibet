import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ibet/models/bet.dart';
import 'package:ibet/screens/bets/add_bet.dart';
import 'package:ibet/screens/bets/bet_info.dart';
import 'package:ibet/screens/bets/search_bet.dart';
import 'package:ibet/services/firestore.dart';

class BetsScreen extends StatefulWidget {
  const BetsScreen({super.key});

  @override
  State<BetsScreen> createState() => _BetsScreenState();
}

// // list of bets
// final List<Bet> _bets = [
//   // create fake data
//   Bet(
//     betid: '123123',
//     betopener: '123123',
//     ends: DateTime.now().microsecond,
//     name: 'billabord 100',
//     description: 'taylor swift again number 1',
//     entrypoints: 30,
//     options: ['asd', 'asdwwda', 'ASDWss'],
//     users: ['123123', '12341'],
//   ),
//   Bet(
//     betid: '123123',
//     betopener: '123123',
//     ends: DateTime.now().microsecond,
//     name: 'billabord 100',
//     description: 'taylor swift again number 1',
//     entrypoints: 30,
//     options: ['asd', 'asdwwda', 'ASDWss'],
//     users: ['123123', '12341'],
//   ),
// ];

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
        body: StreamBuilder(
          stream: FireStoreService().getBets(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List bets = snapshot.data!.docs;

              return ListView.builder(
                itemCount: bets.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot bet = bets[index];
                  Map<String, dynamic> betData =
                      bet.data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text(betData['name']),
                    subtitle: Text(betData['entrypoints'].toString()),
                    // trailing with the time left, counting down
                    trailing: Text(
                        DateTime.fromMicrosecondsSinceEpoch(betData['ends'])
                            .toString()),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BetScreen(
                                  bet: Bet.fromJson(betData, bet.id),
                                )),
                      );
                    },
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
