import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<String> createAccount(
    String username,
    String email,
    String password,
  ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      final String uid = await getUserID();

      return uid;
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  getUserID() {
    User? user = _auth.currentUser;
    final uid = user?.uid;

    return uid;
  }

  Future<String> loginAccount(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      final String uid = await AuthService().getUserID();

      return uid;
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future loginStudentAccount(
      String email, String password, String batch, String department) async {
    String userId = "";

    await FirebaseFirestore.instance
        .collection('batch')
        .doc(batch)
        .collection('department')
        .doc(department)
        .collection("students")
        .get()
        .then(
          (value) => value.docs.map(
            (doc) {
              if (doc.data()["email"] == email) {
                userId = doc.id;
                return;
              }
            },
          ),
        );
    print("USER ID: ${userId}");
    return userId;
  }

  Future logout() async {
    await _auth.signOut();
  }
}
