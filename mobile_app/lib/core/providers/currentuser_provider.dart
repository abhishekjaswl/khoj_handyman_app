import 'package:flutter/widgets.dart';

import '../models/user_model.dart';

class CurrentUser extends ChangeNotifier {
  User _currentUser = User('', '', '', '', 0, '', '', '', '', '', 0, 0, '');

  User get user => _currentUser;

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void updateProfilePicUrl(String newProfilePicUrl) {
    _currentUser.profilePicUrl = newProfilePicUrl;
    notifyListeners();
  }

  void updateCitizenshipUrl(String newCitizenship) {
    _currentUser.citizenshipUrl = newCitizenship;
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
    _currentUser = User('', '', '', '', 0, '', '', '', '', '', 0, 0, '');
  }
}
