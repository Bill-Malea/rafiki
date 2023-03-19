import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../Providers/TherapyProvider.dart';
import '../../../models/TherapistModel.dart';
import 'BookedTherapist.dart';
import 'TherapistDetails.dart';

class Therapy extends StatefulWidget {
  const Therapy({Key? key}) : super(key: key);

  @override
  State<Therapy> createState() => _TherapyState();
}

class _TherapyState extends State<Therapy> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    Provider.of<TherapyProvider>(context, listen: false).fetchUserTherapist();
  }

  @override
  Widget build(BuildContext context) {
    Therapist? bookedTherapist =
        Provider.of<TherapyProvider>(context).bookedTherapist;

    return Column(
      children: [
        bookedTherapist != null
            ? BookedTherapist(therapist: bookedTherapist)
            : Consumer<TherapyProvider>(
                builder: (context, therapyProvider, _) {
                  final therapyList = therapyProvider.therapyList;
                  if (therapyList.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: therapyList.length,
                      itemBuilder: (context, index) {
                        final therapy = therapyList[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TherapistDetails(
                                        therapist: therapy,
                                      )),
                            );
                          },
                          child: ListTile(
                            leading: const CircleAvatar(),
                            title: Text(therapy.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(therapy.phone),
                                RatingBarIndicator(
                                  rating:
                                      double.tryParse(therapy.rating) ?? (0.0),
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 12.0,
                                  direction: Axis.horizontal,
                                ),
                                Text(therapy.county),
                                Text(therapy.price),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
      ],
    );
  }
}
