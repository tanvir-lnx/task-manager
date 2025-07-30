class User {
  final String? id;
  final String email;
  final String firstName;
  final String lastName;
  final String mobile;
  final String? password;
  final String? createdDate;

  User({
    this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    this.password,
    this.createdDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      mobile: json['mobile'] ?? '',
      password: json['password'],
      createdDate: json['createdDate'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'mobile': mobile,
    };
    if (password != null && password!.isNotEmpty) {
      map['password'] = password!;
    }
    return map;
  }
}
