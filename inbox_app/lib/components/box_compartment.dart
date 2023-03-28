import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import '../pages/homepage.dart';
import 'pop_ups.dart';

class BoxCompartment extends StatefulWidget {
  final String unitName;
  final String compartmentName;
  final String deliveryName;
  final bool free;

  const BoxCompartment(
      this.unitName, this.compartmentName, this.deliveryName, this.free,
      {super.key});

  @override
  State<BoxCompartment> createState() => _BoxCompartmentState();
}

class _BoxCompartmentState extends State<BoxCompartment> {
  final _compartmentNameController = TextEditingController(text: "");
  bool _isCompartmentNameEnabled = false;

  @override
  Widget build(BuildContext context) {
    _compartmentNameController.text = widget.compartmentName;

    return Stack(children: [
      const Card(elevation: 3, color: PRIMARY_BLACK, child: Center()),
      Positioned(
          bottom: 25,
          left: 25,
          width: 250,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      SizedBox(
                          width: 120,
                          child: TextField(
                              controller: _compartmentNameController,
                              decoration: const InputDecoration(
                                  disabledBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _isCompartmentNameEnabled
                                      ? PRIMARY_GREEN
                                      : Colors.white,
                                  fontSize: 18),
                              enabled: _isCompartmentNameEnabled)),
                      Material(
                        type: MaterialType.transparency,
                        child: IconButton(
                          icon: _isCompartmentNameEnabled
                              ? const Icon(Icons.check)
                              : const Icon(Icons.edit),
                          iconSize: 15,
                          color: Colors.white,
                          onPressed: () async {
                            if (_isCompartmentNameEnabled) {
                              var url = Uri.http(REST_ENDPOINT,
                                  "/api/v1/units/compartment/update");
                              Map payload = {
                                "unit": widget.unitName,
                                "oldCompartmentName": widget.compartmentName,
                                "newCompartmentName":
                                    _compartmentNameController.text
                              };
                              await http.post(url, body: payload);

                              setState(() {
                                _isCompartmentNameEnabled = false;
                              });
                            } else {
                              setState(() {
                                _isCompartmentNameEnabled = true;
                              });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  Text(
                      widget.free
                          ? "Compartment is Available!"
                          : "Delivery '${widget.deliveryName}' Assigned",
                      style: TextStyle(
                          fontWeight: FontWeight.w100,
                          color: widget.free ? PRIMARY_GREEN : PRIMARY_RED,
                          fontSize: 13))
                ],
              ),
              Material(
                type: MaterialType.transparency,
                child: IconButton(
                  icon: const Icon(Icons.lock_open),
                  iconSize: 22,
                  splashColor: PRIMARY_GREEN,
                  color: Colors.white,
                  onPressed: () {
                    var snackBar = SnackBar(
                      content: Text("Unlocked '${widget.compartmentName}'!"),
                      backgroundColor: PRIMARY_GREEN,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                ),
              )
            ],
          )),
      if (widget.free)
        Positioned(
          top: 20,
          left: 20,
          child: Material(
            type: MaterialType.transparency,
            child: IconButton(
              icon: const Icon(Icons.delete),
              iconSize: 25,
              color: Colors.white38,
              splashColor: PRIMARY_RED,
              onPressed: () {
                var url = Uri.http(REST_ENDPOINT,
                    'api/v1/units/compartment/${widget.unitName}/${widget.compartmentName}');
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        ConfirmCompartmentDeletionPopup(
                            widget.compartmentName, url)).then((value) {
                  Navigator.of(context).pop();
                  Future.delayed(const Duration(seconds: 1));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                });
              },
            ),
          ),
        ),
      Positioned(
          top: 25,
          right: 25,
          child: Container(
            height: 25.0,
            width: 25.0,
            decoration: BoxDecoration(
              color: widget.free ? PRIMARY_GREEN : PRIMARY_RED,
              shape: BoxShape.circle,
            ),
          ))
    ]);
  }
}
