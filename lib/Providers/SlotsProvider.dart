import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rafiki/utilities/utility.dart';

import '../models/SlotsModel.dart';

class SlotProvider extends ChangeNotifier {
  final user = FirebaseAuth.instance.currentUser;
  List<Slot> _slots = [];
  List<Slots> _subslots = [];
  List<Slots> get subslots => [..._subslots];

  List<Slot> get slots {
    return [..._slots];
  }

  Future<void> fetchSlots(String therapistid) async {
    final url = Uri.parse(
        'https://rafiki-511ac-default-rtdb.firebaseio.com/Slots/$therapistid.json');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body) ?? {} as Map<String, dynamic>;
      var newdata = <Slot>[];
      var slo = <Slots>[];
      data.forEach((key, value) {
        var rawdata = value as Map<String, dynamic>;
        var subslotsdata = <Slots>[];
        rawdata.forEach((slot, val) {
          var subsslot = Slots(
            id: slot,
            dayOfWeek: key,
            startTime: val['start_time'] ?? '',
            endTime: val['end_time'] ?? '',
            patientId: val['patient_id'],
          );
          subslotsdata.add(subsslot);
          slo.add(subsslot);
        });

        var slot = Slot(id: key, dayOfWeek: key, slots: subslotsdata);
        newdata.add(slot);
      });

      _subslots = slo;
      _slots = newdata;
      notifyListeners();
    } else {
      throw Exception('Failed to fetch slots.');
    }
  }

  Future<bool> bookSlot(
      String weekday, String patientId, String therapistid, Slots slots) async {
    final bookedSlots =
        await getBookedSlotsForPatientInWeek(patientId, weekday);

    if (bookedSlots >= 2) {
      errortoast('Cannot Book More Than Twom Slots in A week');
      return false;
    }
    var sessions = await updatebooknumbers(patientId);

    if (sessions == 200) {
      var id = slots.id;
      final url = Uri.parse(
          'https://rafiki-511ac-default-rtdb.firebaseio.com/Slots/$therapistid/$weekday/$id.json');
      final response = await http.patch(
        url,
        body: json.encode({'patient_id': patientId}),
      );

      if (response.statusCode >= 400) {
        return false;
      } else {
        await fetchSlots(therapistid);
        return true;
      }
    }

    return false;
  }

  Future<int> getBookedSlotsForPatientInWeek(
      String patientId, String weekday) async {
    final url = Uri.parse(
        'https://rafiki-511ac-default-rtdb.firebaseio.com/BookedTherapists/$patientId/sessions.json');
    final response = await http.get(url);

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return int.parse(data.toString().isEmpty || data == null ? '0' : data);
    }

    return 0;
  }

  Future<int> updatebooknumbers(
    String patientId,
  ) async {
    final url = Uri.parse(
        'https://rafiki-511ac-default-rtdb.firebaseio.com/BookedTherapists/$patientId/sessions.json');
    final url2 = Uri.parse(
        'https://rafiki-511ac-default-rtdb.firebaseio.com/BookedTherapists/$patientId.json');
    final response = await http.get(url);
    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final sesionupdate =
          (int.parse(data.toString().isEmpty || data == null ? '0' : data) + 1)
              .toString();
      final updateresponse =
          await http.patch(url2, body: json.encode({'sessions': sesionupdate}));

      return updateresponse.statusCode;
    }
    return 0;
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
