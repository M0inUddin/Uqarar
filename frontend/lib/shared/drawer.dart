import 'package:flutter/material.dart';
import 'package:fyp/screens/signIn_screen.dart';
import '../firebaseService/firebase_auth.dart';
import '../model/accounts_model.dart';
import '../screens/home_screen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer(this.context1, this.accountDetail, {super.key});
  final BuildContext context1;
  final Accounts accountDetail;
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: buildMenuItems(context),
    ));
  }

  List<Widget> buildMenuItems(BuildContext context) {
    List<String> menuTitles = ['Setting', 'Help', 'Logout'];
    List<Widget> menuIcon = [
      const Icon(Icons.settings_rounded),
      const Icon(Icons.help_rounded),
      const Icon(Icons.logout_rounded),
    ];

    List<Widget> menuItems = [];

    menuItems.add(DrawerHeader(
        decoration: const BoxDecoration(),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: const Color(0xff1F3F72),
              child: Text(
                widget.accountDetail.userName[0].toUpperCase(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 55,
                    fontWeight: FontWeight.w900),
              ),
            ),
            Text(
              widget.accountDetail.userName,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            Text(
              widget.accountDetail.userEmail,
              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            )
          ],
        )));
    int counter = 0;
    for (var element in menuTitles) {
      Widget screen = Container();
      menuItems.add(ListTile(
        leading: menuIcon[counter],
        title: Text(
          element,
          style: const TextStyle(fontSize: 16),
        ),
        onTap: () {
          switch (element) {
            case 'Setting':
              screen = HomeScreen(
                  "",
                  Accounts(
                      userID: "",
                      userName: "",
                      userEmail: "",
                      userPassword: ""));
              break;
            case 'Help':
              //screen = const NewsScreen();
              break;
            case 'Logout':
              screen = const SigninScreen();
              break;
          }
          AuthService().logout();
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => screen,
          ));
        },
      ));
      counter++;
    }
    menuItems.add(SizedBox(
      height: MediaQuery.sizeOf(context).height / 2.5,
    ));

    return menuItems;
  }
}
