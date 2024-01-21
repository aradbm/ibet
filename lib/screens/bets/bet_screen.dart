// ignore_for_file: use_build_context_synchronously

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
  final addOptionController = TextEditingController();
  int winningoption = -1;

  @override
  Widget build(BuildContext context) {
    Bet bet = widget.bet;
    final user = FirebaseAuth.instance.currentUser;
    bool isCreator = bet.betopener == user!.uid;

    if (bet.userpicks.containsKey(user.uid) && b1) {
      selectedOption = int.parse(bet.userpicks[user.uid]);
      b1 = false;
    }

    // to be chosen as the winner for the creator
    return Scaffold(
      appBar: AppBar(
        title: isCreator
            ? const Text('Update Bet Screen')
            : const Text('Bet Info'),
        backgroundColor: Colors.blue,
        actions: [
          if (isCreator && bet.winningoption == -1)
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
            Row(
              children: [
                const Text("Bet Options:", style: TextStyle(fontSize: 20)),
                const Spacer(),
                if (isCreator && bet.winningoption == -1)
                  IconButton(
                    onPressed: () {
                      // add option
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Add Option"),
                            content: TextField(
                              onChanged: (value) {
                                setState(() {
                                  addOptionController.text = value;
                                });
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  addOptionController.text = "";
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    bet.options.add(addOptionController.text);
                                  });
                                  FireStoreService().updateBet(bet);
                                  Navigator.pop(context);
                                },
                                child: const Text("Add"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.add),
                  ),
                if (isCreator && bet.winningoption == -1)
                  IconButton(
                      onPressed: () {
                        // pick the winner
                        if (winningoption != -1) {
                          setState(() {
                            Bet updatedBet = Bet(
                              betid: bet.betid,
                              betopener: bet.betopener,
                              ends: bet.ends,
                              name: bet.name,
                              description: bet.description,
                              entrypoints: bet.entrypoints,
                              options: bet.options,
                              userpicks: bet.userpicks,
                              winningoption: winningoption,
                            );
                            FireStoreService().updateBet(updatedBet);
                            bet = updatedBet;
                          });

                          // update the points
                          FireStoreService()
                              .betDone(bet.betid, bet.winningoption);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Winner Chosen!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          // get back
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select a winner!"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.expand_circle_down_outlined)),
              ],
            ),
            // show here all the options
            Expanded(
              child: ListView.builder(
                itemCount: bet.options.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    tileColor: bet.winningoption == index
                        ? Colors.green[100]
                        : Colors.white,
                    title: Text(bet.options[index]),
                    // only for creator, show the radio button to choose the winner
                    trailing: isCreator && bet.winningoption == -1
                        ? Radio<int>(
                            value: index,
                            groupValue: winningoption,
                            onChanged: (int? value) {
                              setState(() {
                                winningoption = value!;
                              });
                            },
                          )
                        : null,
                    leading: Radio<int>(
                      value: index,
                      groupValue: selectedOption,
                      onChanged: (int? value) {
                        setState(() {
                          if (bet.winningoption == -1) {
                            selectedOption = value;
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            // show the following row if the winner is not chosen
            if (bet.winningoption == -1)
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (selectedOption != null) {
                        setState(() {
                          if (!bet.userpicks.containsKey(user.uid)) {
                            FireStoreService().updateUserPoints(
                                user.uid, -1 * bet.entrypoints);
                          }
                          bet.userpicks[user.uid] = selectedOption.toString();
                          FireStoreService().updateBet(bet);
                          // do the following if the user is not already in the bet
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Bet Placed!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select an option!"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Text('Place Bet'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // remove user from bet
                      Bet updatedBet = Bet(
                        betid: bet.betid,
                        betopener: bet.betopener,
                        ends: bet.ends,
                        name: bet.name,
                        description: bet.description,
                        entrypoints: bet.entrypoints,
                        options: bet.options,
                        // update the userpicks, remove the user
                        userpicks: bet.userpicks..remove(user.uid),
                      );
                      await FireStoreService().updateBet(updatedBet);
                      // return points to user
                      await FireStoreService()
                          .updateUserPoints(user.uid, bet.entrypoints);
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
                      trailing: bet.winningoption == -1
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  FireStoreService().removeUserFromBet(
                                      bet.betid,
                                      bet.userpicks.keys.elementAt(index),
                                      bet.entrypoints);
                                  bet.userpicks.remove(
                                      bet.userpicks.keys.elementAt(index));
                                  FireStoreService().updateBet(bet);
                                });
                              },
                              icon: const Icon(Icons.delete),
                            )
                          : null,
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
