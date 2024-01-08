import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ibet/models/bet.dart';
import 'package:ibet/screens/bets/add_bet.dart';
import 'package:ibet/screens/bets/bet_info.dart';
import 'package:ibet/screens/bets/search_bet.dart';
import 'package:ibet/screens/components/info_dialog.dart';
import 'package:ibet/services/firestore.dart';

class BetsScreen extends StatefulWidget {
  const BetsScreen({super.key});

  @override
  State<BetsScreen> createState() => _BetsScreenState();
}

class _BetsScreenState extends State<BetsScreen> {
  @override
  Widget build(BuildContext context) {
    // calculate the current milliseconds from epoch
    final now = DateTime.now().millisecondsSinceEpoch;

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
          leading: IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const InfoWidget();
                },
              );
            },
          ),
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text('My Created Bets', style: TextStyle(fontSize: 20)),
              StreamBuilder(
                stream: FireStoreService()
                    .getCreatedBets(FirebaseAuth.instance.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List bets = snapshot.data!.docs;
                    return SizedBox(
                      height: 240,
                      child: ListView.builder(
                        itemCount: bets.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot bet = bets[index];
                          Map<String, dynamic> betData =
                              bet.data() as Map<String, dynamic>;
                          return ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),

                            tileColor: betData['winningoption'] == -1 &&
                                    betData['ends'] > now
                                ? const Color.fromARGB(255, 255, 255, 151)
                                : betData['winningoption'] == -1 &&
                                        betData['ends'] < now
                                    ? Colors.red[200]
                                    : betData['winningoption'] == 0
                                        ? Colors.green[200]
                                        : Colors.grey[400],
                            leading: const Icon(Icons.bento_outlined),
                            title: Text(betData['name']),
                            subtitle: Text(betData['entrypoints'].toString()),
                            // trailing with the time left, counting down
                            trailing: Text(
                              // here we show when from now the bet will end
                              //  if the bet is already over, we show 'Ended'
                              //  if the bet is still open, we show the time left in hours and minutes
                              betData['ends'] > now
                                  ? '${((betData['ends'] - now) / 3600000).floor()}h ${(((betData['ends'] - now) / 60000) % 60).floor()}m'
                                  : 'Ended',
                              style: TextStyle(
                                  color: betData['ends'] > now
                                      ? Colors.green[800]
                                      : Colors.redAccent),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BetScreen(
                                    bet: Bet.fromJson(betData, bet.id),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              const Text('Bets I Joined', style: TextStyle(fontSize: 20)),
              StreamBuilder(
                stream: FireStoreService()
                    .getJoinedBets(FirebaseAuth.instance.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List bets = snapshot.data!.docs;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: bets.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot bet = bets[index];
                          Map<String, dynamic> betData =
                              bet.data() as Map<String, dynamic>;
                          return ListTile(
                            tileColor: betData['winningoption'] == -1 &&
                                    betData['ends'] > now
                                ? const Color.fromARGB(255, 255, 255, 151)
                                : betData['winningoption'] == -1 &&
                                        betData['ends'] < now
                                    ? Colors.red[200]
                                    : betData['winningoption'] == 0
                                        ? Colors.green[200]
                                        : Colors.grey[400],
                            leading: const Icon(Icons.bento_outlined),
                            title: Text(betData['name']),
                            subtitle: Text(betData['entrypoints'].toString()),
                            // trailing with the time left, counting down
                            trailing: Text(
                              // here we show when from now the bet will end
                              //  if the bet is already over, we show 'Ended'
                              //  if the bet is still open, we show the time left in hours and minutes
                              betData['ends'] > now
                                  ? '${((betData['ends'] - now) / 3600000).floor()}h ${(((betData['ends'] - now) / 60000) % 60).floor()}m'
                                  : 'Ended',
                              style: TextStyle(
                                  color: betData['ends'] > now
                                      ? Colors.green[800]
                                      : Colors.redAccent),
                            ),

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
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ));
  }
}
