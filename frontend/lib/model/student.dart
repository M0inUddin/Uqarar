class Student {
  String studentID;
  String studentName;
  String studentRegistrationNo;

  Student({
    required this.studentID,
    required this.studentName,
    required this.studentRegistrationNo,
  });

  Map<String, dynamic> toJson() => {
        'id': studentID,
        'name': studentName,
        'registrationNo': studentRegistrationNo,
      };

  static Student fromJson(Map<String, dynamic> json) {
    return Student(
      studentID: json['id'],
      studentName: json['name'],
      studentRegistrationNo: json['registrationNo'],
    );
  }
}
