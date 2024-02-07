import 'package:flutter/material.dart';

class TextController extends StatelessWidget {
  const TextController({
    super.key,
    required this.betNameController,
    required this.hintText,
    required this.validatorText,
    required this.prefixIcon,
  });

  final TextEditingController betNameController;
  final String hintText;
  final String validatorText;
  final Widget prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: betNameController,
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
        hintText: hintText,
        prefixIcon: prefixIcon,
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
