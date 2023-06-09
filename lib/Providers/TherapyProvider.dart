import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'package:rafiki/models/TherapistModel.dart';
import 'package:rafiki/screens/Therapist/TherapistHomescreen.dart';
import 'package:rafiki/utilities/utility.dart';
import 'package:uuid/uuid.dart';

class TherapyProvider extends ChangeNotifier {
  final user = FirebaseAuth.instance.currentUser;
  var uuid = const Uuid();

  Therapist? _bookedTherapist;
  Therapist? get bookedTherapist => _bookedTherapist;

  List<Therapist> _therapyList = [];

  List<Therapist> get therapyList => _therapyList;

  //function to initialize open slots when therapist signs up
  Future<void> addInitialSlots(String therapistid) async {
    final daysOfWeek = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday'
    ];
    final startTimes = ['09AM', '10AM', '11AM'];
    final endTimes = ['10AM', '11AM', '12PM'];
    for (final dayOfWeek in daysOfWeek) {
      final slots = {};
      for (int i = 0; i < startTimes.length; i++) {
        final startTime = startTimes[i];
        final endTime = endTimes[i];
        final slotId = 'slot${i + 1}';
        var v1 = uuid.v1();
        slots[slotId] = {
          'start_time': startTime,
          'end_time': endTime,
          'patient_id': '',
          'slotid': v1
        };
      }
      final url = Uri.parse(
          'https://rafiki-42373-default-rtdb.firebaseio.com/Slots/$therapistid/$dayOfWeek.json');
      final response = await http.put(
        url,
        body: json.encode(slots),
      );
      if (response.statusCode >= 400) {
        throw Exception('Failed to add initial slots for $dayOfWeek.');
      }
    }
    notifyListeners();
  }

// upload therapist data apart from the initial login data
  Future<void> uploadTherapsitData(dynamic therapist, BuildContext ctx) async {
    final data = json.encode(therapist);
    try {
      final response = await http.post(
          Uri.parse(
              'https://rafiki-42373-default-rtdb.firebaseio.com/Therapists/${user!.uid}.json'),
          body: data);

      if (response.statusCode == 200) {
        await addInitialSlots(user!.uid);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          ctx,
          MaterialPageRoute(builder: (context) => const TherapistHomeScreen()),
        );
      }
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

// fetch therapist data to be used where neccessat
  Future<void> fetchTherapyData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://rafiki-42373-default-rtdb.firebaseio.com/Therapists.json'));

      final data = json.decode(response.body) as Map<String, dynamic>;

      List<Therapist> therapyList = [];

      data.forEach((key, value) {
        value.forEach((i, val) {
          therapyList.add(Therapist(
              description: val['description'] ?? '',
              specialties: val['specialties'] ?? '',
              id: key,
              name: val['name'] ?? '',
              phone: val['phone'] ?? '',
              county: val['county'] ?? '',
              rating: val['rating'].toString(),
              gender: val['gender'] ?? '',
              price: val['price'].toString()));
        });
        _therapyList = therapyList;
        notifyListeners();
      });
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
    final id = user!.uid;
    try {
      final response = await http.get(Uri.parse(
          'https://rafiki-42373-default-rtdb.firebaseio.com/BookedTherapists/$id.json'));
      final data = json.decode(response.body);
      if (data != null) {
        // User already has a therapist
        errortoast('Cannot have more than one therapist');
      } else if (data == null) {
        // User has no therapist, so add the new therapist to the endpoint
        final response = await http.put(
            Uri.parse(
                'https://rafiki-42373-default-rtdb.firebaseio.com/BookedTherapists/$id.json'),
            body: json.encode({
              'description': therapist.description,
              'specialties': therapist.specialties,
              'id': therapist.id,
              'name': therapist.name,
              'phone': therapist.phone,
              'county': therapist.county,
              'rating': therapist.rating,
              'gender': therapist.gender,
              'price': therapist.price,
              'sessions': '0',
              'date': DateTime.now().toString(),
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
          'https://rafiki-42373-default-rtdb.firebaseio.com/BookedTherapists/$userId.json'));
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
