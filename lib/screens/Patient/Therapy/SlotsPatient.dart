import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:rafiki/Providers/SlotsProvider.dart';

import '../../../models/Slotsmodel.dart';

class PatientSlots extends StatefulWidget {
  final List<Slot> slot;
  final String therapistid;
  const PatientSlots(
      {super.key, required this.slot, required this.therapistid});

  @override
  State<PatientSlots> createState() => _PatientSlotsState();
}

class _PatientSlotsState extends State<PatientSlots> {
  final box = GetStorage();

  final user = FirebaseAuth.instance.currentUser!.uid;
  var isloading = true;
  late BuildContext bookingDialog;
  void showBookingDialog(BuildContext context, String weekday, String patientId,
      Slots slot, String therapistid) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        bookingDialog = ctx;
        return AlertDialog(
          content: Row(
            children: const <Widget>[
              CircularProgressIndicator(
                strokeWidth: 1,
              ),
              SizedBox(width: 20),
              Text("Booking slot..."),
            ],
          ),
        );
      },
    );

    Provider.of<SlotProvider>(context, listen: false)
        .bookSlot(weekday, patientId, therapistid, slot)
        .then((bookingSuccessful) async {
      Provider.of<SlotProvider>(context, listen: false).fetchSlots(user);
      Navigator.pop(bookingDialog);
      showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            content: Text(
                bookingSuccessful ? "Booking successful!" : "Booking failed."),
            actions: <Widget>[
              TextButton(
                child: const Text("Ok"),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final usertype = box.read('user');
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: widget.slot.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 80,
                  child: Row(
                    children: [
                      SizedBox(
                          width: 65, child: Text(widget.slot[index].dayOfWeek)),
                      SizedBox(
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.slot[index].slots.length,
                          itemBuilder: (BuildContext ctx, int i) {
                            var slot = widget.slot[index].slots[i];

                            return InkWell(
                              onTap: slot.patientId.isEmpty
                                  ? () {
                                      if (usertype.toString().toLowerCase() ==
                                          'patient') {
                                        showBookingDialog(
                                          ctx,
                                          widget.slot[index].dayOfWeek,
                                          user,
                                          slot,
                                          widget.therapistid,
                                        );
                                      }
                                    }
                                  : null,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                margin: const EdgeInsets.only(
                                  right: 5,
                                  bottom: 15,
                                  left: 5,
                                ),
                                height: 80,
                                decoration: BoxDecoration(
                                  color: slot.patientId.isEmpty
                                      ? Colors.white
                                      : Colors.black,
                                  border: Border.all(color: Colors.black),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(3)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 1,
                                    ),
                                    Text(
                                      slot.startTime,
                                      style: TextStyle(
                                        color: slot.patientId.isEmpty
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 1,
                                    ),
                                    Text(
                                      '-',
                                      style: TextStyle(
                                        color: slot.patientId.isEmpty
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                    Text(
                                      slot.endTime,
                                      style: TextStyle(
                                        color: slot.patientId.isEmpty
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                );
              }),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
