class UserModel {
  String id;
  String firstName;
  String lastName;
  DateTime? dob;
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

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.dob,
    required this.email,
    required this.phone,
    required this.role,
    this.gender,
    required this.status,
    this.profilePicUrl,
    this.citizenshipUrl,
    this.latitude,
    this.longitude,
    this.address,
    this.job,
    this.availability,
    this.paymentQrUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      gender: json['gender'],
      status: json['status'],
      profilePicUrl: json['profilePicUrl'],
      citizenshipUrl: json['citizenshipUrl'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      job: json['job'],
      availability: json['availability'],
      paymentQrUrl: json['paymentQrUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'dob': dob
            ?.toUtc()
            .toIso8601String(), // Format as "2023-12-28T18:51:00.000"
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

  UserModel.empty()
      : id = '',
        firstName = '',
        lastName = '',
        dob = null,
        email = '',
        phone = 0,
        role = '',
        gender = null,
        status = '',
        profilePicUrl = '',
        citizenshipUrl = '',
        latitude = 0,
        longitude = 0,
        address = '',
        job = '',
        availability = '',
        paymentQrUrl = '';

  void updateAddress(
      double newLatitude, double newLongitude, String newAddress) {
    latitude = newLatitude;
    longitude = newLongitude;
    address = newAddress;
  }
}

class BookingModel {
  String id;
  UserModel user;
  DateTime dateTime;

  BookingModel({
    required this.id,
    required this.user,
    required this.dateTime,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        id: json['_id'],
        user: UserModel.fromJson(json['user']),
        dateTime: DateTime.parse(json['dateTime']),
      );

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'dateTime': dateTime.toIso8601String(),
      };
}
