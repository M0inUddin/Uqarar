import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../all_screens.dart';
import '../../services/add_class_service.dart';

class AddClassAlert extends StatelessWidget {
  final classController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: const [
                  Text(
                    "Add New Batch",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: const TextStyle(fontSize: 17),
                      controller: classController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixText: "Batch ",
                        labelText: "Enter Batch",
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                      child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      child: const Text(
                        "Add Batch",
                        style: TextStyle(fontSize: 17),
                      ),
                      onPressed: () {
                        if (classController.text == "") {
                          Fluttertoast.showToast(
                            msg: "Please fill all fields",
                            gravity: ToastGravity.CENTER,
                            toastLength: Toast.LENGTH_LONG,
                          );
                        } else {
                          AddClassService()
                              .addMyClass(
                                  className:
                                      "Batch ${classController.text.trim()}")
                              .then((value) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllScreens("Home")),
                                (route) => false);
                          });
                        }
                      },
                    ),
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
