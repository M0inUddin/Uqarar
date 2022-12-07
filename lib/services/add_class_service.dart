import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddClassService {
  final user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;

  Future addMyClass({required String className}) async {
    try {
      await firestore
          .collection('teachers')
          .doc(user!.uid)
          .collection('my_classes')
          .doc(className)
          .set({
        "className": className,
      });
      return "Request Successful";
    } on FirebaseException catch (e) {
      print(e.message);
      return "Request Failed";
    }
  }

  // Future getMyClasses() async {
  //   List myClasses = [];
  //   await firestore
  //       .collection('teachers')
  //       .doc(user!.uid)
  //       .collection('my_classes')
  //       .get()
  //       .then((value) =>
  //           myClasses += value.docs.map((doc) => doc.data()).toList());
  //   return myClasses;
  // }
}
