import 'package:flutter/material.dart';
import 'package:inbox_app/pages/login.dart';
import 'pop_ups.dart';

class SimpleBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  const SimpleBar(this.titleText, {Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
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
      title: Text(titleText),
      titleTextStyle: const TextStyle(fontSize: 25),
      centerTitle: true,
    );
  }
}

class BarWithHelp extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final String helpTitleText;
  final String helpText;
  const BarWithHelp(this.titleText, this.helpTitleText, this.helpText,
      {Key? key})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
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
        title: Text(titleText),
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
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    PopupHelpDialog(helpTitleText, helpText),
              );
            },
          )
        ]);
  }
}

class BottomBar extends StatelessWidget {
  // Page = 0 (deliveries); 1 (homepage); or 2 (settings).
  final int page;
  const BottomBar(this.page, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 55),
        child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              IconButton(
                icon: Icon(
                  Icons.list,
                  size: 40,
                  color: page == 0
                      ? const Color.fromARGB(255, 50, 5, 70)
                      : const Color.fromARGB(255, 103, 58, 183),
                  weight: page == 0 ? 2 : 1,
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen())),
              ),
              IconButton(
                icon: Icon(
                  Icons.home,
                  size: 40,
                  color: page == 1
                      ? const Color.fromARGB(255, 50, 5, 70)
                      : const Color.fromARGB(255, 103, 58, 183),
                  weight: page == 1 ? 2 : 1,
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen())),
              ),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  size: 40,
                  color: page == 2
                      ? const Color.fromARGB(255, 50, 5, 70)
                      : const Color.fromARGB(255, 103, 58, 183),
                  weight: page == 2 ? 2 : 1,
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen())),
              )
            ])));
  }
}
// TODO: Bottom bar with three icons (deliveries list, home, settings)
