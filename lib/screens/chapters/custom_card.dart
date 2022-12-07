/*import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String className;
  CustomCard({required this.className});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 6.5,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 35, 156, 236),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          className,
                          style: const TextStyle(fontSize: 21),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(children: const []),
            ],
          ),
        ),
      ),
    );
  }
}
*/