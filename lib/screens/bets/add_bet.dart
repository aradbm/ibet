import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:ibet/models/bet.dart';
import 'package:ibet/services/firestore.dart';

class AddBetScreen extends StatefulWidget {
  const AddBetScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AddBetScreenState();
}

class _AddBetScreenState extends State<AddBetScreen> {
  @override
  Widget build(BuildContext context) {
    // current user
    final user = FirebaseAuth.instance.currentUser;

    final formKey = GlobalKey<FormState>();
    final betNameController = TextEditingController();
    final betDescriptionController = TextEditingController();
    final betAmountController = TextEditingController();

    // time picker
    //  controller for time picker
    final timeController = TextEditingController();
    //  time picker

    //  controller for 4 options

    final betOption1Controller = TextEditingController();
    final betOption2Controller = TextEditingController();
    final betOption3Controller = TextEditingController();
    final betOption4Controller = TextEditingController();

    // here we create the form for a new bet
    return Scaffold(
      appBar: AppBar(title: const Text('Add Bet')),
      body: SingleChildScrollView(
          child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: betNameController,
                decoration: const InputDecoration(
                  hintText: 'Bet Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a bet name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: betDescriptionController,
                decoration: const InputDecoration(
                  hintText: 'Bet Description',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a bet description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: betAmountController,
                decoration: const InputDecoration(
                  hintText: 'Bet Amount',
                  icon: Icon(Icons.money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a bet amount';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: betOption1Controller,
                decoration: const InputDecoration(
                  hintText: 'Bet Option 1',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a bet option';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: betOption2Controller,
                decoration: const InputDecoration(
                  hintText: 'Bet Option 2',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a bet option';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: betOption3Controller,
                decoration: const InputDecoration(
                  hintText: 'Bet Option 3',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a bet option';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: betOption4Controller,
                decoration: const InputDecoration(
                  hintText: 'Bet Option 4',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a bet option';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: timeController,
                decoration: const InputDecoration(
                  hintText: 'Bet End Time',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a bet end time';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    // here we need to add the bet to the database
                    // use the firestore service to add the bet

                    Future docID = await FireStoreService().createBet(
                      {
                        'betopener': user!.uid,
                        'ends': DateTime.now()
                            .add(const Duration(days: 1))
                            .millisecondsSinceEpoch,
                        'name': betNameController.text,
                        'description': betDescriptionController.text,
                        'entrypoints': int.parse(betAmountController.text),
                        'options': [
                          betOption1Controller.text,
                          betOption2Controller.text,
                          betOption3Controller.text,
                          betOption4Controller.text,
                        ],
                        'userpicks': {},
                      },
                    );
                    // turn future into string
                    print("the doc id is : $docID");
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
