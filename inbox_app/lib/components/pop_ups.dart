import 'package:flutter/material.dart';
// TODO: view/change delivery pop-up widget

// TODO: help pop-ups with different instructions, such as:
// 1. for registration
// 2. for usage of the unit

class PopupHelpDialog extends StatelessWidget {
  final String titleText;
  final String helpText;
  const PopupHelpDialog(this.titleText, this.helpText, {super.key});

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

class DeleteAccountDialog extends StatelessWidget {
  final String titleText;
  final String dialogText;
  const DeleteAccountDialog(this.titleText, this.dialogText, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titleText),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(dialogText),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () {
              // TODO: delete the account UNLESS there are outstanding deliveries!!!
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Delete Account',
              style: TextStyle(color: Colors.white),
            )),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ))
      ],
    );
  }
}
