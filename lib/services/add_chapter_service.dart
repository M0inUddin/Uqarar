import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddChapterService {
  final user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;

  Future addChapter({
    required String className,
    required String courseName,
    required String chapterName,
  }) async {
    try {
      await firestore
          .collection('teachers')
          .doc(user!.uid)
          .collection('my_classes')
          .doc(className)
          .collection("courses")
          .doc(courseName)
          .collection('chapters')
          .doc(chapterName)
          .set({"chapterName": chapterName});

      return "Request Successful";
    } on FirebaseException catch (e) {
      print(e.message);
      return "Request Failed";
    }
  }
}
