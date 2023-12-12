import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/firebaseService/firebase_auth.dart';
import '../model/accounts_model.dart';
import '../model/batch.dart';
import '../model/department.dart';
import '../model/meetings.dart';

class FirebaseStoreDatabase {
  final firebaseDatabase = FirebaseFirestore.instance;

  Future addCredentialsIndb(String userID, String username, String email,
      String password, String role) async {
    final addData = firebaseDatabase.collection(role).doc(userID);

    final json = Accounts(
            userID: userID,
            userName: username,
            userEmail: email,
            userPassword: password)
        .toJson();

    addData.set(json);
  }

  Future<Accounts> checkCredentials(
      String email, String password, String role) async {
    final snapshot = await firebaseDatabase
        .collection(role == 'teacher' ? "teachers" : role)
        .where(
          'email',
          isEqualTo: email,
        )
        .where('password', isEqualTo: password)
        .get();

    final userData =
        snapshot.docs.map((e) => Accounts.fromJson(e.data())).single;
    return userData;
  }

  Future<Accounts> getDepartments() async {
    final snapshot = await firebaseDatabase
        .collection('batch')
        .doc()
        .collection('department')
        .get();

    final userData =
        snapshot.docs.map((e) => Accounts.fromJson(e.data())).single;
    return userData;
  }

  Future<Accounts> getUserDetail(
      String email, String password, String role) async {
    final checkRole = firebaseDatabase
        .collection(role == "teacher" ? 'teachers' : role)
        .doc(email.toLowerCase());
    final snapshot = await checkRole.get();

    if (snapshot.exists) {
      if (Accounts.fromJson(snapshot.data()!)
                  .userEmail
                  .toLowerCase()
                  .toString() ==
              email.toLowerCase() &&
          Accounts.fromJson(snapshot.data()!)
                  .userPassword
                  .toLowerCase()
                  .toString() ==
              password.toLowerCase()) {
        return Accounts.fromJson(snapshot.data()!);
      }
    }
    return Accounts(userID: "", userName: "", userEmail: "", userPassword: "");
  }

  Future addBatch(String batch) async {
    final batchDoc = firebaseDatabase.collection('batch').doc(batch);

    final json = {
      'id': batch,
      'batchYear': batch,
    };

    await batchDoc.set(json);
  }

  deleteBatch(String batch) async {
    await FirebaseFirestore.instance.collection('batch').doc(batch).delete();
  }

  deleteMeeting(String meetingID, String teacherID) async {
    await FirebaseFirestore.instance
        .collection('teachers')
        .doc(teacherID)
        .collection('meetings')
        .doc(meetingID)
        .delete();

    await FirebaseFirestore.instance
        .collection('meetings')
        .doc(meetingID)
        .delete();
  }

  Future addDepartment(String department, String batch) async {
    final batchDoc = firebaseDatabase
        .collection('batch')
        .doc(batch)
        .collection('department')
        .doc(department);

    final json = {
      'departmentID': department,
      'departmentName': department,
      'batch': batch,
    };

    await batchDoc.set(json);
  }

  createMeeting(Meetings meetingdetail, String meetingID) async {
    final addMeeting = firebaseDatabase.collection('meetings').doc(meetingID);

    await addMeeting.set(Meetings(
            meetingID: meetingID,
            meetingName: meetingdetail.meetingName,
            meetingDate: meetingdetail.meetingDate,
            meetingTime: meetingdetail.meetingTime,
            batchID: meetingdetail.batchID,
            departmentID: meetingdetail.departmentID,
            participent: meetingdetail.participent)
        .toJson());
  }

  addTeacherMeeting(
    Meetings meetingdetail,
    String teacherID,
  ) async {
    final addMeeting = firebaseDatabase
        .collection('teachers')
        .doc(teacherID)
        .collection('meetings')
        .doc();

    await addMeeting.set(Meetings(
            meetingID: addMeeting.id,
            meetingName: meetingdetail.meetingName,
            meetingDate: meetingdetail.meetingDate,
            meetingTime: meetingdetail.meetingTime,
            batchID: meetingdetail.batchID,
            departmentID: meetingdetail.departmentID,
            participent: meetingdetail.participent)
        .toJson());

    createMeeting(meetingdetail, addMeeting.id);
  }

  Stream<List<Meetings>> readMeetings() {
    String studentID = AuthService().getUserID();
    return firebaseDatabase
        .collection('meetings')
        .where("participents", arrayContains: studentID)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((docs) => Meetings.fromJson(docs.data()))
            .toList());
  }

  Stream<List<Meetings>> readMeetingsForTeacher(String teacherId) =>
      FirebaseFirestore.instance
          .collection('teachers')
          .doc(teacherId)
          .collection('meetings')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((docs) => Meetings.fromJson(docs.data()))
              .toList());

  Stream<List<Batchs>> readBatch() => FirebaseFirestore.instance
      .collection('batch')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((docs) => Batchs.fromJson(docs.data())).toList());

  Stream<List<Department>> readDepartment(String batch) =>
      FirebaseFirestore.instance
          .collection('batch')
          .doc(batch)
          .collection('department')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((docs) => Department.fromJson(docs.data()))
              .toList());

  Future<List<Department>> readDepartmentForTeacher(
      String batch, String department) async {
    String teacherID = await AuthService().getUserID();
    final snapshot = await FirebaseFirestore.instance
        .collection('batch')
        .doc(batch)
        .collection('department')
        .where('teachers', arrayContains: teacherID)
        .get();

    final list =
        snapshot.docs.map((e) => Department.fromJson(e.data())).toList();

    return list;
  }

  Future<List<Accounts>> readTeachers() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('teachers');

    QuerySnapshot querySnapshot = await ref.get();

    List<Accounts> data = querySnapshot.docs
        .map((doc) => Accounts.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    return data;
  }

  Future<List<Accounts>> readStudent() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('student');

    QuerySnapshot querySnapshot = await ref.get();
    List<Accounts> data = querySnapshot.docs
        .map((doc) => Accounts.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    print("===================${data[0]}");
    return data;
  }

  Future addTeacherToDepartment(
      List<Accounts> teachers, String batch, String department) async {
    final departmentQuery = FirebaseFirestore.instance
        .collection('batch')
        .doc(batch)
        .collection('department')
        .doc(department);

    await departmentQuery.update({'teachers': teachers.map((e) => e.userID)});
  }

  Future addStudent(
    String batch,
    String department,
    String name,
    String rollNo,
    String address,
    String phone,
    String email,
    String dob,
  ) async {
    final saveStudent = FirebaseFirestore.instance
        .collection('batch')
        .doc(batch)
        .collection('department')
        .doc(department)
        .collection('students')
        .doc();

    saveStudent.set({
      "id": saveStudent.id,
      "rollno": rollNo,
      "name": name,
      "email": email,
      "address": address,
      "phone": phone,
      "dob": dob,
      "program_details": {
        "semester_one": {
          "codes": [
            "sc1201",
            "sc1001",
            "hu1002",
            "cs1501",
            "cs1001",
          ],
          "courses": [
            "Applied Physics",
            "Calculus & Analytic Geometry",
            "English Composition & Comprehension",
            "Introduction to Information and Communication Technologies",
            "Programming Fundamentals",
          ],
          "credits": [
            3,
            3,
            3,
            2,
            4,
          ],
          "grades": [
            "",
            "",
            "",
            "",
            "",
          ],
        },
        "semester_two": {
          "codes": [
            "hu1003",
            "cs1502",
            "hu1101",
            "sc1002",
            "cs2301",
            "cs1002",
          ],
          "courses": [
            "Communication & Presentation Skills",
            "Digital Logic and Design",
            "Islamic Studies",
            "Multivariate Calculus",
            "Discrete Structures",
            "Programming Techniques",
          ],
          "credits": [
            3,
            4,
            2,
            2,
            2,
            2,
          ],
          "grades": [
            "",
            "",
            "",
            "",
            "",
            "",
          ],
        },
        "semester_three": {
          "codes": [
            "cs2503",
            "cs2003",
            "sc2003",
            "hu1102",
            "cs2004",
          ],
          "courses": [
            "Computer Organization & Assembly Language",
            "Data Structure and Algorithms",
            "Differential Equations",
            "Pakistan Studies",
            "Object Oriented Programming",
          ],
          "credits": [
            4,
            4,
            3,
            2,
            4,
          ],
          "grades": [
            "",
            "",
            "",
            "",
            "",
          ],
        },
        "semester_four": {
          "codes": [
            "cs2201",
            "cs2504",
            "sc2004",
            "cs2101",
          ],
          "courses": [
            "Introduction to Database Systems",
            "Operating Systems",
            "Probability and Statistics",
            "Software Engineering",
          ],
          "credits": [
            4,
            4,
            3,
            3,
          ],
          "grades": [
            "",
            "",
            "",
            "",
          ],
        },
        "semester_five": {
          "codes": [
            "cs4303",
            "cs3005",
            "cs3202",
            "cs3002",
            "cs3003",
          ],
          "courses": [
            "Artificial Intelligence",
            "Design & Analysis of Algorithms",
            "Web Engineering",
            "Computer Networks",
            "Software Project Management",
          ],
          "credits": [
            4,
            3,
            4,
            3,
            3,
          ],
          "grades": [
            "",
            "",
            "",
            "",
            "",
          ],
        },
        "semester_six": {
          "codes": [
            "cs3701",
            "cs4102",
            "cs3702",
            "cs4001",
            "cs4602",
          ],
          "courses": [
            "Computer Graphics",
            "Software Project-I",
            "Theory of Automata",
            "Digital Image Processing",
            "Data Warehousing & Data Mining",
          ],
          "credits": [
            4,
            4,
            3,
            3,
            3,
          ],
          "grades": [
            "",
            "",
            "",
            "",
            "",
          ],
        },
        "semester_seven": {
          "codes": [
            "cs3701",
            "cs4802",
            "cs4201",
            "cs4302",
            "cs4503",
            "cs4004",
          ],
          "courses": [
            "Introduction to Machine Learning",
            "Software Project-II",
            "Advanced Database Systems",
            "Software Quality Assurance",
            "Compiler Construction",
            "Parallel Computing",
          ],
          "credits": [
            3,
            3,
            3,
            3,
            3,
            3,
          ],
          "grades": [
            "",
            "",
            "",
            "",
            "",
            "",
          ],
        },
        "semester_eight": {
          "codes": [
            "cs4801",
            "cs4902",
            "cs4502",
            "cs4603",
            "cs4005",
          ],
          "courses": [
            "Final Year Project",
            "Software Project-III",
            "Advanced Operating Systems",
            "Human Computer Interaction",
            "Wireless Networks",
          ],
          "credits": [
            4,
            4,
            4,
            3,
            3,
          ],
          "grades": [
            "",
            "",
            "",
            "",
            "",
          ],
        },
      }
    });
  }

  Future readStudentsofBatch(String batch, String department) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('batch')
        .doc(batch)
        .collection('department')
        .doc(department)
        .collection("students")
        .get();

    var list = snapshot.docs.map((doc) => doc.data()).toList();
    return list;
  }
}
