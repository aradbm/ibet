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
        height: 25,
        // make round corners
        color: Color.fromARGB(255, 53, 94, 34),
        colorBlendMode: BlendMode.color,
      ),
    );
  }
}
