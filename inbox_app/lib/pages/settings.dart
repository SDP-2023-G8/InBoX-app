import 'package:flutter/material.dart';
import 'package:inbox_app/main.dart';
import 'package:inbox_app/pages/forgot_password.dart';
import 'package:inbox_app/pages/homepage.dart';
import '../components/bars.dart';
import '../components/pop_ups.dart';
import 'register.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _emailAdress = 'ddd@gmail.com'; // TODO: get from server
  bool _unitStatus = true;
  bool _mainDoorLocked = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
        return true;
      },
      child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              appBar: const SimpleBar('Settings'),
              bottomNavigationBar: const BottomBar(2),
              body: CustomScrollView(slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Email address:',
                                        style: TextStyle(fontSize: 20)),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _emailAdress,
                                            style:
                                                const TextStyle(fontSize: 17),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              textStyle:
                                                  const TextStyle(fontSize: 17),
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      const ChangeEmailDialog());
                                            },
                                            child: const Text(
                                              'Change',
                                              style: TextStyle(
                                                  color: Colors.deepPurple),
                                            ),
                                          )
                                        ])
                                  ])),
                          const Divider(color: Colors.deepPurple, thickness: 1),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Password (hidden)',
                                    style: TextStyle(fontSize: 20)),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: const TextStyle(fontSize: 17),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPasswordScreen()),
                                    );
                                  },
                                  child: const Text(
                                    'Change',
                                    style: TextStyle(color: Colors.deepPurple),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(color: Colors.deepPurple, thickness: 1),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Your InBoX "Name here"',
                                    style: TextStyle(fontSize: 20)),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          'Status: ${_unitStatus ? 'active' : 'inactive'}',
                                          style: const TextStyle(fontSize: 17)),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle:
                                              const TextStyle(fontSize: 17),
                                        ),
                                        onPressed: () {
                                          bool passwordCorrect = false;
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  VerifyWithPasswordDialog(
                                                      _unitStatus
                                                          ? 'Deactivate'
                                                          : 'Activate'));
                                          if (false)
                                            passwordCorrect =
                                                true; // TODO: check password and update passwordCorrect
                                          if (passwordCorrect)
                                            setState(() {
                                              _unitStatus = !_unitStatus;
                                            });
                                          // TODO: (de)activate the unit
                                        },
                                        child: Text(
                                          _unitStatus
                                              ? 'Deactivate'
                                              : 'Activate',
                                          style: const TextStyle(
                                              color: Colors.deepPurple),
                                        ),
                                      ),
                                    ]),
                                if (_unitStatus)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          'Main door ${_mainDoorLocked ? 'locked' : 'unlocked'}',
                                          style: const TextStyle(fontSize: 17)),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle:
                                              const TextStyle(fontSize: 17),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _mainDoorLocked = false;
                                          });
                                          // TODO: open front door
                                        },
                                        child: const Text(
                                          'Open main door',
                                          style: TextStyle(
                                              color: Colors.deepPurple),
                                        ),
                                      ),
                                    ],
                                  )
                              ],
                            ),
                          ),
                          const Divider(color: Colors.deepPurple, thickness: 1),
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 20),
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        const DeleteAccountDialog());
                              },
                              child: const Text(
                                'Delete Account',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                          const Divider(color: Colors.deepPurple, thickness: 1),
                        ],
                      ),
                      Container(
                          padding: const EdgeInsets.only(bottom: 20),
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(140, 50),
                                backgroundColor: Colors.deepPurple,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)))),
                            onPressed: () {
                              // TODO: log the user out
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const StartScreen()),
                              );
                            },
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ]))),
    );
  }
}
