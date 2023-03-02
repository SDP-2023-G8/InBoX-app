import 'package:flutter/material.dart';
// TODO: view/change delivery pop-up widget

// TODO: help pop-ups with different instructions, such as:
// 1. for registration
// 2. for usage of the unit

class PopupHelpDialog extends StatelessWidget {
  final String titleText;
  final String helpText;
  const PopupHelpDialog(this.titleText, this.helpText, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titleText),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(helpText),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.white),
            )),
      ],
    );
  }
}
