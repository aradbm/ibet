import 'package:flutter/material.dart';

class TextController extends StatelessWidget {
  const TextController({
    super.key,
    required this.betNameController,
    required this.hintText,
    required this.validatorText,
  });

  final TextEditingController betNameController;
  final String hintText;
  final String validatorText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: betNameController,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorText;
        }
        return null;
      },
    );
  }
}
