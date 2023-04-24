import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:rafiki/Providers/SlotsProvider.dart';
import 'package:rafiki/Providers/TherapyProvider.dart';
import 'package:rafiki/screens/Patient/Therapy/SlotsPatient.dart';

class Slots extends StatefulWidget {
  const Slots({super.key});

  @override
  State<Slots> createState() => _SlotsState();
}

class _SlotsState extends State<Slots> {
  final user = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    var slots = Provider.of<SlotProvider>(context).slots;
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          PatientSlots(slot: slots, therapistid: user),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              Provider.of<TherapyProvider>(context, listen: false)
                  .addInitialSlots(user);
            },
            child: Container(
              width: 100,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(3)),
              ),
              child: const Center(
                child: Text(
                  'Add Slot',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
