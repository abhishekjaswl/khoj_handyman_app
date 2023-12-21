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
  String? citizenshipUrl;

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
    this.citizenshipUrl,
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
      (json['citizenshipUrl']),
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
        'citizenshipUrl': citizenshipUrl,
      };
}
