import 'package:flutter/material.dart';

import '../chapters/chapters.dart';

class CustomCard extends StatelessWidget {
  final String className, courseName;
  CustomCard({required this.className, required this.courseName});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChaptersScreen(
                      className: className, courseName: courseName)));
        },
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
                  color: Color(0xff7851a9),
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
                          courseName,
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
