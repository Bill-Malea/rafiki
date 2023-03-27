class Slots {
  final String id;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final String patientId;

  Slots({
    required this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.patientId,
  });

  factory Slots.fromJson(Map<String, dynamic> json) {
    return Slots(
      id: '',
      dayOfWeek: json['dayOfWeek'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      patientId: json['patient_id'] ?? '',
    );
  }
}

class Slot {
  final String id;
  final String dayOfWeek;
  List<Slots> slots;

  Slot({
    required this.id,
    required this.dayOfWeek,
    required this.slots,
  });
}
