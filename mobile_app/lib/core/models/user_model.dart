class User {
  String id;
  String firstName;
  String lastName;
  String email;

  User(
    this.id,
    this.firstName,
    this.lastName,
    this.email,
  );

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      (json['_id']),
      (json['firstName']),
      (json['lastName']),
      (json['email']),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
      };
}
