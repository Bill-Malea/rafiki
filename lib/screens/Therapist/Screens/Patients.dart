import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:rafiki/Providers/SlotsProvider.dart';
import 'package:rafiki/Providers/UserProvider.dart';
import 'package:rafiki/screens/Therapist/Screens/PatientsDetails.dart';

import '../../../models/PatientsModel.dart';

class Patients extends StatelessWidget {
  const Patients({super.key});

  @override
  Widget build(BuildContext context) {
    var patients = Provider.of<UserProvider>(context).patients;
    var patientsids = Provider.of<SlotProvider>(context).mypatientsid;
    List<Patient> getmypatients() {
      List<Patient> result = [];
      if (patientsids.isNotEmpty && patientsids.isNotEmpty) {
        for (var patientid in patientsids) {
          final patient =
              patients.firstWhere((element) => element.userid == patientid);
          result.add(patient);
        }
      }
      var distinctIds = result.toSet().toList();

      return distinctIds;
    }

    return Container(
      padding: const EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Patients',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            thickness: 1,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: getmypatients().length,
              itemBuilder: (context, index) {
                final patient = getmypatients()[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PatientDetails(patient: patient,)),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: ListTile(
                          leading: const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person_pin_circle_rounded,
                                color: Colors.black,
                                size: 25,
                              )),
                          title: Text(patients[index].name),
                          trailing: CircularPercentIndicator(
                            radius: 28.0,
                            lineWidth: 5.0,
                            percent: 0.30,
                            center: const Text(
                              "Critical",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            progressColor: Colors.amber,
                          ),
                        ),
                      ),
                      const Divider(
                        thickness: 1,
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
