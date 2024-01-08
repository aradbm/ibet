import 'package:flutter/material.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Info'),
      content: const Column(
        children: [
          Text(
            'Here you can see all the bets you created and joined. You can also create new bets here.\n',
          ),
          Text(
            'To create a new bet, click the + button in the bottom right corner.\n',
          ),
          Text(
            'To join a bet, click on the bet you want to join and click the Join button.\n',
          ),
          Text(
            'To see the details of a bet, click on the bet you want to see.\n',
          ),
          // here show each color and what it means
          SizedBox(height: 10),
          Text('Colors:'),
          Text('Yellow: Bet is still open and you created.'),
          Text('Grey: Bet is still open and you joined.'),
          Text('Green: Bet is over and you won.'),
          Text('Red: Bet is over and you lost.'),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
