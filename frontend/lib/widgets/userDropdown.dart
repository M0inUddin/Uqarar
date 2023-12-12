import 'package:flutter/material.dart';
import 'package:fyp/firebaseService/firebase_database.dart';

List<String> userMode = ['Teacher', 'Student', 'Admin'];

class UserModeDropdown extends StatefulWidget {
  const UserModeDropdown(this.batch, {super.key});
  final String batch;

  @override
  State<UserModeDropdown> createState() => _UserModeDropdownState();
}

class _UserModeDropdownState extends State<UserModeDropdown> {
  String dropdownValue = userMode.first;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        value: dropdownValue,
        items: userMode.map<DropdownMenuItem<String>>((String user) {
          return DropdownMenuItem<String>(value: user, child: Text(user));
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            dropdownValue = value!;
            if (dropdownValue == 'Delete') {
              FirebaseStoreDatabase().deleteBatch(widget.batch);
            }
          });
        });
  }

  getValue() {
    return dropdownValue;
  }
}
