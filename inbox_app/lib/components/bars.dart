import 'package:flutter/material.dart';
import '../pages/deliveries.dart';
import '../pages/homepage.dart';
import '../pages/settings.dart';
import 'pop_ups.dart';

class SimpleBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  const SimpleBar(this.titleText, {Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.deepPurple,
      title: Text(titleText),
      titleTextStyle: const TextStyle(fontSize: 30, letterSpacing: 0.5),
      centerTitle: true,
    );
  }
}

class SimpleBarWithBackArrow extends StatelessWidget
    implements PreferredSizeWidget {
  final String titleText;
  const SimpleBarWithBackArrow(this.titleText, {Key? key}) : super(key: key);

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
      titleTextStyle: const TextStyle(fontSize: 30, letterSpacing: 0.5),
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
        titleTextStyle: const TextStyle(fontSize: 30, letterSpacing: 0.5),
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
  const BottomBar(this.page, {super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        height: 60,
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(color: Colors.deepPurple, height: 2),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              IconButton(
                icon: Icon(
                  Icons.list,
                  size: 40,
                  color: page == 0
                      ? const Color.fromARGB(255, 50, 5, 70)
                      : const Color.fromARGB(255, 170, 120, 255),
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DeliveriesScreen())),
              ),
              IconButton(
                icon: Icon(
                  Icons.home,
                  size: 40,
                  color: page == 1
                      ? const Color.fromARGB(255, 50, 5, 70)
                      : const Color.fromARGB(255, 170, 120, 255),
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen())),
              ),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  size: 40,
                  color: page == 2
                      ? const Color.fromARGB(255, 50, 5, 70)
                      : const Color.fromARGB(255, 170, 120, 255),
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen())),
              )
            ]),
          ],
        ));
  }
}
// TODO: Bottom bar with three icons (deliveries list, home, settings)
