import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ibet/models/bet.dart';
import 'package:ibet/screens/bets/add_bet.dart';
import 'package:ibet/screens/bets/bet_screen.dart';
import 'package:ibet/screens/components/my_coin.dart';
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
      if (isWinnerPicked && myOption == winningOption) {
        return [const Color.fromARGB(255, 237, 239, 240), Colors.green[400]!];
      } else if (isWinnerPicked && myOption != winningOption) {
        return [const Color.fromARGB(255, 237, 239, 240), Colors.red[400]!];
      } else if (isTimeEnded && !isWinnerPicked) {
        return [const Color.fromARGB(255, 237, 239, 240), Colors.orange[400]!];
      } else if (!isTimeEnded) {
        return [const Color.fromARGB(255, 237, 239, 240), Colors.yellow[400]!];
      } else {
        return [const Color.fromARGB(255, 237, 239, 240), Colors.grey[400]!];
      }
    }

    // get gradient color
    

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
        title: Text(('My Created Bets'),
        style:TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: StreamBuilder(
        stream: FireStoreService()
            .getCreatedBets(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List bets = snapshot.data!.docs;
            // Sort the bets by:
            // First, if the bet has a winning option
            // Second, by the time left
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
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: getTileColor(betData, bet.id),
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.bento_outlined),
                      title: Text(betData['name']), 
                      subtitle: Row(
                      children: [                     
                      Text("${betData['entrypoints']}  "), // Your text
                      const MyCoin(), // Your icon
                      const SizedBox(width: 8.0),
                      ],    
                      ),               
                      // trailing with the time left, counting down
                      trailing: Text(
                        // here we show when from now the bet will end
                        //  if the bet is already over, we show 'Ended'
                        //  if the bet is still open, we show the time left in days, hours and minutes, use  premade functions to calculate
                        betData['winningoption'] != -1
                            ? 'Ended'
                            : betData['ends'] > now
                                ? '${((betData['ends'] - now) / 86400000).floor()}d ${(((betData['ends'] - now) % 86400000) / 3600000).floor()}h ${((((betData['ends'] - now) % 86400000) % 3600000) / 60000).floor()}m'
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
                    ),
                  ),
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
