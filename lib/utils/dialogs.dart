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
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            actionsPadding: const EdgeInsets.symmetric(horizontal: 24),
          ));
}

void showConfirmationDialog(BuildContext context,
    {String? message, required Function confirmFunction}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Icon(Icons.info_outline, color: Colors.amber),
        ],
      ),
      content: Text(message ?? 'Are you sure?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          child: const Text(
            'NO',
            style: TextStyle(
                // color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: .5),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            confirmFunction();
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context).primaryColor),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          child: const Text(
            'YES',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: .5),
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 14),
    ),
  );
}

void showCustomBottomSheet(BuildContext context, List<Widget> children) {
  showModalBottomSheet(
    backgroundColor: Colors.grey[50],
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    context: context,
    builder: (context) => Padding(
      padding: const EdgeInsets.all(36),
      child: Material(
        textStyle: const TextStyle(color: Colors.blueGrey),
        child: IconTheme(
          data: const IconThemeData(color: Colors.blueGrey),
          child: Column(mainAxisSize: MainAxisSize.min, children: children),
        ),
      ),
    ),
  );
}
