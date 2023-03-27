import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:rafiki/Providers/SlotsProvider.dart';
import 'package:rafiki/Providers/TherapyProvider.dart';

class Slots extends StatefulWidget {
  const Slots({super.key});

  @override
  State<Slots> createState() => _SlotsState();
}

class _SlotsState extends State<Slots> {
  final user = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 80,
                  child: Row(
                    children: [
                      const Text('Monday'),
                      ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.only(
                              right: 10,
                              bottom: 15,
                              left: 5,
                            ),
                            width: 40,
                            height: 70,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                          );
                        },
                      )
                    ],
                  ),
                );
              }),
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
