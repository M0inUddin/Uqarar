class Accounts {
  String userID = '';
  String userName = '';
  String userEmail = '';
  String userPassword = '';

  Accounts(
      {required this.userID,
      required this.userName,
      required this.userEmail,
      required this.userPassword});

  Map<String, dynamic> toJson() => {
        'id': userID,
        'name': userName,
        'email': userEmail,
        'password': userPassword
      };

  static Accounts fromJson(Map<String, dynamic> json) => Accounts(
      userID: json['id'],
      userName: json['name'],
      userEmail: json['email'],
      userPassword: json['password']);
}
