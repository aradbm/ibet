import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ibet/screens/components/info_dialog.dart';
import 'package:ibet/services/auth_service.dart';
import 'package:ibet/services/firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    // get current user instance from firebase
    // get user data from firestore
    var fireuser = FireStoreService().getUser(user!.uid);

    // function to change username when button is pressed
    void changeUsername() {
      // create a text controller for the text field
      final usernameController = TextEditingController();
      // create a form key
      final formKey = GlobalKey<FormState>();
      // create a dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Change Username'),
            content: Form(
              key: formKey,
              child: TextFormField(
                maxLength: 15,
                controller: usernameController,
                decoration: const InputDecoration(
                  hintText: 'New Username',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // update username in firestore
                    FireStoreService().updateUsername(
                      user.uid,
                      usernameController.text,
                    );
                    setState(() {});

                    Navigator.pop(context);
                  }
                },
                child: const Text('Change'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () {
              final auth = AuthService();
              auth.signOut();
            },
            icon: Icon(Icons.logout,
                color: Theme.of(context).colorScheme.onPrimary),
          ),
        ],
        leading: IconButton(
          icon:
              Icon(Icons.info, color: Theme.of(context).colorScheme.onPrimary),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const InfoWidget();
              },
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Center(
          child: FutureBuilder(
            future: fireuser,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        'https://picsum.photos/200',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'Username: ${snapshot.data.username}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          onPressed: changeUsername,
                          icon: const Icon(Icons.edit),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Points: ${snapshot.data.points}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
