import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:rafiki/Providers/SlotsProvider.dart';

class TherapistHome extends StatelessWidget {
  const TherapistHome({super.key});

  @override
  Widget build(BuildContext context) {
    var slots = Provider.of<SlotProvider>(context).slots;
    var subslots = Provider.of<SlotProvider>(context).subslots;
    int occupiedslot() {
      var occupiedSlots = [];

      for (var element in slots) {
        for (var slot in element.slots) {
          if (slot.patientId.isNotEmpty) {
            occupiedSlots.add(slot);
          }
        }
      }
      return occupiedSlots.length;
    }

    int availableslot() {
      var occupiedSlots = [];

      for (var element in slots) {
        for (var slot in element.slots) {
          if (slot.patientId.isEmpty) {
            occupiedSlots.add(slot);
          }
        }
      }

      return occupiedSlots.length;
    }

    final day = DateFormat('EEEE').format(DateTime.now());

    int todayslotslot() {
      var occupiedSlots = [];

      for (var element in slots) {
        for (var slot in element.slots) {
          if (slot.patientId.isNotEmpty &&
              slot.dayOfWeek.toLowerCase() == day.toLowerCase()) {
            occupiedSlots.add(slot);
          }
        }
      }
      return occupiedSlots.length;
    }

    Color progresscolor(int rating) {
      if (rating < 50 && rating > 0) {
        return Colors.red;
      } else if (rating < 70 && rating > 50) {
        return Colors.amber;
      }
      return Colors.green;
    }

    var rating = (availableslot().isNaN
                ? 0
                : availableslot() / subslots.length * 100)
            .isNaN
        ? 0
        : (availableslot().isNaN ? 0 : availableslot() / subslots.length * 100)
            .floor();
    var occslot = occupiedslot().isNaN ||
            occupiedslot().isFinite ||
            occupiedslot().isInfinite
        ? 0
        : occupiedslot();

    var occupedprogcolor = progresscolor(occslot);
    var occupiedpercenttxt = occupiedslot().toString();
    var occupiedpercent = (occupiedslot() / slots.length);

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Appointments',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Container(
                width: 100,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const Text(
                      'Today',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CircularPercentIndicator(
                      radius: 30.0,
                      lineWidth: 5.0,
                      percent: (todayslotslot() / subslots.length),
                      center: Text(todayslotslot().toString()),
                      progressColor: Colors.black,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                width: 100,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const Text(
                      'This Week',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CircularPercentIndicator(
                      radius: 30.0,
                      lineWidth: 5.0,
                      percent: (occupiedslot() / slots.length),
                      center: Text(occupiedslot().toString()),
                      progressColor: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Patients Progress',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Container(
                width: 100,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const Text(
                      'Better',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CircularPercentIndicator(
                      radius: 30.0,
                      lineWidth: 5.0,
                      percent: 0.30,
                      center: const Text("12"),
                      progressColor: Colors.green,
                    ),
                  ],
                ),
              ),
              Container(
                width: 100,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const Text(
                      'Neutral',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CircularPercentIndicator(
                      radius: 30.0,
                      lineWidth: 5.0,
                      percent: 0.30,
                      center: const Text("12"),
                      progressColor: progresscolor(50),
                    ),
                  ],
                ),
              ),
              Container(
                width: 100,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const Text(
                      'Critical ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CircularPercentIndicator(
                      radius: 30.0,
                      lineWidth: 5.0,
                      percent: 0.30,
                      center: const Text("12"),
                      progressColor: Colors.redAccent,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            'Sessions Slots',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Container(
                width: 100,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const Text(
                      'Availabe',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CircularPercentIndicator(
                      radius: 30.0,
                      lineWidth: 5.0,
                      percent: (availableslot() / subslots.length),
                      center: Text(availableslot().toString()),
                      progressColor: progresscolor(rating),
                    ),
                  ],
                ),
              ),
              Container(
                width: 100,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const Text(
                      'Occupied',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CircularPercentIndicator(
                      radius: 30.0,
                      lineWidth: 5.0,
                      percent: occupiedpercent,
                      center: Text(occupiedpercenttxt),
                      progressColor: occupedprogcolor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
