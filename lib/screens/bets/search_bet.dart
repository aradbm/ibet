import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ibet/models/bet.dart';
import 'package:ibet/screens/bets/bet_screen.dart';
import 'package:ibet/services/firestore.dart';
import '../components/gradient_space.dart';
import '../components/my_coin.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final betidController = TextEditingController();
  Bet? bet;
  Widget betWidget = const Text('');
  final now = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    betidController.text = 'Best bet in the world';
  }

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

  void searchBet() async {
    Bet? bet = await FireStoreService().getBetByID(betidController.text);
    bet ??= await FireStoreService().getBetByName(betidController.text);

    setState(() {
      if (bet == null) {
        betWidget = Text(
          'Bet not found',
          style: TextStyle(
            // use matt red
            color: Colors.red[400],
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        );
      } else {
        betWidget = InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BetScreen(bet: bet!)));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
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
                    bet.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bet.description,
                        style: const TextStyle(color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      // show description
                      Text("Entry points: ${bet.entrypoints}  ",
                          style: const TextStyle(color: Colors.black)),
                      // show the creator
                      FutureBuilder(
                        future: FireStoreService().getUserName(bet.betopener),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text('Loading...');
                          }
                          return Text(
                            'Created by: ${snapshot.data}',
                            style: const TextStyle(color: Colors.black),
                          );
                        },
                      ),
                    ],
                  ),
                  trailing: Text(
                    bet.winningoption != -1
                        ? 'Ended'
                        : bet.ends > now
                            ? '${((bet.ends - now) / 86400000).floor()}d ${(((bet.ends - now) % 86400000) / 3600000).floor()}h ${((((bet.ends - now) % 86400000) % 3600000) / 60000).floor()}m'
                            : 'Ended',
                    style: TextStyle(
                        color: bet.ends > now
                            ? Colors.green[800]
                            : Colors.grey[800]),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 10,
                  decoration: BoxDecoration(
                    color: getTileColor(bet.toJson(), bet.betid)[0],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      bottomLeft: Radius.circular(15.0),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const GradientSpace(),
        title: const Text('Search Bet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: betidController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Enter bet id or bet name',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => betidController.clear(),
                ),
              ),
              onSubmitted: (String value) {
                searchBet();
              },
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 20),
            betWidget,
            const Spacer(),
            ElevatedButton.icon(
              onPressed: searchBet,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 13),
              ),
              icon: Icon(Icons.search,
                  size: 25, color: Theme.of(context).colorScheme.primary),
              label: Text(
                'Search',
                style: TextStyle(
                    fontSize: 20, color: Theme.of(context).colorScheme.primary),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
