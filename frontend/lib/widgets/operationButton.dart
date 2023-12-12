import 'package:flutter/material.dart';

class OperationButton extends StatelessWidget {
  const OperationButton(this.icon, this.text, {super.key});
  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Container(
        height: 150,
        width: 150,
        decoration: const BoxDecoration(
            color: Color(0xff1F6E8C),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  blurRadius: 0.5,
                  spreadRadius: 0.5,
                  color: Color.fromARGB(192, 148, 148, 148))
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              AssetImage("assets/$icon"),
              size: 60,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                text,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
