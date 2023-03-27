import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../pages/verify_code.dart';
import 'input_validation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inbox_app/components/delivery.dart';
import 'package:inbox_app/constants/constants.dart';
import 'package:http/http.dart' as http;

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
            style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_GREEN),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.white),
            )),
      ],
    );
  }
}

class AddCompartmentPopup extends StatefulWidget {
  final String unitName;
  const AddCompartmentPopup(this.unitName, {super.key});

  @override
  State<AddCompartmentPopup> createState() => _AddCompartmentPopupState();
}

class _AddCompartmentPopupState extends State<AddCompartmentPopup> {
  String? apiKey = "";
  String compartmentName = "";
  final _formKey = GlobalKey<FormState>();

  Future<void> loadApiKey() async {
    const storage = FlutterSecureStorage();
    apiKey = await storage.read(key: "jwt");
  }

  @override
  void initState() {
    super.initState();
    loadApiKey();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title:
          const Text("Add Compartment", style: TextStyle(color: Colors.white)),
      backgroundColor: PRIMARY_BLACK,
      children: [
        Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (String? value) {
                      compartmentName = value!;
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        labelText: "Compartment Name",
                        labelStyle: TextStyle(color: Colors.white38)),
                    validator: (compartment) {
                      if (compartment == null || compartment.isEmpty) {
                        return "Compartment name is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                      child: const Text("Submit"),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState?.save();
                          var url = Uri.http(REST_ENDPOINT,
                              '/api/v1/units/compartment/${widget.unitName}/$compartmentName');
                          http.get(url,
                              headers: {'Authorization': "Bearer: $apiKey"});

                          Navigator.of(context).pop();
                        }
                      })
                ],
              ),
            ))
      ],
    );
  }
}

class ConfirmCompartmentDeletionPopup extends StatefulWidget {
  final String compartmentName;
  final Uri url;
  const ConfirmCompartmentDeletionPopup(this.compartmentName, this.url,
      {super.key});

  @override
  State<ConfirmCompartmentDeletionPopup> createState() =>
      _ConfirmCompartmentDeletionPopupState();
}

class _ConfirmCompartmentDeletionPopupState
    extends State<ConfirmCompartmentDeletionPopup> {
  String? apiKey = "";

  @override
  void initState() {
    super.initState();
    loadApiKey();
  }

  Future<void> loadApiKey() async {
    const storage = FlutterSecureStorage();
    apiKey = await storage.read(key: "jwt");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirm Compartment Delete",
          style: TextStyle(color: Colors.white)),
      backgroundColor: PRIMARY_BLACK,
      contentPadding: const EdgeInsets.all(20.0),
      content: Text(
          "Are you sure you want to delete the '${widget.compartmentName}' compartment?",
          style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w100,
              color: Colors.white38)),
      actions: [
        TextButton.icon(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_GREEN),
            label: const Text('No', style: TextStyle(color: Colors.white))),
        TextButton.icon(
          icon: const Icon(Icons.check),
          onPressed: () {
            http.delete(widget.url,
                headers: {"Authorization": "Bearer: $apiKey"});
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_BLACK),
          label: const Text('Yes', style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }
}

class DeliveryProofPopup extends StatelessWidget {
  final String imageData;

  const DeliveryProofPopup(this.imageData, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          const Text("Delivery Proof", style: TextStyle(color: Colors.white)),
      backgroundColor: PRIMARY_BLACK,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Image.memory(Uint8List.fromList(base64.decode(imageData))),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_RED),
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
      backgroundColor: PRIMARY_BLACK,
      title: Text(titleText, style: const TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(dialogText, style: const TextStyle(color: Colors.white)),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () {
              // TODO: delete the account UNLESS there are outstanding deliveries!!!
            },
            style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_RED),
            child: const Text(
              'Delete Account',
              style: TextStyle(color: Colors.white, fontSize: 17),
            )),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white, fontSize: 17),
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
      backgroundColor: PRIMARY_BLACK,
      title: Text('${widget.titleText} InBoX',
          style: const TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.dialogText, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            obscureText: _isObscure,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            autofocus: true,
            decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(color: PRIMARY_GREEN, fontSize: 24),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: 'Enter your password',
                hintStyle: const TextStyle(fontSize: 18, color: Colors.grey),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: PRIMARY_GREEN)),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: PRIMARY_GREY)),
                suffixIcon: IconButton(
                  color: PRIMARY_GREEN,
                  icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => callSetStateObscure(),
                )),
            onChanged: (_) => callSetStateDetailsCorrect(true),
          ),
          const SizedBox(height: 5),
          if (!_areDetailsCorrect)
            const Text('Incorrect password',
                style: TextStyle(fontSize: 17, color: PRIMARY_RED))
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () {
              if (_passwordController.text.isNotEmpty &&
                  _passwordController.text.length >= 8) {
                // TODO: verify email and (de)activate
              } else {
                callSetStateDetailsCorrect(false);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_GREEN),
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

  @override
  Widget build(BuildContext context) {
    void callSetStateEmail() {
      setState(() {
        _isEmailValid = isEmailValid(_emailController.text);
      });
    }

    return AlertDialog(
      backgroundColor: PRIMARY_BLACK,
      title:
          Text(widget.titleText, style: const TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.dialogText, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: PRIMARY_GREEN, fontSize: 24),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: 'Enter your new email',
              hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: PRIMARY_GREEN)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: PRIMARY_GREY)),
            ),
            onChanged: (value) => callSetStateEmail(),
          ),
          const SizedBox(height: 5),
          if (!_isEmailValid && _emailController.text.isNotEmpty)
            const Text('Invalid email address',
                style: TextStyle(fontSize: 17, color: PRIMARY_RED))
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () {
              if (_isEmailValid && _emailController.text.isNotEmpty) {
                // TODO: verify email and change it in the database
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VerificationScreen(
                          'Change Email Address', _emailController.text)),
                );
              }
            },
            child: Text(
              widget.titleText,
              style: const TextStyle(color: Colors.white, fontSize: 17),
            ))
      ],
    );
  }
}
