class Meetings {
  String meetingID;
  String meetingName;
  String meetingDate;
  String meetingTime;
  String batchID;
  String departmentID;
  List<String> participent;

  Meetings(
      {required this.meetingID,
      required this.meetingName,
      required this.meetingDate,
      required this.meetingTime,
      required this.batchID,
      required this.departmentID,
      required this.participent});

  Map<String, dynamic> toJson() => {
        'meetingID': meetingID,
        'meetingName': meetingName,
        'meetingDate': meetingDate,
        'meetingTime': meetingTime,
        'batch': batchID,
        'department': departmentID,
        'participents': participent
      };

  static Meetings fromJson(Map<String, dynamic> json) {
    List<String> participents = List.empty();
    if (json['participents'] != null && json['participents'] != "") {
      participents = json['participents'].cast<String>().toList();
    }

    return Meetings(
        meetingID: json['meetingID'],
        meetingName: json['meetingName'],
        meetingDate: json['meetingDate'],
        meetingTime: json['meetingTime'],
        batchID: json['batch'],
        departmentID: json['department'],
        participent: participents);
  }
}
