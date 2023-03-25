import 'package:flutter/material.dart';

import 'input_validation.dart';
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
  final String titleText = 'Delete Account';
  final String dialogText = 'Are you sure you want to delete your account?';
  const DeleteAccountDialog({super.key});

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

class VerifyWithPasswordDialog extends StatefulWidget {
  final String titleText;
  final String dialogText = 'Please verify this action with your password.';
  const VerifyWithPasswordDialog(this.titleText, {super.key});

  @override
  _VerifyWithPasswordScreenState createState() =>
      _VerifyWithPasswordScreenState();
}

class _VerifyWithPasswordScreenState extends State<VerifyWithPasswordDialog> {
  final _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _areDetailsCorrect = true;

  @override
  Widget build(BuildContext context) {
    void callSetStateObscure() {
      setState(() {
        _isObscure = !_isObscure;
      });
    }

    void callSetStateDetailsCorrect(bool areDetailsCorrect) {
      setState(() {
        _areDetailsCorrect = areDetailsCorrect;
      });
    }

    return AlertDialog(
      title: Text(widget.titleText),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.dialogText),
        ],
      ),
      actions: <Widget>[
        TextFormField(
          controller: _passwordController,
          obscureText: _isObscure,
          cursorColor: Colors.deepPurple,
          style: const TextStyle(fontSize: 18),
          decoration: InputDecoration(
              labelText: 'Password',
              labelStyle:
                  const TextStyle(color: Colors.deepPurple, fontSize: 24),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: 'Enter your password',
              hintStyle: const TextStyle(fontSize: 18, color: Colors.grey),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple)),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                color: Colors.deepPurple,
                icon:
                    Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () => callSetStateObscure(),
              )),
          onChanged: (_) => callSetStateDetailsCorrect(true),
        ),
        const SizedBox(height: 5),
        Text(_areDetailsCorrect ? '' : 'Incorrect password',
            style: TextStyle(
                fontSize: 17,
                color: _areDetailsCorrect ? Colors.green : Colors.red)),
        const SizedBox(height: 20),
        ElevatedButton(
            onPressed: () {
              // TODO: verify email and (de)activate
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            child: Text(
              widget.titleText,
              style: const TextStyle(color: Colors.white, fontSize: 17),
            ))
      ],
    );
  }
}

class ChangeEmailDialog extends StatefulWidget {
  final String titleText = 'Change Email Address';
  final String dialogText = 'Please enter a new valid email address.';
  const ChangeEmailDialog({super.key});

  @override
  _ChangeEmailScreenState createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailDialog> {
  final _emailController = TextEditingController();
  bool _isEmailValid = false;

  bool _areDetailsCorrect = true;

  @override
  Widget build(BuildContext context) {
    void callSetStateEmail() {
      setState(() {
        _isEmailValid = isEmailValid(_emailController.text);
      });
    }

    return AlertDialog(
      title: Text(widget.titleText),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.dialogText),
        ],
      ),
      actions: <Widget>[
        TextFormField(
          controller: _emailController,
          cursorColor: Colors.deepPurple,
          style: const TextStyle(fontSize: 18),
          decoration: const InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(color: Colors.deepPurple, fontSize: 24),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: 'Enter your new email',
            hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple)),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => callSetStateEmail(),
        ),
        const SizedBox(height: 5),
        Text(
            (_isEmailValid || _emailController.text.isEmpty)
                ? ''
                : 'Invalid email address',
            style: TextStyle(
                fontSize: 17,
                color: (_isEmailValid || _emailController.text.isEmpty)
                    ? Colors.green
                    : Colors.red)),
        const SizedBox(height: 20),
        ElevatedButton(
            onPressed: () {
              // TODO: verify email and (de)activate
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            child: Text(
              widget.titleText,
              style: const TextStyle(color: Colors.white, fontSize: 17),
            ))
      ],
    );
  }
}
