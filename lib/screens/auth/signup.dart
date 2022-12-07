import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../all_screens.dart';
import '../../services/authentication_service.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 9, 36, 117),
        title: const Text("Uqarar"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  "assets/logo_final.png",
                  scale: 1.0,
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: emailController,
                  style: const TextStyle(fontSize: 17),
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  style: const TextStyle(fontSize: 17),
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: (obscureText == true)
                          ? Icon(Icons.text_fields)
                          : Icon(Icons.password),
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (emailController.text == "" ||
                                passwordController.text == "") {
                              Fluttertoast.showToast(
                                msg: "Please fill all fields",
                                gravity: ToastGravity.CENTER,
                                toastLength: Toast.LENGTH_LONG,
                              );
                            } else if (passwordController.text.trim().length <
                                6) {
                              Fluttertoast.showToast(
                                msg:
                                    "Password should me more than 6 characters",
                                gravity: ToastGravity.CENTER,
                                toastLength: Toast.LENGTH_LONG,
                              );
                            } else {
                              await AuthenticationService()
                                  .createAccount(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim())
                                  .then((result) {
                                if (result == "Request Successful") {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AllScreens("Home")),
                                      (route) => false);
                                }
                              });
                            }
                          },
                          child: const Text(
                            "Signup",
                            style: TextStyle(fontSize: 18),
                          )),
                    )),
                  ],
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Already have an account?",
                    style: TextStyle(
                        color: Color.fromARGB(255, 9, 36, 117),
                        decoration: TextDecoration.underline),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
