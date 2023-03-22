import 'package:flutter/material.dart';

class Compartment extends StatefulWidget {
  final int _id;
  const Compartment(this._id, {super.key});

  @override
  _CompartmentState createState() => _CompartmentState();
}

class _CompartmentState extends State<Compartment> {
  int _status = 2;

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
          border: const Border(
              top: BorderSide(),
              bottom: BorderSide(),
              left: BorderSide(),
              right: BorderSide()),
          borderRadius: BorderRadius.circular(20)),
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              '#${widget._id}',
              style: const TextStyle(fontSize: 40),
            )
          ],
        ),
      ),
    );
  }
}
