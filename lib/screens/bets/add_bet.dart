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
  var tempController = TextEditingController();
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
      floatingActionButton: CustomSubmitButton(
        formKey: formKey,
        isTimePicked: isTimePicked,
        betOptions: betOptions,
        user: user,
        timeController: timeController,
        betNameController: betNameController,
        betDescriptionController: betDescriptionController,
        betAmountController: betAmountController,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                validatorText: 'Please enter a bet name',
                prefixIcon: Icon(
                  Icons.title_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 10),
              TextController(
                betNameController: betDescriptionController,
                hintText: 'Bet Description',
                validatorText: 'Please enter a bet description',
                prefixIcon: Icon(
                  Icons.description,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: betAmountController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey[400]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  hintText: 'Bet Amount',
                  prefixIcon: Icon(
                    Icons.attach_money,
                    color: Theme.of(context).colorScheme.primary,
                  ),
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
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                      minTime: DateTime.now(),
                      maxTime: DateTime.now().add(const Duration(days: 30)),
                      onChanged: (date) {},
                      onCancel: () {}, onConfirm: (date) {
                    timeController.text =
                        date.millisecondsSinceEpoch.toString();
                    isTimePicked = true;
                    setState(() {
                      tempController = TextEditingController(
                          text: date.toString().substring(0, 16));
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.grey[400]!,
                      ),
                    ),
                    width: double.infinity,
                    height: 60,
                    child: Row(
                      children: [
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.calendar_today,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          timeController.text.isEmpty
                              ? 'dd-mm-yyyy 00:00'
                              : tempController.text,
                          style: TextStyle(
                            fontSize: timeController.text.isEmpty ? 16 : 15,
                            color: timeController.text.isEmpty
                                ? const Color.fromARGB(255, 80, 79, 79)
                                : Colors.black,
                          ),
                        ),
                        const Spacer(),
                      ],
                    )),
              ),
              // List of bet options
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: optionController,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (value) {
                        if (optionController.text.isNotEmpty) {
                          setState(() {
                            betOptions.add(optionController.text);
                            optionController.clear();
                          });
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Add Bet Option',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[400]!,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
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
              const SizedBox(height: 10),
              for (int i = 0; i < betOptions.length; i++)
                ListTile(
                  title: Text(betOptions[i]),
                  // tileColor: Colors.grey[200],
                  // tile margins 0
                  contentPadding: const EdgeInsets.only(left: 13),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        betOptions.removeAt(i);
                      });
                    },
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      )),
    );
  }
}

class CustomSubmitButton extends StatelessWidget {
  const CustomSubmitButton({
    super.key,
    required this.formKey,
    required this.isTimePicked,
    required this.betOptions,
    required this.user,
    required this.timeController,
    required this.betNameController,
    required this.betDescriptionController,
    required this.betAmountController,
  });

  final GlobalKey<FormState> formKey;
  final bool isTimePicked;
  final List<String> betOptions;
  final User? user;
  final TextEditingController timeController;
  final TextEditingController betNameController;
  final TextEditingController betDescriptionController;
  final TextEditingController betAmountController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(150, 50),
        textStyle: const TextStyle(fontSize: 18),
      ),
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
      child: Text(
        'Submit',
        style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 18,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
