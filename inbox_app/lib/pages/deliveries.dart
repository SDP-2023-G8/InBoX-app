import 'package:flutter/material.dart';
import 'package:inbox_app/components/add_delivery.dart';
import '../components/bars.dart';
import '../components/delivery.dart';
import 'homepage.dart';

class DeliveriesScreen extends StatefulWidget {
  const DeliveriesScreen({Key? key}) : super(key: key);

  @override
  _DeliveriesScreenState createState() => _DeliveriesScreenState();
}

class _DeliveriesScreenState extends State<DeliveriesScreen> {
  var _deliveries = <Delivery>[];

  @override
  void initState() {
    super.initState();
  }

  void addDelivery(Delivery delivery) {
    setState(() {
      _deliveries.add(delivery);
    });
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
          appBar: const SimpleBar('Deliveries'),
          bottomNavigationBar: const BottomBar(0),
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _deliveries),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AddDelivery());
            },
            backgroundColor: const Color.fromARGB(255, 170, 120, 255),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
