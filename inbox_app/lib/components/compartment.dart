import 'package:flutter/material.dart';

class Compartment extends StatefulWidget {
  const Compartment({super.key});

  @override
  _CompartmentState createState() => _CompartmentState();
}

class _CompartmentState extends State<Compartment> {
  int _status = 0;

  @override
  void initState() {
    super.initState();
    // TODO: _status = getFromServer;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: _status == 0
              ? Colors.red
              : (_status == 1 ? Colors.yellow : Colors.green),
          border: BorderDirectional()),
      child: Text('data'),
    );
  }
}
