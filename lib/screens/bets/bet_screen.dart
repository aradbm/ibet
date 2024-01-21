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
  final user = FirebaseAuth.instance.currentUser;
  int winningoption = -1;
  int? selectedOption;
  final addOptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // checks selected option using userpicks
    if (widget.bet.userpicks.containsKey(user!.uid)) {
      selectedOption = int.parse(widget.bet.userpicks[user!.uid]);
    }
  }

  @override
  Widget build(BuildContext context) {
    Bet bet = widget.bet;
    bool isCreator = bet.betopener == user!.uid;
    bool isDone = bet.winningoption != -1;
    bool isParticipant = bet.userpicks.containsKey(user!.uid);
    bool isTimeUp = bet.ends < DateTime.now().millisecondsSinceEpoch;

    // return tile color function, if the bet is done, show the winning option in green
    Color returnTileColor(int index) {
      // if wiining option is -1
      if (bet.winningoption == -1) {
        return Colors.white;
      }
      if (isDone) {
        if (bet.winningoption == index) {
          return Colors.green[100]!;
        } else {
          return Colors.white;
        }
      } else {
        if (selectedOption == index) {
          return Colors.green[100]!;
        } else {
          return Colors.white;
        }
      }
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  // here we show the bet status
                  // if the time is up but the winner is not chosen yet, show the following
                  // bet time is done, but winner is not chosen yet
                  // if the time is up and the winner is chosen, show the following
                  // bet time is done and winner is chosen
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border.all(
                        color: isTimeUp
                            ? isDone
                                ? Colors.green
                                : Colors.red
                            : isDone
                                ? Colors.green
                                : Colors.orangeAccent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      isTimeUp
                          ? isDone
                              ? "Status: Bet is done, winning option is ${bet.winningoption + 1}"
                              : "Status: Bet time is done, winner not chosen yet!"
                          : isDone
                              ? "Status: Bet is done, winning option is ${bet.winningoption + 1}"
                              : "Status: Bet is open, time is not up yet!",
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                // if bet is done write in big
                Row(
                  children: [
                    const Text("Bet Creator: ", style: TextStyle(fontSize: 20)),
                    FutureBuilder(
                      future: FireStoreService().getUserName(bet.betopener),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          //check if null
                          if (snapshot.data == null) {
                            return const Text("Loading...");
                          }
                          return Text(snapshot.data.toString());
                        }
                        return const Text("Loading...");
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text("Bet Name: ${bet.name}",
                    style: const TextStyle(fontSize: 20)),
                Text("Bet Description: ${bet.description}"),
                Text("Bet entry point: ${bet.entrypoints}"),
                Text(
                    "Total Points in Bet: ${bet.entrypoints * bet.userpicks.length}"),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text("Bet Options:", style: TextStyle(fontSize: 20)),
                    const Spacer(),
                    if (isCreator && !isDone)
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
                                        bet.options
                                            .add(addOptionController.text);
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
                    if (isCreator && !isDone)
                      ElevatedButton(
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
                        child: const Text('Pick Winner'),
                      ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                  ],
                ),
                // show here all the options
                Container(
                  color: Theme.of(context).dialogBackgroundColor,
                  child: ListView.builder(
                    itemCount: bet.options.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        tileColor: bet.winningoption == index
                            ? Colors.green[100]
                            : Colors.white,
                        title: Text(bet.options[index]),
                        // only for creator, show the radio button to choose the winner
                        trailing: isCreator && !isDone
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
                            // if the bet is done, don't allow the user to change his pick
                            if (!isDone && !isTimeUp) {
                              setState(() => selectedOption = value!);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                // show the following row if the winner is not chosen , and the time is not up
                if (!isDone && !isTimeUp)
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (selectedOption != null) {
                            final appUser =
                                FireStoreService().getUser(user!.uid);
                            // First we check if the user is already in the bet.
                            // Than we check if he has enough points, if he is not in the bet, we add him
                            // and remove the points, if he is in the bet, we show a snackbar
                            if (isParticipant) {
                              // change the user pick, dont change his points
                              setState(() {
                                bet.userpicks[user!.uid] =
                                    selectedOption.toString();
                                FireStoreService().updateBet(bet);
                                // do the following if the user is not already in the bet
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Bet Updated!"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                // get back
                                Navigator.pop(context);
                              });
                            }
                            // else, if the user is not in the bet, we add him and remove the points
                            // if he is in the bet, we show a snackbar
                            else {
                              int points =
                                  await appUser.then((value) => value!.points);
                              if (points <= bet.entrypoints) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Not enough points!"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                setState(() {
                                  if (!isParticipant) {
                                    FireStoreService().updateUserPoints(
                                        user!.uid, -1 * bet.entrypoints);
                                    bet.userpicks[user!.uid] =
                                        selectedOption.toString();
                                    FireStoreService().updateBet(bet);
                                    // do the following if the user is not already in the bet
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Bet Placed!"),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    // get back
                                    Navigator.pop(context);
                                  }
                                });
                              }
                            }
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
                              userpicks: bet.userpicks..remove(user!.uid),
                            );
                            await FireStoreService().updateBet(updatedBet);
                            // return points to user
                            await FireStoreService()
                                .updateUserPoints(user!.uid, bet.entrypoints);
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
                const Text("Current Participants:",
                    style: TextStyle(fontSize: 20)),
                Expanded(
                  child: ListView.builder(
                    itemCount: bet.userpicks.length,
                    itemBuilder: (context, index) {
                      if (isCreator) {
                        return ListTile(
                          title: FutureBuilder(
                            future: FireStoreService().getUserName(
                                bet.userpicks.keys.elementAt(index)),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                //check if null
                                if (snapshot.data == null) {
                                  return const Text("Loading...");
                                }
                                return Text(snapshot.data.toString());
                              }
                              return const Text("Loading...");
                            },
                          ),
                          trailing: !isDone
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
                          // use getTileColor function to return the color of the tile
                          tileColor: returnTileColor(
                              int.parse(bet.userpicks.values.elementAt(index))),
                          // show the username as title, using firestoreservice to get the username
                          // funcition looks like:   Future<String?> getUserName(String uid) async {
                          title: FutureBuilder(
                            future: FireStoreService().getUserName(
                                bet.userpicks.keys.elementAt(index)),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                //check if null
                                if (snapshot.data == null) {
                                  return const Text("Loading...");
                                }
                                return Text(snapshot.data.toString());
                              }
                              return const Text("Loading...");
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
