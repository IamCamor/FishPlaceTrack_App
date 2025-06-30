import 'package:flutter/material.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  List<User> _friends = [];
  List<User> _allUsers = [];

  User? get currentUser => _currentUser;
  List<User> get friends => _friends;
  List<User> get allUsers => _allUsers;

  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void setFriends(List<User> friends) {
    _friends = friends;
    notifyListeners();
  }

  void setAllUsers(List<User> users) {
    _allUsers = users;
    notifyListeners();
  }

  User getUserById(String id) {
    return _allUsers.firstWhere(
      (user) => user.id == id,
      orElse: () => User(
        id: id,
        name: 'Неизвестный пользователь',
        email: '',
      ),
    );
  }
}