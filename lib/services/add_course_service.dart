import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCourseService {
  final user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;

  Future addMyCourse(
      {required String className, required String courseName}) async {
    try {
      await firestore
          .collection('teachers')
          .doc(user!.uid)
          .collection('my_classes')
          .doc(className)
          .collection("courses")
          .doc(courseName)
          .set({"courseName": courseName});

      return "Request Successful";
    } on FirebaseException catch (e) {
      print(e.message);
      return "Request Failed";
    }
  }
}
