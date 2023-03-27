import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TherapistHome extends StatelessWidget {
  const TherapistHome({super.key});

  @override
  Widget build(BuildContext context) {
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
                      percent: 0.30,
                      center: const Text("3"),
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
                      percent: 0.30,
                      center: const Text("12"),
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
                      progressColor: Colors.amber,
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
                      percent: 0.30,
                      center: const Text("12"),
                      progressColor: Colors.amber,
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
                      'Pending',
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
                      progressColor: Colors.amber,
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
