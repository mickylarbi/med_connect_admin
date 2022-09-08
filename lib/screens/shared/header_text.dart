import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final String text;
  final bool isLarge;

  const HeaderText({
    Key? key,
    this.isLarge = false,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: isLarge ? 18 : 16,
        color: Colors.blueGrey,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
