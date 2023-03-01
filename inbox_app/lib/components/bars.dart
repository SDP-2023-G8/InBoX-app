import 'package:flutter/material.dart';

PreferredSizeWidget simpleBar(BuildContext context, String text) {
  return AppBar(
    backgroundColor: Colors.deepPurple,
    leading: IconButton(
      icon: const Icon(
        Icons.keyboard_arrow_left,
        size: 40,
        color: Colors.white,
      ),
      onPressed: () => Navigator.of(context).pop(),
    ),
    title: Text(text),
    centerTitle: true,
  );
}

PreferredSizeWidget barWithHelp(BuildContext context, String text) {
  return AppBar(
      backgroundColor: Colors.deepPurple,
      leading: IconButton(
        icon: const Icon(
          Icons.keyboard_arrow_left,
          size: 40,
          color: Colors.white,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(text),
      titleTextStyle: const TextStyle(fontSize: 25),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.help_outline,
            size: 40,
            color: Colors.white,
          ),
          onPressed: () {
            // TODO: insert a pop-up with instructions for registration
          },
        )
      ]);
}

// TODO: Bottom bar with three icons (deliveries list, home, settings)
