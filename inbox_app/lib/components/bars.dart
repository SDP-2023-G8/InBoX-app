import 'package:flutter/material.dart';
import 'package:inbox_app/constants/constants.dart';
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
      backgroundColor: PRIMARY_GREEN,
      title: Text(titleText),
      titleTextStyle: const TextStyle(
          fontSize: 30, letterSpacing: 0.5, fontWeight: FontWeight.bold),
      centerTitle: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
    );
  }
}

class BarWithBackArrow extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  const BarWithBackArrow(this.titleText, {Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: PRIMARY_GREEN,
      leading: IconButton(
        icon: const Icon(
          Icons.keyboard_arrow_left,
          size: 40,
          color: Colors.white,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(titleText),
      titleTextStyle: const TextStyle(
          fontSize: 30, letterSpacing: 0.5, fontWeight: FontWeight.bold),
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
        backgroundColor: PRIMARY_GREEN,
        automaticallyImplyLeading: false,
        title: Text(titleText),
        titleTextStyle: const TextStyle(
            fontSize: 30, letterSpacing: 0.5, fontWeight: FontWeight.bold),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.info_outline,
              size: 30,
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

class BarWithHelpAndBackArrow extends StatelessWidget
    implements PreferredSizeWidget {
  final String titleText;
  final String helpTitleText;
  final String helpText;
  const BarWithHelpAndBackArrow(
      this.titleText, this.helpTitleText, this.helpText,
      {Key? key})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: PRIMARY_GREEN,
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_left,
            size: 40,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(titleText),
        titleTextStyle: const TextStyle(
            fontSize: 30, letterSpacing: 0.5, fontWeight: FontWeight.bold),
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
        height: 70,
        color: PRIMARY_GREY,
        padding: const EdgeInsets.only(bottom: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              IconButton(
                  icon: Icon(
                    Icons.list,
                    size: 45,
                    color: page == 0 ? PRIMARY_GREEN : PRIMARY_BLACK,
                  ),
                  onPressed: () => {
                        if (page != 0)
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DeliveriesScreen()))
                          }
                      }),
              IconButton(
                  icon: Icon(
                    Icons.home,
                    size: 45,
                    color: page == 1 ? PRIMARY_GREEN : PRIMARY_BLACK,
                  ),
                  onPressed: () => {
                        if (page != 1)
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()))
                          }
                      }),
              IconButton(
                  icon: Icon(
                    Icons.settings,
                    size: 45,
                    color: page == 2 ? PRIMARY_GREEN : PRIMARY_BLACK,
                  ),
                  onPressed: () => {
                        if (page != 2)
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingsScreen()))
                          }
                      })
            ]),
          ],
        ));
  }
}
