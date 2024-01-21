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
    final user = FirebaseAuth.instance.currentUser;
    Bet bet = widget.bet;
    bool isCreator = bet.betopener == user!.uid;
    bool isDone = bet.winningoption != -1;
    bool isParticipant = bet.userpicks.containsKey(user.uid);
    bool isTimeUp = bet.ends < DateTime.now().millisecondsSinceEpoch;
    if (bet.userpicks.containsKey(user.uid) && b1) {
      selectedOption = int.parse(bet.userpicks[user.uid]);
      b1 = false;
    }
    
    return Scaffold(
      appBar: AppBar(
        title: isCreator
            ? const Text('Update Bet Screen')
            : const Text('Bet Info'),
        backgroundColor: Colors.blue,
        actions: [
          if (isCreator && !isDone)
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
            // if bet is done write in big
            Center(
              // if the time is up but the winner is not chosen yet, show the following
              // bet time is done, but winner is not chosen yet
              // if the time is up and the winner is chosen, show the following
              // bet time is done and winner is chosen
              child: Text(
                isTimeUp
                    ? isDone
                        ? "Bet is done!"
                        : "Time is up!"
                    : "Time left: ${((bet.ends - DateTime.now().millisecondsSinceEpoch) / 1000 / 60).toStringAsFixed(2)} minutes",
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Text("Bet Name: ${bet.name}", style: const TextStyle(fontSize: 20)),
            Text("Bet Description: ${bet.description}"),
            Text("Bet entry point: ${bet.entrypoints}"),
            Text(
                "Total Points in Bet: ${bet.entrypoints * bet.userpicks.length}"),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text("Bet Options:", style: TextStyle(fontSize: 20)),
                const SizedBox(width: 20),
                if (isCreator && isDone)
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
                if (isCreator && isDone)
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
                    trailing: isCreator && isDone
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
                          // if the bet is done, don't allow the user to change his pick
                          if (!isDone && !isTimeUp) {
                            selectedOption = value!;
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            // show the following row if the winner is not chosen
            if (isDone)
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (selectedOption != null) {
                        setState(() {
                          if (!isParticipant) {
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
                  if (isParticipant)
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
                    // show only the username of the participant in each tile
                    // for each tile, if it's the creator show in orange, if won show in green
                    return ListTile(
                      tileColor: isDone
                          ? bet.userpicks.keys.elementAt(index) == bet.betopener
                              ? Colors.orange[100]
                              : Colors.white
                          : bet.winningoption ==
                                  int.parse(
                                      bet.userpicks.values.elementAt(index))
                              ? Colors.green[100]
                              : Colors.white,
                      title: Text(bet.userpicks.keys.elementAt(index)),
                      subtitle: Text(
                          // show the index + 1
                          "Chose option: ${int.parse(bet.userpicks.values.elementAt(index)) + 1}"),
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
