class Department {
  String departmentID;
  String departmentName;
  String batch;
  List<String>? teachers;

  Department(
      {this.departmentID = '',
      required this.departmentName,
      required this.batch,
      this.teachers});

  Map<String, dynamic> toJson() => {
        'departmentID': departmentID,
        'departmentName': departmentName,
        'batch': batch,
        'teachers': teachers
      };

  static Department fromJson(Map<String, dynamic> jsonObj) {
    List<String> teachersList = List.empty();
    if (jsonObj['teachers'] != null && jsonObj['teachers'] != "") {
      teachersList = jsonObj['teachers'].cast<String>().toList();
    }
    return Department(
        departmentID: jsonObj['departmentID'],
        departmentName: jsonObj['departmentName'],
        batch: jsonObj['batch'],
        teachers: teachersList);
  }
}
