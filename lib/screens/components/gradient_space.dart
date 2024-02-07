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
          // I want the lower part of the gradient to be more visible
          stops: const [0.10, 1],
        ),
        // I want the border to be a little blured on the botton
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            blurRadius: 5,
          ),
        ],
      ),
    );
  }
}
