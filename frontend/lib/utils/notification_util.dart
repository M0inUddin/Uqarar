import 'package:flutter/material.dart';

class NotificationUtils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String text, BuildContext context) {
    final snackBar = SnackBar(
      elevation: 0,
      content: Container(
          height: 60,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: Color.fromARGB(14, 0, 0, 0),
                  blurRadius: 3,
                  spreadRadius: 8)
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 18.0, right: 15),
                    child: Image(
                      image: AssetImage("./images/check.png"),
                      height: 30,
                    ),
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 16,
                  ))
            ],
          )),
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  successNotifier(BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                const CircleAvatar(
                    radius: 15,
                    backgroundImage: AssetImage("./assets/done.png")),
                Text(message),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
  }

  failedNotifier(BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(message),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
  }
}
