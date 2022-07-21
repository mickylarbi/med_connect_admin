import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context, {String? message}) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (message != null) Text(message),
                if (message != null) const SizedBox(height: 10),
                const CircularProgressIndicator.adaptive(),
              ],
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ));
}

void showAlertDialog(BuildContext context,
    {String message = 'Something went wrong',
    bool showIcon = true,
    IconData icon = Icons.warning_amber_rounded,
    Color iconColor = Colors.red}) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: showIcon
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(icon, color: iconColor),
                    ],
                  )
                : null,
            content: Text(
              message,
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ));
}
