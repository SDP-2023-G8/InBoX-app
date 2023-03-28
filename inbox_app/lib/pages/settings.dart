import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inbox_app/main.dart';
import 'package:inbox_app/pages/forgot_password.dart';
import 'package:inbox_app/pages/homepage.dart';
import 'package:http/http.dart' as http;
import '../components/bars.dart';
import '../components/pop_ups.dart';
import '../constants/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _emailAddress = "";
  String? _apiKey = "";
  String _unitName = "";
  bool _unitStatus = false;
  List<UnitData> _units = [];

  @override
  void initState() {
    readStorage();
    super.initState();
  }

  Future<void> readStorage() async {
    const storage = FlutterSecureStorage();
    _apiKey = await storage.read(key: "jwt");
    _emailAddress = await storage.read(key: "email");

    var url = Uri.http(REST_ENDPOINT, '/api/v1/units/$_emailAddress');
    var response =
        await http.get(url, headers: {'Authorization': "Bearer: $_apiKey"});
    Iterable l = json.decode(response.body);
    _units = (l as List).map((data) => UnitData.fromJson(data)).toList();
    _unitStatus = _units[0].active;
    _unitName = _units[0].name;
    setState(() {});
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
              backgroundColor: PRIMARY_BLACK,
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
                              padding:
                                  const EdgeInsets.fromLTRB(20, 30, 20, 15),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Email address:',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20)),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            constraints: BoxConstraints.loose(
                                                const Size.fromWidth(200)),
                                            child: Text(
                                              _emailAddress!,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                              textWidthBasis:
                                                  TextWidthBasis.longestLine,
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      const ChangeEmailDialog());
                                            },
                                            child: const Text('Change',
                                                style: TextStyle(fontSize: 17)),
                                          )
                                        ])
                                  ])),
                          const Divider(color: PRIMARY_GREY, thickness: 2),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Password (hidden)',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    )),
                                ElevatedButton(
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
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(color: PRIMARY_GREY, thickness: 2),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Your InBoX "$_unitName"',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    )),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          'Status: ${_unitStatus ? 'active' : 'inactive'}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 17)),
                                      ElevatedButton(
                                        onPressed: () {
                                          bool passwordCorrect = false;
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  VerifyWithPasswordDialog(
                                                      _unitStatus
                                                          ? 'Deactivate'
                                                          : 'Activate'));

                                          passwordCorrect =
                                              true; // TODO: check password and update passwordCorrect
                                          if (passwordCorrect) {
                                            setState(() {
                                              _unitStatus = !_unitStatus;
                                            });
                                          }

                                          var url = Uri.http(REST_ENDPOINT,
                                              "api/v1/units/status/$_unitName");
                                          Map payload = {
                                            "active": !_unitStatus
                                          };
                                          http.post(url, body: payload);
                                          setState(() {
                                            _unitStatus = !_unitStatus;
                                          });
                                        },
                                        child: Text(
                                          _unitStatus
                                              ? 'Deactivate'
                                              : 'Activate',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 17),
                                        ),
                                      ),
                                    ]),
                              ],
                            ),
                          ),
                          const Divider(color: PRIMARY_GREY, thickness: 2),
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: PRIMARY_RED),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        const DeleteAccountDialog());
                              },
                              child: const Text(
                                'Delete Account',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                            ),
                          ),
                          const Divider(color: PRIMARY_GREY, thickness: 2),
                        ],
                      ),
                      Container(
                          padding: const EdgeInsets.only(bottom: 20),
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(120, 40)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const StartScreen()),
                              );
                            },
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 25,
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
