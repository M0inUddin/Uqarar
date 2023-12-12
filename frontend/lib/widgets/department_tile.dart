import 'package:flutter/material.dart';
import 'package:fyp/utils/colors.dart';

class DepartmentTile extends StatelessWidget {
  final String departmentName;
  final String batch;
  final int index;
  final String role;

  DepartmentTile(this.departmentName, this.batch, this.index, this.role,
      {super.key});
  final List<String> options = ["Edit", "Delete"];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 140,
            width: 160,
            decoration: BoxDecoration(
                color: mycolorlist[index],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                boxShadow: const [
                  BoxShadow(blurRadius: 2, color: Colors.black12)
                ]),
            child: role == "Admin"
                ? Align(
                    alignment: Alignment.topRight,
                    child: PopupMenuButton(
                        icon: const Icon(
                          Icons.menu_rounded,
                          color: Colors.white,
                        ),
                        itemBuilder: (BuildContext context) =>
                            options.map((String value) {
                              return PopupMenuItem(
                                  value: value, child: Text(value));
                            }).toList()),
                  )
                : SizedBox()),
        Container(
          height: 60,
          width: 160,
          decoration: const BoxDecoration(
              color: Color.fromARGB(223, 92, 83, 83),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5)),
              boxShadow: [BoxShadow(blurRadius: 2, color: Colors.black12)]),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                "$departmentName\n$batch",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
