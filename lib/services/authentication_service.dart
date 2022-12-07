import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  Future signOut() async {
    await auth.signOut();
  }

  Future createAccount({required email, required password}) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await firestore
            .collection('teachers')
            .doc(auth.currentUser!.uid)
            .set({});
      });
      return "Request Successful";
    } catch (e) {
      return "Request Failed";
    }
  }

  Future loginUser({required email, required password}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return "Request Successful";
    } catch (e) {
      return "Request Failed";
    }
  }
}
