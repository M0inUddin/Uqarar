import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fyp/firebaseService/firebase_database.dart';
import 'package:fyp/model/accounts_model.dart';
import 'package:fyp/screens/signUp_screen.dart';
import '../firebaseService/firebase_auth.dart';
import 'home_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  String userRole = userMode.first;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff0E2954),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ));
                        },
                        child: const Text(
                          "Sign-Up",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        )),
                  )),
              const Padding(
                padding: EdgeInsets.only(
                  left: 20.0,
                  top: 30,
                  bottom: 15,
                ),
                child: Text(
                  "Welcome",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0, bottom: 20, right: 20),
                child: Text(
                  "Please login your account. If you don't have an account click on SignUp button below and enjoy.",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.elliptical(30, 30),
                          topRight: Radius.elliptical(30, 30)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 2,
                          spreadRadius: 1,
                        ),
                      ]),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextFormField(
                                controller: email,
                                decoration: InputDecoration(
                                    filled: true,
                                    hintText: "Username",
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Username must not be empty";
                                  }
                                  return null;
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextFormField(
                                controller: password,
                                obscureText: true,
                                decoration: InputDecoration(
                                    filled: true,
                                    hintText: "Password",
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "password must not be empty";
                                  }
                                  return null;
                                }),
                          ),
                          userDropdown(),
                          Container(
                            margin: const EdgeInsets.only(left: 200, top: 5),
                            child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 12),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 50),
                            child: Material(
                              type: MaterialType.transparency,
                              child: Ink(
                                height: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: const Color(0xff1F6E8C)),
                                child: InkWell(
                                    borderRadius: BorderRadius.circular(30),
                                    onTap: () async {
                                      if (_formKey.currentState!.validate()) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content:
                                                    Text("Data processing")));
                                        Accounts accountStatus =
                                            await FirebaseStoreDatabase()
                                                .checkCredentials(
                                                    email.text,
                                                    password.text,
                                                    userRole.toLowerCase());

                                        String loginStatus = 'null';
                                        if (accountStatus.userPassword ==
                                            password.text) {
                                          loginStatus = await AuthService()
                                              .loginAccount(
                                                  email.text, password.text);
                                        }
                                        checkUserRole(
                                            loginStatus, accountStatus);
                                      }
                                    },
                                    child: const Center(
                                      child: Text(
                                        "Sign-In",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ),
                            ),
                          ),
                          techSignInButton('./assets/google.png', "Google"),
                          techSignInButton('./assets/facebook.png', "Facebook"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget userDropdown() {
    return DropdownButton<String>(
        value: userRole,
        items: userMode.map<DropdownMenuItem<String>>((String user) {
          return DropdownMenuItem<String>(value: user, child: Text(user));
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            userRole = value!;
          });
        });
  }

  Widget techSignInButton(String buttonName, String techName) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromARGB(17, 0, 0, 0),
                  blurRadius: 2,
                  spreadRadius: 1)
            ]),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage(buttonName),
          ),
          Text(
            "Continue with $techName",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const Icon(
            Icons.arrow_forward,
            size: 18,
          )
        ]),
      ),
    );
  }

  void snackBarDiscription(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message.toString())));
  }

  void checkUserRole(String loginStatus, Accounts accountStatus) {
    if (loginStatus == 'user-not-found') {
      snackBarDiscription(loginStatus);
    } else if (loginStatus == 'wrong-password') {
      snackBarDiscription(loginStatus);
    } else if (loginStatus == accountStatus.userID) {
      showDialog(
        context: context,
        builder: (_) {
          return const AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              insetPadding: EdgeInsets.all(162),
              content: SizedBox(
                height: 50,
                width: 60,
                child: CircularProgressIndicator(),
              ));
        },
      );
      Timer(const Duration(seconds: 5), () {
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(userRole, accountStatus),
            ));
      });
    }
  }
}

List<String> userMode = ['Teacher', 'Student', 'Admin'];
