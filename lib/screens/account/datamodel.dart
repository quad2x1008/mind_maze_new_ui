class User{
  String? username;
  String? email;
  String? mobileno;
  String? password;

  User({required this.username, required this.email, required this.mobileno, required this.password});

  User.fromMap(Map<String, dynamic> map) {
    username = map['username'];
    email = map['email'];
    mobileno = map['mobileno'];
    password = map['password'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['mobileno'] = this.mobileno;
    data['password'] = this.password;

    return data;
  }
}