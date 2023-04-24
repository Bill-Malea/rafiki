import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rafiki/screens/Patient/Homescreen.dart';
import '../models/PatientsModel.dart';
import '../utilities/utility.dart';

class UserProvider extends ChangeNotifier {
  final id = FirebaseAuth.instance.currentUser!.uid;
// upload therapist data apart from the initial login data
  List<Patient> _patients = [];
  List<Patient> get patients => [..._patients];
  late bool _haspatientdata;
  bool get haspatientdata => _haspatientdata;

  Future<void> uploadPatientData(dynamic user, BuildContext ctx) async {
    final data = json.encode(user);
    try {
      final response = await http.post(
          Uri.parse(
              'https://rafiki-42373-default-rtdb.firebaseio.com/Patients/$id.json'),
          body: data);

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          ctx,
          MaterialPageRoute(builder: (context) => const Homescreen()),
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

  Future<bool> hasPatientData(String patientid) async {
    final response = await http.get(Uri.parse(
        'https://rafiki-42373-default-rtdb.firebaseio.com/Patients/$id.json'));
    final data = json.decode(response.body);
    _haspatientdata = data != null;
    notifyListeners();

    return data != null;
  }

  Future<void> fetchpatients() async {
    final response = await http.get(Uri.parse(
        'https://rafiki-42373-default-rtdb.firebaseio.com/Patients.json'));
    final rawdata = json.decode(response.body);
    if (response.statusCode == 200) {
      var data = rawdata as Map<String, dynamic>;

      List<Patient> rawpatientlist = [];
      data.forEach((key, value) {
        var val = value as Map<String, dynamic>;
        for (var element in val.values) {
          rawpatientlist.add(Patient(
            userid: element['UserId'] ?? '',
            county: element['county'] ?? '',
            gender: element['gender'] ?? '',
            name: element['name'] ?? '',
            yob: element['yearofbith'] ?? '',
            phone: element['phone'] ?? '',
          ));
        }
      });

      _patients = rawpatientlist;
      notifyListeners();
    }

    return;
  }
}
