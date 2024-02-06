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
      resizeToAvoidBottomInset: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(
            color: isTimeUp
                ? isDone
                    ? Colors.green
                    : Colors.orange
                : isDone
                    ? Colors.green
                    : Colors.grey,
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
      appBar: AppBar(
        title: Text(
          isCreator ? 'Update Bet Screen' : 'Bet Info',
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24.0),
        ),
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
              icon: const Icon(Icons.delete, color: Colors.white),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(18),
          // calculate the height of the screen based on the number of options and userpicks
          height: MediaQuery.of(context).size.height *
              (0.5 + (bet.options.length + bet.userpicks.length) * 0.07),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // if bet is done write in big
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bet.name, style: const TextStyle(fontSize: 30)),
                  Text(bet.description, style: const TextStyle(fontSize: 17)),
                  const SizedBox(height: 20),
                  Text(
                    "Entry points ${bet.entrypoints}",
                    style: const TextStyle(fontSize: 17),
                  ),
                  Text(
                    DateTime.fromMillisecondsSinceEpoch(bet.ends)
                        .toString()
                        .substring(0, 16),
                    style: const TextStyle(fontSize: 17),
                  ),
                  // FutureBuilder(
                  //   future: FireStoreService().getUserName(bet.betopener),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasData) {
                  //       //check if null
                  //       if (snapshot.data == null) {
                  //         return const Text("Loading...");
                  //       }
                  //       return Text(snapshot.data.toString(),
                  //           style: const TextStyle(fontSize: 18));
                  //     }
                  //     return const Text("Loading...");
                  //   },
                  // ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  const Spacer(),
                  if (isCreator && !isDone && !isTimeUp)
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
              ListView.builder(
                itemCount: bet.options.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.lightBlue[100],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            width: bet.userpicks.values
                                    .where((element) =>
                                        int.parse(element) == index)
                                    .isEmpty
                                ? 0
                                : (bet.userpicks.values
                                            .where((element) =>
                                                int.parse(element) == index)
                                            .length /
                                        bet.userpicks.length) *
                                    MediaQuery.of(context).size.width,
                          ),
                          ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
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
                                // we want to show a crown icon if the bet is done and the option is the winning option
                                : isDone
                                    ? (bet.winningoption == index
                                        ? const Icon(
                                            Icons.emoji_events,
                                            color:
                                                Color.fromARGB(255, 0, 114, 27),
                                            size: 30,
                                          )
                                        : null)
                                    : null,
                            leading: !isDone
                                ? Radio<int>(
                                    value: index,
                                    groupValue: selectedOption,
                                    onChanged: (int? value) {
                                      // if the bet is done, don't allow the user to change his pick
                                      if (!isDone && !isTimeUp) {
                                        setState(() => selectedOption = value!);
                                      }
                                    },
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              if (!isDone && !isTimeUp)
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (selectedOption != null) {
                          final appUser = FireStoreService().getUser(user!.uid);
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
              // lets add a divider
              const SizedBox(height: 10),
              const Divider(
                color: Colors.grey,
                thickness: 2,
              ),
              const Text("Current Participants:",
                  style: TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: bet.userpicks.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (isCreator && !isDone) {
                      return ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        // use getTileColor function to return the color of the tile
                        tileColor: Colors.grey[300],
                        title: FutureBuilder(
                          future: FireStoreService()
                              .getUserName(bet.userpicks.keys.elementAt(index)),
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
                        trailing: !isDone && !isTimeUp
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
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          // use getTileColor function to return the color of the tile
                          tileColor: Colors.grey[300],
                          // show the username as title, using firestoreservice to get the username
                          trailing: bet.winningoption == -1
                              ? null
                              : bet.winningoption ==
                                      int.parse(
                                          bet.userpicks.values.elementAt(index))
                                  ? const Icon(
                                      Icons.emoji_events,
                                      color: Color.fromARGB(255, 0, 114, 27),
                                      size: 30,
                                    )
                                  : null,
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder(
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
                              Text(
                                "Chose option: ${int.parse(bet.userpicks.values.elementAt(index)) + 1}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
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
    );
  }
}
