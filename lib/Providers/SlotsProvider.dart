import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rafiki/models/TherapistModel.dart';

import '../models/SlotsModel.dart';

class SlotProvider extends ChangeNotifier {
  final user = FirebaseAuth.instance.currentUser;
  List<Slot> _slots = [];

  List<Slot> get slots {
    return [..._slots];
  }

  Future<void> fetchSlots(String therapistid) async {
    final url = Uri.parse(
        'https://rafiki-511ac-default-rtdb.firebaseio.com/Slots/$therapistid.json');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      var newdata = <Slot>[];
      data.forEach((key, value) {
        var subslotsdata = <Slots>[];
        value.values.toList().forEach((val) {
          var subsslot = Slots(
            id: val['slotid'] ?? '',
            dayOfWeek: key,
            startTime: val['start_time'] ?? '',
            endTime: val['end_time'] ?? '',
            patientId: val['patient_id'] ?? '',
          );
          subslotsdata.add(subsslot);
        });
        var slot = Slot(id: key, dayOfWeek: key, slots: subslotsdata);
        newdata.add(slot);
      });
      _slots = newdata;
      notifyListeners();
    } else {
      throw Exception('Failed to fetch slots.');
    }
  }

  Future<bool> bookSlot(String weekday, String patientId, String therapistid,
      String slotid) async {
    final url = Uri.parse(
        'https://rafiki-511ac-default-rtdb.firebaseio.com/Slots/$therapistid/$weekday/$slotid.json');
    final response = await http.patch(
      url,
      body: json.encode({'patientId': patientId}),
    );

    if (response.statusCode >= 400) {
      return false;
    } else {
      await fetchSlots(therapistid);
      return true;
    }
  }

  Future<void> addSlot(Slots slot, String therapistid, String weekday) async {
    final url = Uri.parse(
        'https://rafiki-511ac-default-rtdb.firebaseio.com/Slots/$therapistid/$weekday.json');
    final response = await http.put(
      url,
      body: json.encode({
        'startTime': slot.startTime,
        'endTime': slot.endTime,
        'patientId': null,
      }),
    );
    if (response.statusCode >= 400) {
      throw Exception('Failed to add slot.');
    }
    notifyListeners();
  }

  Future<void> addPatientToSlot(String slotId, String weekday, String patientId,
      String therapistId) async {
    final url = Uri.parse(
        'https://your-firebase-db-url.com/Slots/$therapistId/$weekday/$slotId.json');
    final response = await http.patch(
      url,
      body: json.encode({
        'patientId': patientId,
      }),
    );
    if (response.statusCode >= 400) {
      throw Exception('Failed to add patient to slot.');
    }

    notifyListeners();
  }
}

Future<void> removePatientFromSlot(String slotId) async {
  final url = Uri.parse('https://your-firebase-db-url.com/slots/$slotId.json');
  final response = await http.patch(
    url,
    body: json.encode({
      'patientId': "",
    }),
  );
  if (response.statusCode >= 400) {
    throw Exception('Failed to remove patient from slot.');
  }
}

Future<void> cancelSlot(String slotId) async {
  final url = Uri.parse(
      'https://rafiki-511ac-default-rtdb.firebaseio.com/Slots/$slotId.json');
  final response = await http.patch(
    url,
    body: json.encode({'patientId': null}),
  );
  if (response.statusCode >= 400) {
    throw Exception('Failed to cancel slot.');
  }
}
