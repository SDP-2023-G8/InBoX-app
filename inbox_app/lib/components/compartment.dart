import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Compartment extends StatefulWidget {
  final int _id;
  const Compartment(this._id, {super.key});

  @override
  _CompartmentState createState() => _CompartmentState();
}

class _CompartmentState extends State<Compartment> {
  final int _status = 0;
  final DateTime _date = DateTime(2023, 03, 23);

  @override
  void initState() {
    super.initState();
    // TODO: get status and date from server
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: _status == 0
              ? const Color.fromARGB(255, 255, 122, 112)
              : (_status == 1
                  ? const Color.fromARGB(255, 237, 228, 151)
                  : const Color.fromARGB(255, 168, 197, 169)),
          border: const Border(
              top: BorderSide(),
              bottom: BorderSide(),
              left: BorderSide(),
              right: BorderSide()),
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '#${widget._id}',
              style: const TextStyle(fontSize: 40),
            ),
            if (_status == 0)
              Column(children: [
                Text(
                    'Delivery completed on ${DateFormat('yyyy-MM-dd').format(_date)}.'),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(145, 40),
                      backgroundColor: Colors.deepPurple,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
                  onPressed: () {
                    // TODO: open the compartment
                  },
                  child: const Text(
                    'Open',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                )
              ])
            else if (_status == 1)
              Column(children: [
                Text(
                    'Delivery expected on ${DateFormat('yyyy-MM-dd').format(_date)}.'),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(145, 40),
                      backgroundColor: Colors.yellow,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
                  onPressed: () {
                    // TODO: route to Deliveries screen with that delivery expanded
                  },
                  child: const Text(
                    'View Delivery',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                )
              ])
            else
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(145, 40),
                    backgroundColor: Colors.green,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
                onPressed: () {
                  // TODO: route to Add Delivery pop-up
                },
                child: const Text(
                  'Add Delivery',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              )
          ],
        ),
      ),
    );
  }
}
