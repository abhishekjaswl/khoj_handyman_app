import 'package:flutter/widgets.dart';

import '../models/user_model.dart';

class CurrentUser extends ChangeNotifier {
  User _currentUser = User('', '', '', '', 0, '', '', '', '');

  User get user => _currentUser;

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void updateProfilePicUrl(String newProfilePicUrl) {
    _currentUser.profilePicUrl = newProfilePicUrl;
    notifyListeners();
  }
}
