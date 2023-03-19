import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_toastr/flutter_toastr.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'package:rafiki/models/TherapistModel.dart';
import 'package:rafiki/utilities/utility.dart';

class TherapyProvider extends ChangeNotifier {
  final user = FirebaseAuth.instance.currentUser;
  Therapist? _bookedTherapist;
  Therapist? get bookedTherapist => _bookedTherapist;

  List<Therapist> _therapyList = [];

  List<Therapist> get therapyList => _therapyList;

  Future<void> fetchTherapyData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://rafiki-511ac-default-rtdb.firebaseio.com/Therapists.json'));

      final data = json.decode(response.body) as Map<String, dynamic>;

      List<Therapist> therapyList = [];

      data.forEach((key, value) {
        therapyList.add(Therapist(
            description: value['description'] ?? '',
            specialties: value['specialties'] ?? '',
            id: key,
            name: value['name'] ?? '',
            phone: value['phone'] ?? '',
            county: value['county'] ?? '',
            rating: value['rating'].toString(),
            gender: value['gender'] ?? '',
            price: value['price'].toString()));
      });

      _therapyList = therapyList;
      notifyListeners();
    } on SocketException {
      errortoast('Check Your Internet Connection and Try Again');
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  //  function to book therapist for particular user
  Future<void> bookTherapist(Therapist therapist) async {
    final userId = user!.uid;
    try {
      final response = await http.get(Uri.parse(
          'https://rafiki-511ac-default-rtdb.firebaseio.com/UsersTherapists/$userId.json'));
      final data = json.decode(response.body);
      if (data != null) {
        // User already has a therapist
        errortoast('Cannot have more than one therapist');
      } else if (data == null) {
        // User has no therapist, so add the new therapist to the endpoint
        final response = await http.put(
            Uri.parse(
                'https://rafiki-511ac-default-rtdb.firebaseio.com/UsersTherapists/$userId.json'),
            body: json.encode({
              'description': therapist.description,
              'specialties': therapist.specialties,
              'id': therapist.id,
              'name': therapist.name,
              'phone': therapist.phone,
              'county': therapist.county,
              'rating': therapist.rating,
              'gender': therapist.gender,
              'price': therapist.price
            }));

        if (response.statusCode != 200 && response.statusCode != 201) {
          throw Exception('Failed to add therapist to UserTherapist endpoint');
        }
      } else {
        throw Exception('Failed to check UserTherapist endpoint for user');
      }
    } on SocketException {
      errortoast('Check Your Internet Connection and Try Again');
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  /// checks whether particular user has a
  Future<Therapist?> fetchUserTherapist() async {
    final userId = user!.uid;
    try {
      final response = await http.get(Uri.parse(
          'https://rafiki-511ac-default-rtdb.firebaseio.com/UsersTherapists/$userId.json'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null) {
          var therapist = Therapist(
              description: data['description'] ?? '',
              specialties: data['specialties'] ?? '',
              id: data['id'] ?? '',
              name: data['name'] ?? '',
              phone: data['phone'] ?? '',
              county: data['county'] ?? '',
              rating: data['rating'].toString(),
              gender: data['gender'] ?? '',
              price: data['price'].toString());
          _bookedTherapist = therapist;
          if (kDebugMode) {
            print(' ==================+++++++++++%%%%%%%%%%$_bookedTherapist');
          }
          notifyListeners();
          return therapist;
        }
      }
      return null;
    } on SocketException {
      errortoast('Check Your Internet Connection and Try Again');
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
    return null;
  }
}
