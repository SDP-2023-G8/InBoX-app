import 'package:flutter/material.dart';

PreferredSizeWidget simpleBar(BuildContext context, String text) {
  return AppBar(
    backgroundColor: Colors.deepPurple,
    leading: IconButton(
      icon: const Icon(
        Icons.keyboard_arrow_left,
        size: 42.0,
        color: Colors.white,
      ),
      onPressed: () => Navigator.of(context).pop(),
    ),
    title: Text(text),
    centerTitle: true,
  );
}

// TODO: Bottom bar with three icons (deliveries list, home, settings)