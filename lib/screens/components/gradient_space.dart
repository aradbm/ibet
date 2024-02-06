import 'package:flutter/material.dart';

class GradientSpace extends StatelessWidget {
  const GradientSpace({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            // use ligther primary color
            Theme.of(context).colorScheme.primary,
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
