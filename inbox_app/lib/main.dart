import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:inbox_app/notification_service.dart';
import 'package:local_auth/local_auth.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inbox_app/constants/constants.dart';
import 'package:inbox_app/pages/deliveries.dart';
import 'package:inbox_app/pages/login.dart';
import 'package:inbox_app/pages/register.dart';
import 'package:inbox_app/pages/homepage.dart';

void main() async {
  // Set up socket IO client
  IO.Socket socket = IO.io('http://$REST_ENDPOINT', <String, dynamic>{
    'autoConnect': false,
    'transports': ['websocket'],
  });

  socket.connect();
  socket.onConnect((_) {
    socket.emit('connection', "Connected!");
  });

  // Initialize notification service
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initializePlatformNotifications();

  socket.on(
      'delivery_complete',
      (deliveryID) => NotificationService().showLocalNotification(
          id: 0,
          title: "Delivery Complete!",
          body: "Deliver with id $deliveryID has been complete",
          payload: "payload"));

  socket.on(
      'alarm',
      (message) => NotificationService().showLocalNotification(
          id: 1,
          title: "ALARM IS SOUNDING!",
          body: message,
          payload: "payload"));

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const StartScreen(),
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch().copyWith(primary: PRIMARY_GREEN),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: PRIMARY_GREEN,
          )),
    );
  }
}

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> authenticate() async {
    final bool didAuthenticate = await auth.authenticate(
      localizedReason: "Please authenticate to log in",
      options: const AuthenticationOptions(useErrorDialogs: false),
    );

    if (didAuthenticate && context.mounted) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  Future<void> keyValid() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: "jwt");

    try {
      var url = Uri.http(REST_ENDPOINT, "/api/v1/users/login/$token");
      var response = await http.get(url);

      if (response.statusCode == 201 &&
          json.decode(response.body)["result"] &&
          context.mounted) {
        authenticate();
      }
    } on Exception catch (_) {
      // if exception occurs, just continue with regular login
    }
  }

  @override
  void initState() {
    super.initState();
    keyValid(); // Check if a key exists and whether it is valid
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, //Center Column contents vertically,
            crossAxisAlignment: CrossAxisAlignment
                .center, //Center Column contents horizontally,
            children: [
              const Center(
                  child: Image(
                image: AssetImage('assets/img/logo.png'),
                width: 250,
                height: 500,
              )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(140, 50),
                    backgroundColor: Colors.deepPurple,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account yet?',
                    style: TextStyle(fontSize: 17),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 17),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                ],
              ),
            ]));
  }
}
