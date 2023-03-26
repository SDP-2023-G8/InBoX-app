import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inbox_app/constants/constants.dart';

enum Status { notInitialised, initialised, assigned, delivered }

class DeliveryData {
  final String deliveryID;
  final String deliveryName;
  final String userEmail;
  final String hash;
  final String deliveryDate;
  final String imageProof;
  final bool scanned;
  final bool delivered;
  final String unit;
  final String url;

  DeliveryData(
      {required this.deliveryID,
      required this.deliveryName,
      required this.userEmail,
      required this.hash,
      required this.deliveryDate,
      required this.imageProof,
      required this.scanned,
      required this.delivered,
      required this.unit,
      required this.url});

  factory DeliveryData.fromJson(Map<String, dynamic> json) {
    return DeliveryData(
        deliveryID: json["_id"]["\$oid"],
        deliveryName: json["deliveryName"],
        userEmail: json["email"],
        hash: json["hashCode"],
        deliveryDate: json["deliveryDate"],
        imageProof: json["imageProof"],
        scanned: json["scanned"],
        delivered: json["delivered"],
        unit: json["unit"],
        url: json["url"]);
  }
}

class Delivery extends StatefulWidget {
  const Delivery({
    super.key,
    required this.data,
  });

  final DeliveryData data;

  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  String _deliveryId = "";
  String _deliveryName = "";
  String _unitId = "";
  String _unitName = "";
  String _url = "";
  bool _delivered = false;
  String _compartmentId = "";
  String _unit = "";
  DateTime _deliveryDate = DateTime(2023, 3, 22);
  int _status = 0;
  //0 = un-initialised, 1 = initialised, 2 = assigned compartment, 3 = delivered
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    _deliveryId = widget.data.deliveryID.substring(0, 5);
    _deliveryName = widget.data.deliveryName;
    _status = widget.data.delivered ? 3 : 2;
    _url = widget.data.url;
    _delivered = widget.data.delivered;
    _unit = widget.data.unit;
  }

  // Function to get the delivery data from the REST API for a delivery object
  // TODO: This function all also get the date of existing deliveries from the database
  void getDeliveryData() {
    setState(() {
      _deliveryId = "1";
      _deliveryName = "Name";
      _status = 1;
    });
  }

  // Function assigns a compartment to the delivery
  void assignCompartment(String unitId, String compartmentId, String unitName) {
    setState(() {
      _unitId = unitId;
      _unitName = unitName;
      _compartmentId = compartmentId;
      _status = 2;
    });
  }

  // Function marks a delivery as delivered
  void setDelivered() {
    setState(() {
      _status = 3;
    });
  }

  /**
   * Function to toggle if a delivery is expanded.
   * When expanded, the details of the devliery can be viewed
   */
  bool toggleIsExpanded() {
    if (_isExpanded) {
      setState(() {
        _isExpanded = false;
      });
    } else {
      setState(() {
        _isExpanded = true;
      });
    }
    return _isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      color: PRIMARY_GREY,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Stack(children: [
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(_deliveryName.toUpperCase(),
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontWeight: FontWeight.w100,
                          color: Colors.white,
                          fontSize: 30)),
                ),
                const Divider(
                  thickness: 2,
                  color: PRIMARY_BLACK,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(children: [
                    Row(
                      children: [
                        Text('Status: ', style: TextStyle(color: Colors.white)),
                        SizedBox(width: 5.0),
                        Text(_delivered ? 'Delivered' : 'Waiting',
                            style: TextStyle(
                                color:
                                    _delivered ? PRIMARY_GREEN : PRIMARY_YELLOW,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      children: [
                        Text('Unit: ', style: TextStyle(color: Colors.white)),
                        SizedBox(width: 5.0),
                        Text(_unit,
                            style: TextStyle(
                                color:
                                    _delivered ? PRIMARY_GREEN : PRIMARY_YELLOW,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex: 8,
                              child: TextButton.icon(
                                  icon: const Icon(Icons.copy),
                                  label: const Text("URL",
                                      style: TextStyle(color: Colors.white)),
                                  style: TextButton.styleFrom(
                                      backgroundColor: PRIMARY_BLACK,
                                      iconColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.all(Radius.zero))),
                                  onPressed: () {
                                    Clipboard.setData(
                                        ClipboardData(text: _url));
                                    final snackBar = SnackBar(
                                      content:
                                          const Text("Copied to Clipboard!"),
                                      backgroundColor: PRIMARY_GREEN,
                                      behavior: SnackBarBehavior.fixed,
                                      action: SnackBarAction(
                                        label: 'Undo',
                                        textColor: PRIMARY_BLACK,
                                        onPressed: () {},
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  })),
                          const SizedBox(width: 5),
                          Material(
                            child: InkWell(
                              onTap: () {
                                //TODO: Display proof of delivery image
                              },
                              child: Ink(
                                  color: PRIMARY_BLACK,
                                  height: 40.0,
                                  width: 40.0,
                                  child: const Icon(Icons.image,
                                      color: Colors.white)),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Material(
                            child: InkWell(
                              onTap: () {
                                //TODO: Delete delivery
                              },
                              child: Ink(
                                  color: PRIMARY_RED,
                                  height: 40.0,
                                  width: 40.0,
                                  child: const Icon(
                                    Icons.delete_forever_rounded,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ])
                  ]),
                )
              ],
            ),
            Positioned(
                top: 10,
                right: 10,
                child: Container(
                    width: 15.0,
                    height: 15.0,
                    decoration: BoxDecoration(
                      color: _delivered ? PRIMARY_GREEN : PRIMARY_YELLOW,
                      shape: BoxShape.circle,
                    )))
          ])),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   switch (_status) {
  //     case 1:
  //       if (_isExpanded) {
  //         return Padding(
  //           padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
  //           child: Column(
  //             children: [
  //               GestureDetector(
  //                 behavior: HitTestBehavior.opaque,
  //                 onTap: toggleIsExpanded,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       _deliveryName,
  //                       style: const TextStyle(fontSize: 20),
  //                     ),
  //                     IconButton(
  //                       onPressed: toggleIsExpanded,
  //                       icon: const Icon(Icons.expand_less),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
  //                 child: Column(
  //                   children: [
  //                     Row(
  //                       children: [
  //                         const Text('ID: '),
  //                         Text(
  //                           _deliveryId,
  //                           style: const TextStyle(fontWeight: FontWeight.bold),
  //                         ),
  //                       ],
  //                     ),
  //                     Row(
  //                       children: [
  //                         const Text('Delivery Date: '),
  //                         Text(
  //                           '${_deliveryDate.day}-${_deliveryDate.month}-${_deliveryDate.year}',
  //                           style: const TextStyle(fontWeight: FontWeight.bold),
  //                         ),
  //                         const Spacer(),
  //                         PopupMenuButton(
  //                           icon: const Icon(Icons.more_vert),
  //                           onSelected: (item) {
  //                             switch (item) {
  //                               case 'AssignCompartment':
  //                                 assignCompartment('1', '1', 'Original InBoX');
  //                                 //TODO: This should have separate functionality to assign a compartment when implemented with backend
  //                                 break;
  //                               case 'EditOrder':
  //                                 //TODO Implement view/edit order popup
  //                                 break;
  //                               default:
  //                                 throw Exception(
  //                                     'The value passed to Popup Menu item in delivery ${_deliveryId} was invalid');
  //                             }
  //                           },
  //                           itemBuilder: (context) => <PopupMenuEntry>[
  //                             const PopupMenuItem(
  //                               value: 'AssignCompartment',
  //                               child: Text('Assign Compartment'),
  //                             ),
  //                             const PopupMenuItem(
  //                               value: 'EditOrder',
  //                               child: Text('Edit Order Deatils'),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     )
  //                   ],
  //                 ),
  //               ),
  //               const Padding(
  //                 padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
  //                 child: Text(
  //                     'This Delivery has not been assigned a unit or compartment'),
  //               ),
  //               const Divider(
  //                 color: PRIMARY_BLACK,
  //                 thickness: 1,
  //               ),
  //             ],
  //           ),
  //         );
  //       } else {
  //         return Padding(
  //           padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
  //           child: Column(
  //             children: [
  //               GestureDetector(
  //                 behavior: HitTestBehavior.opaque,
  //                 onTap: toggleIsExpanded,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       _deliveryName,
  //                       style: const TextStyle(fontSize: 20),
  //                     ),
  //                     IconButton(
  //                       onPressed: toggleIsExpanded,
  //                       icon: const Icon(Icons.expand_more),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               const Divider(
  //                 thickness: 1,
  //                 color: PRIMARY_BLACK,
  //               ),
  //             ],
  //           ),
  //         );
  //       }
  //     case 2:
  //       if (_isExpanded) {
  //         return Padding(
  //           padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
  //           child: Column(
  //             children: [
  //               GestureDetector(
  //                 behavior: HitTestBehavior.opaque,
  //                 onTap: toggleIsExpanded,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       _deliveryName,
  //                       style: const TextStyle(fontSize: 20),
  //                     ),
  //                     IconButton(
  //                       onPressed: toggleIsExpanded,
  //                       icon: const Icon(Icons.expand_less),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
  //                 child: Column(
  //                   children: [
  //                     Row(
  //                       children: [
  //                         const Text('ID: '),
  //                         Text(
  //                           _deliveryId,
  //                           style: const TextStyle(fontWeight: FontWeight.bold),
  //                         ),
  //                       ],
  //                     ),
  //                     Row(
  //                       children: [
  //                         const Text('Unit: '),
  //                         Text(
  //                           _unitName,
  //                           style: const TextStyle(fontWeight: FontWeight.bold),
  //                         ),
  //                         const Spacer(),
  //                         PopupMenuButton(
  //                           icon: const Icon(Icons.more_vert),
  //                           onSelected: (item) {
  //                             switch (item) {
  //                               case 'AssignCompartment':
  //                                 //TODO Implement Assign Compartment popup
  //                                 break;
  //                               case 'EditOrder':
  //                                 //TODO Implement view/edit order popup
  //                                 break;
  //                               case 'OpenCompartment':
  //                                 setDelivered();
  //                                 break;
  //                               default:
  //                                 throw Exception(
  //                                     'The value passed to Popup Menu item in delivery ${_deliveryId} was invalid');
  //                             }
  //                           },
  //                           itemBuilder: (context) => <PopupMenuEntry>[
  //                             const PopupMenuItem(
  //                               value: 'AssignCompartment',
  //                               child: Text('Re-assign Compartment'),
  //                             ),
  //                             const PopupMenuItem(
  //                               value: 'EditOrder',
  //                               child: Text('Edit Order Deatils'),
  //                             ),
  //                             const PopupMenuItem(
  //                                 value: 'OpenCompartment',
  //                                 child: Text('Collect Delivery')),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                     Row(
  //                       children: [
  //                         const Text('Compartment: '),
  //                         Text(
  //                           _compartmentId,
  //                           style: const TextStyle(fontWeight: FontWeight.bold),
  //                         )
  //                       ],
  //                     ),
  //                     Row(
  //                       children: [
  //                         const Text('Delivery Date: '),
  //                         Text(
  //                           '${_deliveryDate.day}-${_deliveryDate.month}-${_deliveryDate.year}',
  //                           style: const TextStyle(fontWeight: FontWeight.bold),
  //                         ),
  //                       ],
  //                     )
  //                   ],
  //                 ),
  //               ),
  //               const Divider(
  //                 color: PRIMARY_GREEN,
  //                 thickness: 1,
  //               ),
  //             ],
  //           ),
  //         );
  //       } else {
  //         return Padding(
  //           padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
  //           child: Column(
  //             children: [
  //               GestureDetector(
  //                 behavior: HitTestBehavior.opaque,
  //                 onTap: toggleIsExpanded,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       _deliveryName,
  //                       style: const TextStyle(fontSize: 20),
  //                     ),
  //                     IconButton(
  //                       onPressed: toggleIsExpanded,
  //                       icon: const Icon(Icons.expand_more),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               const Divider(
  //                 thickness: 1,
  //                 color: PRIMARY_GREEN,
  //               ),
  //             ],
  //           ),
  //         );
  //       }
  //     case 3:
  //       if (_isExpanded) {
  //         return Padding(
  //           padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
  //           child: Column(
  //             children: [
  //               GestureDetector(
  //                 behavior: HitTestBehavior.opaque,
  //                 onTap: toggleIsExpanded,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       _deliveryName,
  //                       style: const TextStyle(fontSize: 20),
  //                     ),
  //                     IconButton(
  //                       onPressed: toggleIsExpanded,
  //                       icon: const Icon(Icons.expand_less),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
  //                 child: Row(
  //                   children: [
  //                     const Text('ID: '),
  //                     Text(
  //                       _deliveryId,
  //                       style: TextStyle(fontWeight: FontWeight.bold),
  //                     ),
  //                     const Spacer(),
  //                     PopupMenuButton(
  //                       icon: const Icon(Icons.more_vert),
  //                       onSelected: (item) {
  //                         switch (item) {
  //                           case 'editOrder':
  //                             //TODO Implement view/edit order popup
  //                             break;
  //                           default:
  //                             throw Exception(
  //                                 'The value passed to Popup Menu item in delivery ${_deliveryId} was invalid');
  //                         }
  //                       },
  //                       itemBuilder: (context) => <PopupMenuEntry>[
  //                         const PopupMenuItem(
  //                           value: 'editOrder',
  //                           child: Text('Edit Order Deatils'),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               const Text('This Delivery was collected on '),
  //               Text(
  //                 '${_deliveryDate.day}-${_deliveryDate.month}-${_deliveryDate.year}',
  //                 style: const TextStyle(fontWeight: FontWeight.bold),
  //               ),
  //               const Divider(
  //                 color: Colors.deepPurple,
  //                 thickness: 1,
  //               ),
  //             ],
  //           ),
  //         );
  //       } else {
  //         return Padding(
  //           padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
  //           child: Column(
  //             children: [
  //               GestureDetector(
  //                 behavior: HitTestBehavior.opaque,
  //                 onTap: toggleIsExpanded,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       _deliveryName,
  //                       style: const TextStyle(fontSize: 20),
  //                     ),
  //                     IconButton(
  //                       onPressed: toggleIsExpanded,
  //                       icon: const Icon(Icons.expand_more),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               const Divider(
  //                 thickness: 1,
  //                 color: Colors.deepPurple,
  //               ),
  //             ],
  //           ),
  //         );
  //       }
  //     default:
  //       return (GestureDetector(
  //         onTap: () => getDeliveryData(),
  //         child: const Card(
  //             margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
  //             child: Text('This delivery is uninitialised')),
  //       ));
  //   }
  // }
}
