import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ibet/models/bet.dart';
import 'package:ibet/screens/bets/bet_screen.dart';
import 'package:ibet/screens/bets/search_bet.dart';
import 'package:ibet/services/firestore.dart';

class JoinedBetsScreen extends StatefulWidget {
  const JoinedBetsScreen({super.key});

  @override
  State<JoinedBetsScreen> createState() => _JoinedBetsScreenState();
}

class _JoinedBetsScreenState extends State<JoinedBetsScreen> {
  @override
  Widget build(BuildContext context) {
    // calculate the current milliseconds from epoch
    final now = DateTime.now().millisecondsSinceEpoch;

    // function to get tile color
    Color getTileColor(Map<String, dynamic> betData) {
      Bet bet = Bet.fromJson(betData, betData['betuid']);
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
      appBar: AppBar(
        title: const Text('My Joined Bets'),
        backgroundColor: Theme.of(context).primaryColor,
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
      body: SafeArea(
        child: StreamBuilder(
          stream: FireStoreService()
              .getJoinedBets(FirebaseAuth.instance.currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List bets = snapshot.data!.docs;
              if (bets.isEmpty) {
                return const Center(
                  child: Text('You have not joined any bets yet'),
                );
              }
              return ListView.builder(
                itemCount: bets.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot bet = bets[index];
                  Map<String, dynamic> betData =
                      bet.data() as Map<String, dynamic>;
                  // here we show each bet that the user has joined
                  // we retrurn a container with the bet name, the entry points and the time left

                  return ListTile(
                    // i send the winnign option, the end time to the getTileColor function
                    // and the option I chose
                    tileColor: getTileColor(betData),
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
      ),
    );
  }
}
