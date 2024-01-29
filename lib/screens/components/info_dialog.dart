import 'package:flutter/material.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      title: const Text('Info'),
      content: Column(
        children: [
          const Text(
            'To create a new bet, click the + button in the bottom right corner.\n',
          ),
          const Text(
            'To join a bet, search by bet ID, click on the bet, and join with your points.\n',
          ),
          const Text('When bet is finished:\n'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.green[400],
                  shape: BoxShape.circle,
                ),
              ),
              const Text('You won'),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.red[400],
                  shape: BoxShape.circle,
                ),
              ),
              const Text('You lost'),
            ],
          ),
          const SizedBox(height: 30),
          const Text('When bet is not finished:\n'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.orange[400],
                  shape: BoxShape.circle,
                ),
              ),
              const Text('Winner not picked'),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.yellow[400],
                  shape: BoxShape.circle,
                ),
              ),
              const Text('Bet open'),
            ],
          ),
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
