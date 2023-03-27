import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Appointment extends StatefulWidget {
  const Appointment({super.key});

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  @override
  Widget build(BuildContext context) {
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
          ListView.builder(
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (context, index) {
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
                        title: const Text('John Doe'),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('0727800223'),
                                const Text('Eldoret'),
                                const Text('Male'),
                                Container(
                                  width: 70,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
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
                                          style: TextStyle(color: Colors.white),
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
                                  width: 40,
                                  height: 70,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '10PM',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        '-',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        '12PM',
                                        style: TextStyle(color: Colors.white),
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
