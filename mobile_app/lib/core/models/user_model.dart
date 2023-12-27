class UserModel {
  String id;
  String firstName;
  String lastName;
  String? dob;
  String email;
  int phone;
  String role;
  String? gender;
  String status;
  String? profilePicUrl;
  String? citizenshipUrl;
  double? latitude;
  double? longitude;
  String? address;
  String? job;
  String? availability;
  String? paymentQrUrl;

  UserModel(
    this.id,
    this.firstName,
    this.lastName,
    this.dob,
    this.email,
    this.phone,
    this.role,
    this.gender,
    this.status,
    this.profilePicUrl,
    this.citizenshipUrl,
    this.latitude,
    this.longitude,
    this.address,
    this.job,
    this.availability,
    this.paymentQrUrl,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      (json['_id']),
      (json['firstName']),
      (json['lastName']),
      (json['dob']),
      (json['email']),
      (json['phone']),
      (json['role']),
      (json['gender']),
      (json['status']),
      (json['profilePicUrl']),
      (json['citizenshipUrl']),
      (json['latitude']),
      (json['longitude']),
      (json['address']),
      (json['job']),
      (json['availability']),
      (json['paymentQrUrl']),
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
        'gender': gender,
        'status': status,
        'profilePicUrl': profilePicUrl,
        'citizenshipUrl': citizenshipUrl,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'job': job,
        'availability': availability,
        'paymentQrUrl': paymentQrUrl,
      };
}
