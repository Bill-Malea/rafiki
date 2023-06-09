import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../models/JournalModel.dart';
import '../utilities/utility.dart';

class JournalProvider extends ChangeNotifier {
  final patientid = FirebaseAuth.instance.currentUser!.uid;
  List<Journal> _journal = [];
  List<Journal> get journals => _journal;
  double _patientaverage = 0.0;
  double get patientaverage => _patientaverage;
  bool _journalUploaded = false;

  bool get journalUploaded => _journalUploaded;

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String date() {
    final now = DateTime.now();
    final year = now.year.toString();
    final month = now.month.toString();
    final day = now.day.toString();

    return year + month + day;
  }

  Future<bool> journalExists() async {
    _isLoading = true;

    final todaydate = date().trim();
    try {
      var getResponse = await http.get(Uri.parse(
          'https://rafiki-42373-default-rtdb.firebaseio.com/Journals/$patientid/$todaydate.json'));

      final data = json.decode(getResponse.body);
      if (getResponse.statusCode == 200 && data != null) {
        var rawdata = [];
        var journalslist = data as Map;
        journalslist.forEach((key, val) {
          var json = {
            key: key,
            val: val,
          };
          rawdata.add(json);
        });

        if (journalslist.length < 3) {
          _isLoading = false;
          _journalUploaded = false;
          notifyListeners();
          return false;
        } else {
          _isLoading = false;
          _journalUploaded = true;
          notifyListeners();
          return true;
        }
      } else {
        _isLoading = false;

        notifyListeners();
        return false;
      }
    } on SocketException {
      _isLoading = true;

      notifyListeners();
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<void> fectchjournals(String id) async {
    try {
      var getResponse = await http.get(Uri.parse(
          'https://rafiki-42373-default-rtdb.firebaseio.com/Journals/$id.json'));

      final data = json.decode(getResponse.body);
      List<Journal> rawjournals = [];
      var sum = 0.0;
      var count = 0;
      if (getResponse.statusCode == 200 && data != null) {
        var journalslist = data as Map<String, dynamic>;

        journalslist.forEach((key, val) {
          var journaldata = val as Map<String, dynamic>;
          journaldata.forEach((id, value) {
            var rating = value['rating'];

            var mood = value['mood'];

            var journal = value['journal'];

            sum += rating;
            count++;
            rawjournals.add(Journal(
                userid: key,
                id: id.toString(),
                mood: mood.toString(),
                rating: rating.toString(),
                journal: journal.toString()));
          });
          var averageRating = count > 0 ? sum / count * 100 : 0;
          _patientaverage = averageRating.toDouble();
          notifyListeners();
        });
        _journal = rawjournals;
        notifyListeners();
      }
    } on SocketException {}
  }

  Future<void> uploadjournal(String patientid, dynamic journal) async {
    _isLoading = true;
    notifyListeners();
    try {
      var todaydate = date().trim();
      final postResponse = await http.post(
          Uri.parse(
              'https://rafiki-42373-default-rtdb.firebaseio.com/Journals/$patientid/$todaydate.json'),
          body: jsonEncode(journal));
      final postData = json.decode(postResponse.body);
      if (postResponse.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
      }
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
