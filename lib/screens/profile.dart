import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ibet/screens/components/info_dialog.dart';
import 'package:ibet/services/auth_service.dart';
import 'package:ibet/services/firestore.dart';

import 'components/gradient_space.dart';

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
            title: const Text(
              'Change Username',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            content: Form(
              key: formKey,
              child: TextFormField(
                maxLength: 15,
                controller: usernameController,
                decoration: const InputDecoration(
                  hintText: 'New Username',
                  hintStyle: TextStyle(fontSize: 15),
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
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // update username in firestore
                    setState(() {
                      FireStoreService().updateUsername(
                        user.uid,
                        usernameController.text,
                      );
                    });
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Change',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        flexibleSpace: const GradientSpace(),
        actions: [
          IconButton(
            onPressed: () {
              final auth = AuthService();
              auth.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.info),
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
        padding: const EdgeInsets.only(top: 30),
        child: Center(
          child: FutureBuilder(
            future: fireuser,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Image.asset(
                      'assets/icon/icon.png',
                      height: 170,
                      // make round corners
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.45),
                      colorBlendMode: BlendMode.color,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Username:',
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${snapshot.data.username}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              changeUsername();
                            },
                            icon: const Icon(Icons.edit,
                                color: Colors.black, size: 22),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Points:',
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: 300,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Text(
                            '${snapshot.data.points}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
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
