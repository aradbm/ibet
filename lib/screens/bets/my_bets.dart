import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ibet/models/bet.dart';
import 'package:ibet/screens/bets/add_bet.dart';
import 'package:ibet/screens/bets/bet_screen.dart';
import 'package:ibet/screens/components/my_coin.dart';
import 'package:ibet/services/firestore.dart';

import '../components/gradient_space.dart';

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
    List<Color> getTileColor(Map<String, dynamic> betData, String betID) {
      Bet bet = Bet.fromJson(betData, betID);
      String myID = FirebaseAuth.instance.currentUser!.uid;
      Map<String, dynamic> userpicks = bet.userpicks as Map<String, dynamic>;
      int myOption = -1;
      if (userpicks[myID] != null) {
        myOption = int.parse(userpicks[myID]);
      }
      int winningOption = bet.winningoption;
      bool isTimeEnded = bet.ends < now;
      bool isWinnerPicked = winningOption != -1;
      // if bet is closed and I won - green
      // if bet is closed and I lost - red
      // if bet is open - yellow
      // if bet ended but the winner is not yet decided - orange
      // Define color variables
      const Color baseColor = Color.fromARGB(255, 237, 239, 240);
      final Color winColor = Colors.green[400]!;
      final Color loseColor = Colors.red[400]!;
      final Color undecidedColor = Colors.orange[400]!;
      final Color openBetColor = Colors.yellow[400]!;
      final Color defaultColor = Colors.grey[400]!;

      // Conditional logic to determine color
      if (isWinnerPicked && myOption == winningOption) {
        return [winColor, baseColor];
      } else if (isWinnerPicked && myOption != winningOption) {
        return [loseColor, baseColor];
      } else if (isTimeEnded && !isWinnerPicked) {
        return [undecidedColor, baseColor];
      } else if (!isTimeEnded) {
        return [openBetColor, baseColor];
      } else {
        return [defaultColor, baseColor];
      }
    }

    // get gradient color

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddBetScreen()));
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onPrimary,
          )),
      appBar: AppBar(
        flexibleSpace: const GradientSpace(),
        title: const Text(('My Created Bets')),
      ),
      body: StreamBuilder(
        stream: FireStoreService()
            .getCreatedBets(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List bets = snapshot.data!.docs;
            // Sort the bets by:bet has a winning option and by the time left
            bets.sort((a, b) {
              Map<String, dynamic> aData = a.data() as Map<String, dynamic>;
              Map<String, dynamic> bData = b.data() as Map<String, dynamic>;
              if (aData['winningoption'] != -1 &&
                  bData['winningoption'] == -1) {
                return 1;
              } else if (aData['winningoption'] == -1 &&
                  bData['winningoption'] != -1) {
                return -1;
              } else {
                return aData['ends'] - bData['ends'];
              }
            });
            if (bets.isEmpty) {
              return const Center(
                child: Text(
                  'You have not created any bets yet',
                  style: TextStyle(fontSize: 20),
                ),
              );
            }
            return ListView.builder(
              itemCount: bets.length,
              itemBuilder: (context, index) {
                DocumentSnapshot bet = bets[index];
                Map<String, dynamic> betData =
                    bet.data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            blurRadius: 2,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        leading: const Padding(
                          padding: EdgeInsets.only(left: 4.0),
                          child: MyCoin(),
                        ),
                        title: Text(
                          betData['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            "Entry points: ${betData['entrypoints']}  ",
                            style: const TextStyle(color: Colors.black)),
                        trailing: Text(
                          betData['winningoption'] != -1
                              ? 'Ended'
                              : betData['ends'] > now
                                  ? '${((betData['ends'] - now) / 86400000).floor()}d ${(((betData['ends'] - now) % 86400000) / 3600000).floor()}h ${((((betData['ends'] - now) % 86400000) % 3600000) / 60000).floor()}m'
                                  : 'Ended',
                          style: TextStyle(
                              color: betData['ends'] > now
                                  ? Colors.green[800]
                                  : Colors.grey[800]),
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
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 10,
                        decoration: BoxDecoration(
                          color: getTileColor(betData, bet.id)[0],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            bottomLeft: Radius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                  ]),
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
