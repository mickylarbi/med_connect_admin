import 'package:flutter/material.dart';

class CustomTextSpan extends StatelessWidget {
  final String firstText;
  final String secondText;
  final void Function()? onPressed;
  const CustomTextSpan(
      {Key? key,
      required this.firstText,
      required this.secondText,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(firstText),
        TextButton(
            onPressed: onPressed,
            child: Text(
              secondText,
              style: const TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ))
      ],
    );
  }
}
