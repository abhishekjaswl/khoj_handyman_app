class User {
  String id;
  String firstName;
  String lastName;
  String email;
  int phone;
  String dob;
  String role;
  String status;
  String? profilePicUrl;

  User(
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.dob,
    this.role,
    this.status,
    this.profilePicUrl,
  );

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      (json['_id']),
      (json['firstName']),
      (json['lastName']),
      (json['email']),
      (json['phone']),
      (json['dob']),
      (json['role']),
      (json['status']),
      (json['profilePicUrl']),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'dob': dob,
        'role': role,
        'status': status,
        'profilePicUrl': profilePicUrl,
      };
}
