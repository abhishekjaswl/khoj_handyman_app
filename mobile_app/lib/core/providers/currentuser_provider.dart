import 'package:flutter/widgets.dart';

import '../models/user_model.dart';
import '../models/worker_model.dart';

class CurrentUser extends ChangeNotifier {
  UserModel _currentUser =
      UserModel('', '', '', '', '', 0, '', '', '', '', '', 0, 0, '');
  WorkerModel _currentWorker = WorkerModel('', '', '', '');

  UserModel get user => _currentUser;
  WorkerModel get worker => _currentWorker;

  void setUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void setWorker(WorkerModel worker) {
    _currentWorker = worker;
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
    _currentUser =
        UserModel('', '', '', '', '', 0, '', '', '', '', '', 0, 0, '');
  }
}
