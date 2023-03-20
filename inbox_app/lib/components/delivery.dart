import 'package:flutter/material.dart';

class Delivery extends StatefulWidget {
  const Delivery({super.key});

  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  String deliveryId = "";
  String userId = "";
  String unitId = "";
  String compartmentId = "";
  int status = 0;
  //0 = un-initialised, 1 = initialised, 2 = assigned compartment, 3 = delivered

  @override
  void initState() {
    super.initState();
  }

  // Function to get the delivery data from the REST API for a delivery object
  void getDeliveryData() {
    setState(() {
      this.deliveryId = "1";
      this.userId = "1";
      this.status = 1;
    });
  }

  // Function assigns a compartment to the delivery
  void assignCompartment(String unitId, String compartmentId) {
    setState(() {
      this.unitId = unitId;
      this.compartmentId = compartmentId;
      this.status = 2;
    });
  }

  //Function marks a delivery as delivered
  void setDelivered() {
    setState(() {
      this.status = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case 1:
        return (GestureDetector(
          onTap: () => assignCompartment('2', '2'),
          child: Card(
            margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(deliveryId),
                const VerticalDivider(),
                const Text('Unit n/a'),
                const VerticalDivider(),
                const Text('Compartment n/a')
              ],
            ),
          ),
        ));
      case 2:
        return (GestureDetector(
          onTap: () => setDelivered(),
          child: Card(
            margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(deliveryId),
                const VerticalDivider(),
                Text(unitId),
                const VerticalDivider(),
                Text(compartmentId),
                const VerticalDivider(),
                const Text('To be Delivered'),
              ],
            ),
          ),
        ));
      case 3:
        return (GestureDetector(
          onTap: () => null, //TODO Implement route to edit delivery popup
          child: Card(
            margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(deliveryId),
                const VerticalDivider(),
                Text(unitId),
                const VerticalDivider(),
                Text(compartmentId),
                const VerticalDivider(),
                const Text('Delivered'),
              ],
            ),
          ),
        ));
      default:
        return (GestureDetector(
          onTap: () => getDeliveryData(),
          child: const Card(
              margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Text('This delivery is uninitialised')),
        ));
    }
  }
}
