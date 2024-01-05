import 'package:flutter/material.dart';

class AddBetScreen extends StatefulWidget {
  const AddBetScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AddBetScreenState();
}

class _AddBetScreenState extends State<AddBetScreen> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final betNameController = TextEditingController();
    final betDescriptionController = TextEditingController();
    final betAmountController = TextEditingController();

    // also need to have controller for 4 options

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
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // here we need to add the bet to the database

                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')));
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
