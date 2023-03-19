import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';

class UserProvider extends ChangeNotifier {
  final databaseReference =
      FirebaseDatabase.instance.ref(); // Firebase Realtime Database reference

  void addUserDetails(String userId, String name, String phone, String gender,
      int yearOfBirth, String email) {
    databaseReference.child('Users/$userId').push().set({
      'name': name,
      'phone': phone,
      'gender': gender,
      'yearOfBirth': yearOfBirth,
      'email': email,
    }).then((value) {
      if (kDebugMode) {
        print('User details added successfully!');
      }
      notifyListeners();
    }).catchError((error) {
      if (kDebugMode) {
        print('Failed to add user details: $error');
      }
    });
  }

  void updateUserDetails(String userId, String name, String phone,
      String gender, int yearOfBirth, String email) {
    databaseReference.child('Users/$userId').update({
      'name': name,
      'phone': phone,
      'gender': gender,
      'yearOfBirth': yearOfBirth,
      'email': email,
    }).then((value) {
      if (kDebugMode) {
        print('User details updated successfully!');
      }
      notifyListeners();
    }).catchError((error) {
      if (kDebugMode) {
        print('Failed to update user details: $error');
      }
    });
  }
}
