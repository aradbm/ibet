import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ibet/models/bet.dart';
import 'package:ibet/screens/bets/add_bet.dart';
import 'package:ibet/screens/bets/bet_screen.dart';
import 'package:ibet/services/firestore.dart';

class MyBetsScreen extends StatefulWidget {
  const MyBetsScreen({super.key});

  @override
  State<MyBetsScreen> createState() => _MyBetsScreenState();
}

class _MyBetsScreenState extends State<MyBetsScreen> {
  @override
  Widget build(BuildContext context) {
    // calculate the current milliseconds from epoch
    final now = DateTime.now().millisecondsSinceEpoch;

    // function to get tile color
    Color getTileColor(Map<String, dynamic> betData, String betID) {
      Bet bet = Bet.fromJson(betData, betID);
      String myID = FirebaseAuth.instance.currentUser!.uid;
      Map<String, int> userPicks = bet.userpicks.cast<String, int>();
      // print(bet.userpicks);
      // print(myID);

      // find in userPicks the option that myID chose
      int myOptionIndex = userPicks.keys.toList().indexOf(myID);
      int winningOption = bet.winningoption;
      bool isEnded = bet.ends < now;
      bool isPicked = winningOption != -1;

      // if bet is closed and I won - green
      // if bet is closed and I lost - red
      // if bet is open - yellow
      // if bet ended but the winner is not yet decided - orange

      if (isEnded && isPicked && myOptionIndex == winningOption) {
        return Colors.green[200]!;
      } else if (isEnded && isPicked && myOptionIndex != winningOption) {
        return Colors.red[200]!;
      } else if (isEnded && !isPicked) {
        return Colors.orange[200]!;
      } else if (!isEnded) {
        return Colors.yellow[200]!;
      } else {
        return Colors.grey[400]!;
      }
    }

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
        title: const Text('My Created Bets'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: StreamBuilder(
        stream: FireStoreService()
            .getCreatedBets(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List bets = snapshot.data!.docs;
            if (bets.isEmpty) {
              return const Center(
                child: Text('You have not created any bets yet',
                    style: TextStyle(fontSize: 20)),
              );
            }
            return ListView.builder(
              itemCount: bets.length,
              itemBuilder: (context, index) {
                DocumentSnapshot bet = bets[index];
                Map<String, dynamic> betData =
                    bet.data() as Map<String, dynamic>;
                return ListTile(
                  tileColor: getTileColor(betData, bet.id),
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
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
