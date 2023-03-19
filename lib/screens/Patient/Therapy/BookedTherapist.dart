import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiki/Providers/TherapyProvider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/TherapistModel.dart';

class BookedTherapist extends StatefulWidget {
  final Therapist therapist;

  const BookedTherapist({Key? key, required this.therapist}) : super(key: key);

  @override
  State<BookedTherapist> createState() => _BookedTherapistState();
}

class _BookedTherapistState extends State<BookedTherapist> {
  var _bookingsession = false;

  Future<void> _makePhoneCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: widget.therapist.phone,
    );
    await launchUrl(launchUri);
  }

  _booksession() {
    setState(() {
      _bookingsession = true;
    });
    Provider.of<TherapyProvider>(context, listen: false)
        .bookTherapist(
      widget.therapist,
    )
        .whenComplete(() {
      setState(() {
        _bookingsession = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircleAvatar(
                    radius: 80,
                    child: Image.asset(
                      'assets/images/male.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.amber,
                        child: Text(
                          widget.therapist.rating,
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.therapist.name,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Specialities',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    widget.therapist.specialties,
                    style: const TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 1.0),
                  Text(
                    widget.therapist.description,
                    style: const TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  !_bookingsession
                      ? InkWell(
                          onTap: () {
                            _booksession();
                          },
                          child: Container(
                            height: 40,
                            decoration:
                                const BoxDecoration(color: Colors.black),
                            child: const Center(
                              child: Text(
                                'Book Session',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                          strokeWidth: 1.0,
                        )),
                  const SizedBox(height: 20.0),
                  Container(
                    height: 40,
                    decoration: const BoxDecoration(color: Colors.black),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              _makePhoneCall();
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 5),
                              child: const Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Text(
                            'Call For Equiries',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
