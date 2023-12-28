import 'package:flutter/widgets.dart';

import '../models/user_model.dart';

class CurrentUser extends ChangeNotifier {
  UserModel _currentUser = UserModel.empty();

  UserModel get user => _currentUser;

  void setUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void setAddress(double newLatitude, double newLongitude, String newAddress) {
    _currentUser.updateAddress(newLatitude, newLongitude, newAddress);
    notifyListeners();
  }

  void logoutUser() {
    _currentUser = UserModel.empty();
    notifyListeners();
  }
}
