import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ibet/models/bet.dart';
import 'package:ibet/services/firestore.dart';

class BetScreen extends StatefulWidget {
  const BetScreen({super.key, required this.bet});
  final Bet bet;
  @override
  State<BetScreen> createState() => _BetScreenState();
}

class _BetScreenState extends State<BetScreen> {
  int? selectedOption;
  bool b1 = true;

  @override
  Widget build(BuildContext context) {
    Bet bet = widget.bet;
    final user = FirebaseAuth.instance.currentUser;
    bool isCreator = bet.betopener == user!.uid;

    if (bet.userpicks.containsKey(user.uid) && b1) {
      selectedOption = int.parse(bet.userpicks[user.uid]);
      b1 = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bet Info'),
        backgroundColor: Colors.blue,
        actions: [
          if (isCreator)
            IconButton(
              onPressed: () {
                // delete the bet
                // dialog to confirm
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Delete Bet"),
                      content: const Text(
                          "Are you sure you want to delete this bet?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            // delete the bet
                            FireStoreService().deleteBet(bet.betid);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text("Delete"),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bet Name: ${bet.name}", style: const TextStyle(fontSize: 20)),
            Text("Bet Description: ${bet.description}"),
            Text("Bet entry point: ${bet.entrypoints}"),
            const SizedBox(height: 20),
            const Text("Bet Options:", style: TextStyle(fontSize: 20)),
            // show here all the options
            Expanded(
              child: ListView.builder(
                itemCount: bet.options.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(bet.options[index]),
                    leading: Radio<int>(
                      value: index,
                      groupValue: selectedOption,
                      onChanged: (int? value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (selectedOption != null) {
                      setState(() {
                        bet.userpicks[user.uid] = selectedOption.toString();
                        FireStoreService().updateBet(bet);

                        // do the following if the user is not already in the bet
                        if (!bet.userpicks.containsKey(user.uid)) {
                          // now update user points, send a negative value
                          FireStoreService()
                              .updateUserPoints(user.uid, -1 * bet.entrypoints);
                        }
                      });
                      // show snackbar to confirm
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Bet Placed!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: const Text('Place Bet'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // remove user from bet
                    FireStoreService().removeUserFromBet(
                        bet.betid, user.uid, bet.entrypoints);
                    // show snackbar to confirm
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Bet Removed!"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Get out of Bet'),
                ),
              ],
            ),
            // show all participants usernames
            const SizedBox(height: 20),
            const Text("Current Participants:", style: TextStyle(fontSize: 20)),
            Expanded(
              child: ListView.builder(
                itemCount: bet.userpicks.length,
                itemBuilder: (context, index) {
                  if (isCreator) {
                    return ListTile(
                      title: Text(bet.userpicks.keys.elementAt(index)),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            FireStoreService().removeUserFromBet(
                                bet.betid,
                                bet.userpicks.keys.elementAt(index),
                                bet.entrypoints);
                            bet.userpicks
                                .remove(bet.userpicks.keys.elementAt(index));
                            FireStoreService().updateBet(bet);
                          });
                        },
                        icon: const Icon(Icons.delete),
                      ),
                      subtitle: Text(
                          // show the index + 1
                          "Chose option: ${int.parse(bet.userpicks.values.elementAt(index)) + 1}"),
                    );
                  } else {
                    return ListTile(
                      title: Text(bet.userpicks.keys.elementAt(index)),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
