import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:ibet/screens/components/text_controller.dart';
import 'package:ibet/services/firestore.dart';

import '../components/gradient_space.dart';

class AddBetScreen extends StatefulWidget {
  const AddBetScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AddBetScreenState();
}

class _AddBetScreenState extends State<AddBetScreen> {
  final betNameController = TextEditingController();
  final betDescriptionController = TextEditingController();
  final betAmountController = TextEditingController();
  final timeController = TextEditingController();
  final optionController = TextEditingController();
  bool isTimePicked = false;
  List<String> betOptions = [];
  @override
  Widget build(BuildContext context) {
    // current user
    final user = FirebaseAuth.instance.currentUser;
    final formKey = GlobalKey<FormState>();
    // here we create the form for a new bet
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bet'),
        flexibleSpace: const GradientSpace(),
      ),
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
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null ||
                      int.parse(value) <= 0) {
                    return 'Please enter a valid bet amount';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: optionController,
                      decoration: const InputDecoration(
                        hintText: 'Add Bet Option',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (optionController.text.isNotEmpty) {
                        setState(() {
                          betOptions.add(optionController.text);
                          optionController.clear();
                        });
                      }
                    },
                  ),
                ],
              ),
              // List of bet options
              for (int i = 0; i < betOptions.length; i++)
                ListTile(
                  title: Text(betOptions[i]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        betOptions.removeAt(i);
                      });
                    },
                  ),
                ),
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
                  if (formKey.currentState!.validate() &&
                      isTimePicked &&
                      betOptions.length > 1) {
                    await FireStoreService().createBet(
                      {
                        'betopener': user!.uid,
                        'ends': int.parse(timeController.text),
                        'name': betNameController.text,
                        'description': betDescriptionController.text,
                        'entrypoints': int.parse(betAmountController.text),
                        'options': betOptions,
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
                  } else if (betOptions.length <= 1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please add at least 2 options'),
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
