import 'package:flutter/material.dart';

class MyCoin extends StatelessWidget {
  const MyCoin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.white,
      ),
      clipBehavior: Clip.hardEdge,
      child: Image.asset(
        'assets/icon/icon.png',
        height: 30,
        // make round corners
        color: Colors.red,
        colorBlendMode: BlendMode.color,
      ),
    );
  }
}
