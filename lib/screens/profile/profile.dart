import 'package:flutter/material.dart';

import '../../services/authentication_service.dart';
import '../auth/login.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              AuthenticationService().signOut().then((value) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false);
              });
            },
            child: const Text(
              "SIGN OUT",
              style: TextStyle(fontSize: 17),
            ),
          ),
        ),
      ),
    );
  }
}
