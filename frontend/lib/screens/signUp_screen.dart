import 'package:flutter/material.dart';
import 'package:fyp/firebaseService/firebase_auth.dart';
import 'package:fyp/screens/signIn_screen.dart';
import 'package:fyp/utils/notification_util.dart';
import '../firebaseService/firebase_database.dart';
import '../widgets/userDropdown.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String dropdownValue = userMode.first;
  UserModeDropdown role = const UserModeDropdown("");

  AuthService userAuth = AuthService();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff0E2954),
        // color: const Color(0xff0E2954),
        body: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
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
                              builder: (context) => const SigninScreen(),
                            ));
                      },
                      child: const Text(
                        "Sign-In",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      )),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 20.0,
                  top: 10,
                  bottom: 10,
                ),
                child: Text(
                  "Create your account",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0, bottom: 20, right: 20),
                child: Text(
                  "Please login your account. If you don't have an account click on SignUp button top-right cornor and enjoy.",
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
                        const EdgeInsets.only(left: 20.0, right: 20, top: 30),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 5),
                            child: TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                    filled: true,
                                    hintText: "Username",
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "username must not be null";
                                  }
                                  return null;
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 5),
                            child: TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                    filled: true,
                                    hintText: "Email",
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      !value.contains("@") ||
                                      !value.contains(".")) {
                                    return "Enter valid email";
                                  }
                                  return null;
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 5),
                            child: TextFormField(
                                obscureText: true,
                                controller: passwordController,
                                decoration: InputDecoration(
                                    filled: true,
                                    hintText: "Password",
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length < 8) {
                                    return "password must not be empty";
                                  }
                                  return null;
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 5),
                            child: TextFormField(
                                obscureText: true,
                                controller: confirmPasswordController,
                                decoration: InputDecoration(
                                    filled: true,
                                    hintText: "Confirm Password",
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length < 8) {
                                    return "password must not be empty";
                                  }
                                  return null;
                                }),
                          ),
                          userDropdown(),
                          Container(
                            margin: const EdgeInsets.only(left: 200, top: 0),
                            child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 12),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Material(
                              type: MaterialType.transparency,
                              child: Ink(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: const Color(0xff1F6E8C)),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(30),
                                  onTap: () {
                                    if (_formkey.currentState!.validate() &&
                                        passwordController.text ==
                                            confirmPasswordController.text) {
                                      NotificationUtils.showSnackBar(
                                          "Data processing", context);

                                      String accountStatus =
                                          userAuth.createAccount(
                                                  nameController.text,
                                                  emailController.text,
                                                  passwordController.text)
                                              as String;
                                      if (accountStatus ==
                                          'email-already-in-use') {
                                        NotificationUtils.showSnackBar(
                                            accountStatus, context);
                                      } else if (accountStatus ==
                                          'invalid-email') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(accountStatus)));
                                      } else if (accountStatus ==
                                          'weak-password') {
                                        NotificationUtils.showSnackBar(
                                            accountStatus, context);
                                      } else {
                                        if (dropdownValue.toString() ==
                                            "Admin") {
                                          FirebaseStoreDatabase()
                                              .addCredentialsIndb(
                                                  accountStatus,
                                                  nameController.text,
                                                  emailController.text,
                                                  passwordController.text,
                                                  "admin");

                                          NotificationUtils().successNotifier(
                                              context,
                                              "Account created successfully");
                                        } else if (dropdownValue == "Teacher") {
                                          FirebaseStoreDatabase()
                                              .addCredentialsIndb(
                                                  accountStatus,
                                                  nameController.text,
                                                  emailController.text,
                                                  passwordController.text,
                                                  "teachers");
                                          NotificationUtils().successNotifier(
                                              context,
                                              "Account created successfully");
                                        } else {
                                          FirebaseStoreDatabase()
                                              .addCredentialsIndb(
                                                  accountStatus,
                                                  nameController.text,
                                                  emailController.text,
                                                  passwordController.text,
                                                  "student");
                                        }
                                        NotificationUtils().successNotifier(
                                            context,
                                            "Account created successfully");
                                      }
                                    } else {
                                      NotificationUtils().failedNotifier(
                                          context,
                                          "Username or password invalid");
                                    }
                                  },
                                  child: const Center(
                                    child: Text(
                                      "SignUp",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
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
                              child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      backgroundImage:
                                          AssetImage('./assets/google.png'),
                                      radius: 18,
                                    ),
                                    Text(
                                      "Continue with Google",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 18,
                                    )
                                  ]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
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
                              child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      backgroundImage:
                                          AssetImage('./assets/facebook.png'),
                                    ),
                                    Text(
                                      "Continue with Facebook",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 18,
                                    )
                                  ]),
                            ),
                          ),
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
        value: dropdownValue,
        items: userMode.map<DropdownMenuItem<String>>((String user) {
          return DropdownMenuItem<String>(value: user, child: Text(user));
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            dropdownValue = value!;
          });
        });
  }
}

List<String> userMode = ['Teacher', 'Student', 'Admin'];
