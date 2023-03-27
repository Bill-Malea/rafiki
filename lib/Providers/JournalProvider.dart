import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../utilities/utility.dart';

class JournalProvider extends ChangeNotifier {
  final patientid = FirebaseAuth.instance.currentUser!.uid;

  bool _journalUploaded = false;

  bool get journalUploaded => _journalUploaded;

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String date() {
    final now = DateTime.now();
    final year = now.year.toString();
    final month = now.month.toString();
    final day = now.day.toString();
    if (kDebugMode) {
      print(year + month + day);
    }
    return year + month + day;
  }

  Future<void> journalExists() async {
    _isLoading = true;
    notifyListeners();
    var todaydate = date();
    try {
      final getResponse = await http.get(Uri.parse(
          'https://rafiki-511ac-default-rtdb.firebaseio.com/Journals/$patientid/$todaydate.json'));

      var data = json.decode(getResponse.body);

      if (getResponse.statusCode == 200 && data != null) {
        _isLoading = false;
        _journalUploaded = true;
      } else {
        _isLoading = false;
        _journalUploaded = false;
      }

      notifyListeners();
    } on SocketException {
      _isLoading = true;

      notifyListeners();
    } catch (e) {}
  }

  Future<void> uploadjournal(String patientid, dynamic journal) async {
    _isLoading = true;
    notifyListeners();
    try {
      var todaydate = date();
      final postResponse = await http.put(
          Uri.parse(
              'https://rafiki-511ac-default-rtdb.firebaseio.com/Journals/$patientid/$todaydate .json'),
          body: jsonEncode(journal));
      final postData = json.decode(postResponse.body);

      if (postResponse.statusCode == 200) {
        _isLoading = false;
        _journalUploaded = true;
      }

      notifyListeners();
    } on SocketException {
      errortoast('Check Your Internet Connection and Try Again');
      _isLoading = true;
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }
}

class Journal {
  final String id;
  final String date;
  final String rating;

  Journal({required this.id, required this.date, required this.rating});
}
