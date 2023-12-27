import 'package:flutter/widgets.dart';

import '../models/user_model.dart';

class CurrentUser extends ChangeNotifier {
  UserModel _currentUser = UserModel(
      '', '', '', '', '', 0, '', '', '', '', '', 0, 0, '', '', '', '');

  UserModel get user => _currentUser;

  void setUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void setAddress(
    double newLatitude,
    double newLongitude,
    String newAddress,
  ) {
    _currentUser.latitude = newLatitude;
    _currentUser.longitude = newLongitude;
    _currentUser.address = newAddress;
    notifyListeners();
  }

  void logoutUser() {
    _currentUser = UserModel(
        '', '', '', '', '', 0, '', '', '', '', '', 0, 0, '', '', '', '');
  }
}
