import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../Providers/SlotsProvider.dart';
import '../../../Providers/UserProvider.dart';
import '../../../models/PatientsModel.dart';
import '../../../models/Slotsmodel.dart';

class Appointment extends StatefulWidget {
  const Appointment({super.key});

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  @override
  Widget build(BuildContext context) {
    final day = DateFormat('EEEE').format(DateTime.now());
    var patientsids = Provider.of<SlotProvider>(context).mypatientsid;
    var patients = Provider.of<UserProvider>(context).patients;
    var subslots = Provider.of<SlotProvider>(context).subslots;
    List<Patient> getmypatients() {
      List<Patient> result = [];
      if (patientsids.isNotEmpty && patientsids.isNotEmpty) {
        for (var patientid in patientsids) {
          final patient =
              patients.firstWhere((element) => element.userid == patientid);
          result.add(patient);
        }
      }
      var distinctIds = result.toSet().toList().isEmpty
          ? <Patient>[]
          : result.toSet().toList();
      return distinctIds;
    }

    Slots? getslot(String id) {
      var slot = subslots.where((element) =>
          element.patientId == id &&
          element.dayOfWeek.toLowerCase() == day.toLowerCase());
      return slot.isEmpty ? null : slot.first;
    }

    List<AppointmentModel> appointments() {
      List<AppointmentModel> apps = [];
      var myppat = getmypatients();
      for (var element in myppat) {
        var patientslot = getslot(element.userid);
        if (patientslot != null) {
          apps.add(AppointmentModel(
            name: element.name,
            patientid: element.userid,
            phone: element.phone,
            starttime: patientslot.startTime,
            endtime: patientslot.endTime,
            gender: element.gender,
          ));
        }
      }
      return apps;
    }

    List<AppointmentModel> patientlist = appointments();
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Todays AppointMents',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          const SizedBox(
            height: 10,
          ),
          patientlist.isEmpty
              ? const Center(child: Text('No Appointments Today'))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: patientlist.length,
                  itemBuilder: (context, index) {
                    var patient = patientlist[index];
                    return Column(
                      children: [
                        Container(
                            padding: const EdgeInsets.all(2),
                            child: ListTile(
                              leading: const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.person_pin_circle_rounded,
                                    color: Colors.black,
                                    size: 25,
                                  )),
                              title: Text(patient.name),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(patient.phone),
                                      Text(patient.gender),
                                      Container(
                                        width: 70,
                                        height: 30,
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(3)),
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(
                                                Icons.phone,
                                                color: Colors.white,
                                                size: 11,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'Call',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        'Time',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        height: 70,
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(3)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              patient.starttime,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            const Text(
                                              '-',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              patient.endtime,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                        const Divider(
                          thickness: 1,
                        )
                      ],
                    );
                  },
                )
        ],
      ),
    );
  }
}

class AppointmentModel {
  final String name;
  final String patientid;
  final String phone;
  final String starttime;
  final String endtime;
  final String gender;

  AppointmentModel(
      {required this.name,
      required this.patientid,
      required this.phone,
      required this.starttime,
      required this.endtime,
      required this.gender});
}
