import 'package:flutter/material.dart';
import 'package:ibet/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              final _auth = AuthService();
              _auth.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Profile', style: TextStyle(fontSize: 30)),
            Spacer(),
            Text('user name'),
            Text('user email'),
            Text('user phone number'),
            Text('number of coins: 213123'),
            Spacer(),
            Text('user bets'),
          ],
        ),
      ),
    );
  }
}
