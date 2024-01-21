import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:ibet/screens/components/text_controller.dart';
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
    final timeController = TextEditingController();
    final betOption1Controller = TextEditingController();
    final betOption2Controller = TextEditingController();
    final betOption3Controller = TextEditingController();
    final betOption4Controller = TextEditingController();
    bool isTimePicked = false;
    // here we create the form for a new bet
    return Scaffold(
      appBar: AppBar(title: const Text('Add Bet')),
      body: SingleChildScrollView(
          child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextController(
                  betNameController: betNameController,
                  hintText: 'Bet Name',
                  validatorText: 'Please enter a bet name'),
              TextController(
                  betNameController: betDescriptionController,
                  hintText: 'Bet Description',
                  validatorText: 'Please enter a bet description'),
              TextFormField(
                controller: betAmountController,
                decoration: const InputDecoration(
                  hintText: 'Bet Amount',
                  icon: Icon(Icons.money),
                ),
                validator: (value) {
                  // here we check if :
                  // 1. the value is not null
                  // 2. the value is not empty
                  // 3. the value is a number
                  // 4. the value is greater than 0
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null ||
                      int.parse(value) <= 0) {
                    return 'Please enter a valid bet amount';
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
              // here we add the time picker
              TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 192, 234, 255),
                  ),
                  onPressed: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime.now().add(const Duration(days: 30)),
                        onChanged: (date) {}, onConfirm: (date) {
                      timeController.text =
                          date.millisecondsSinceEpoch.toString();
                      isTimePicked = true;
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: const Text(
                    'Pick a time 🕒',
                    style: TextStyle(color: Colors.blue),
                  )),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate() && isTimePicked) {
                    await FireStoreService().createBet(
                      {
                        'betopener': user!.uid,
                        'ends': int.parse(timeController.text),
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
                        'winningoption': -1,
                      },
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  } else if (!isTimePicked) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please pick a time'),
                      ),
                    );
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
