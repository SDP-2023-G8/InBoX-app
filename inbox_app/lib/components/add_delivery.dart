import 'package:flutter/material.dart';

class AddDelivery extends StatefulWidget {
  const AddDelivery({super.key});

  @override
  createState() => _AddDeliveryFromState();
}

class _AddDeliveryFromState extends State<AddDelivery> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    DateTime lastDate =
        DateTime(currentDate.year + 1, currentDate.month, currentDate.day);

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SimpleDialog(
        title: const Text('Add Delivery'),
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: <Widget>[
                  //DeliveryName
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Delivery Name',
                    ),
                    validator: (name) {
                      if (name == null || name.isEmpty) {
                        return 'Delivery name is required';
                      }
                      return null;
                    },
                  ),
                  InputDatePickerFormField(
                    keyboardType: TextInputType.datetime,
                    lastDate: lastDate,
                    firstDate: currentDate,
                    errorInvalidText:
                        'Please select a date within the next year',
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        //TODO: Send request to the database
                        //On request being handled and confirmed, the delivery should be
                        //created in deliveries_screen and getDeliveryData() called in delivery
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
