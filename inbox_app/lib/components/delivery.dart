import 'package:flutter/material.dart';

class Delivery extends StatefulWidget {
  const Delivery({super.key});

  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  String _deliveryId = "";
  String _deliveryName = "";
  String _userId = "";
  String _unitId = "";
  String _unitName = "";
  String _compartmentId = "";
  DateTime _deliveryDate = DateTime(2023, 3, 22);
  int _status = 0;
  //0 = un-initialised, 1 = initialised, 2 = assigned compartment, 3 = delivered
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  // Function to get the delivery data from the REST API for a delivery object
  // TODO: This function all also get the date of existing deliveries from the database
  void getDeliveryData() {
    setState(() {
      _deliveryId = "1";
      _deliveryName = "Name";
      _userId = "1";
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

  //Function marks a delivery as delivered
  void setDelivered() {
    setState(() {
      _status = 3;
    });
  }

  /// Function to toggle if a delivery is expanded.
  /// When expanded, the details of the devliery can be viewed
  bool toggleIsExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    return _isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case 1:
        if (_isExpanded) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: toggleIsExpanded,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _deliveryName,
                        style: const TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        onPressed: toggleIsExpanded,
                        icon: const Icon(Icons.expand_less),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text('ID: '),
                          Text(
                            _deliveryId,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Delivery Date: '),
                          Text(
                            '${_deliveryDate.day}-${_deliveryDate.month}-${_deliveryDate.year}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          PopupMenuButton(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (item) {
                              switch (item) {
                                case 'AssignCompartment':
                                  assignCompartment('1', '1', 'Original InBoX');
                                  //TODO: This should have separate functionality to assign a compartment when implemented with backend
                                  break;
                                case 'EditOrder':
                                  //TODO Implement view/edit order popup
                                  break;
                                default:
                                  throw Exception(
                                      'The value passed to Popup Menu item in delivery $_deliveryId was invalid');
                              }
                            },
                            itemBuilder: (context) => <PopupMenuEntry>[
                              const PopupMenuItem(
                                value: 'AssignCompartment',
                                child: Text('Assign Compartment'),
                              ),
                              const PopupMenuItem(
                                value: 'EditOrder',
                                child: Text('Edit Order Deatils'),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                      'This Delivery has not been assigned a unit or compartment'),
                ),
                const Divider(
                  color: Colors.deepPurple,
                  thickness: 1,
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: toggleIsExpanded,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _deliveryName,
                        style: const TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        onPressed: toggleIsExpanded,
                        icon: const Icon(Icons.expand_more),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.deepPurple,
                ),
              ],
            ),
          );
        }
      case 2:
        if (_isExpanded) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: toggleIsExpanded,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _deliveryName,
                        style: const TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        onPressed: toggleIsExpanded,
                        icon: const Icon(Icons.expand_less),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text('ID: '),
                          Text(
                            _deliveryId,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Unit: '),
                          Text(
                            _unitName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          PopupMenuButton(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (item) {
                              switch (item) {
                                case 'AssignCompartment':
                                  //TODO Implement Assign Compartment popup
                                  break;
                                case 'EditOrder':
                                  //TODO Implement view/edit order popup
                                  break;
                                case 'OpenCompartment':
                                  setDelivered();
                                  break;
                                default:
                                  throw Exception(
                                      'The value passed to Popup Menu item in delivery $_deliveryId was invalid');
                              }
                            },
                            itemBuilder: (context) => <PopupMenuEntry>[
                              const PopupMenuItem(
                                value: 'AssignCompartment',
                                child: Text('Re-assign Compartment'),
                              ),
                              const PopupMenuItem(
                                value: 'EditOrder',
                                child: Text('Edit Order Deatils'),
                              ),
                              const PopupMenuItem(
                                  value: 'OpenCompartment',
                                  child: Text('Collect Delivery')),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Compartment: '),
                          Text(
                            _compartmentId,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Delivery Date: '),
                          Text(
                            '${_deliveryDate.day}-${_deliveryDate.month}-${_deliveryDate.year}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.deepPurple,
                  thickness: 1,
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: toggleIsExpanded,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _deliveryName,
                        style: const TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        onPressed: toggleIsExpanded,
                        icon: const Icon(Icons.expand_more),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.deepPurple,
                ),
              ],
            ),
          );
        }
      case 3:
        if (_isExpanded) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: toggleIsExpanded,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _deliveryName,
                        style: const TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        onPressed: toggleIsExpanded,
                        icon: const Icon(Icons.expand_less),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Row(
                    children: [
                      const Text('ID: '),
                      Text(
                        _deliveryId,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (item) {
                          switch (item) {
                            case 'editOrder':
                              //TODO Implement view/edit order popup
                              break;
                            default:
                              throw Exception(
                                  'The value passed to Popup Menu item in delivery $_deliveryId was invalid');
                          }
                        },
                        itemBuilder: (context) => <PopupMenuEntry>[
                          const PopupMenuItem(
                            value: 'editOrder',
                            child: Text('Edit Order Deatils'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Text('This Delivery was collected on '),
                Text(
                  '${_deliveryDate.day}-${_deliveryDate.month}-${_deliveryDate.year}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Divider(
                  color: Colors.deepPurple,
                  thickness: 1,
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: toggleIsExpanded,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _deliveryName,
                        style: const TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        onPressed: toggleIsExpanded,
                        icon: const Icon(Icons.expand_more),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.deepPurple,
                ),
              ],
            ),
          );
        }
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
