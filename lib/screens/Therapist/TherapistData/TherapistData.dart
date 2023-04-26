import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:rafiki/Providers/TherapyProvider.dart';

class TherapistData extends StatefulWidget {
  const TherapistData({super.key});

  @override
  State<TherapistData> createState() => _TherapistDataState();
}

class _TherapistDataState extends State<TherapistData> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    var name = '';
    var gender = '';
    var phone = '';
    var specialties = '';
    var county = '';
    var description = '';
    var maxPatientsPerDay = 0;

    void trySubmit() {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        setState(() {
          _isloading = true;
        });

        var data = {
          'TherapistId': uid,
          'name': name,
          'gender': gender,
          'phone': phone,
          'specialties': specialties,
          'county': county,
          'description': description,
          'maxPatientsPerDay': maxPatientsPerDay,
          'rating': 0,
        };

        Provider.of<TherapyProvider>(context, listen: false)
            .uploadTherapsitData(data, context)
            .whenComplete(() {
          setState(() {
            _isloading = false;
          });
        });
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Container(
                  padding:
                      const EdgeInsets.only(top: 54.0, left: 20.0, right: 30.0),
                  child: Column(
                    children: <Widget>[
                      FormInputWidget(
                        false,
                        labelText: 'Name',
                        icon: Icons.person,
                        hintText: 'Enter your name',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          name = value;
                          if (kDebugMode) {
                            print(name);
                          }
                        },
                      ),
                      FormInputWidget(
                        false,
                        labelText: 'Gender',
                        icon: Icons.male,
                        hintText: 'Enter your Gender',
                        validator: (value) {
                          if (value!.toString().toLowerCase() != 'male' ||
                              value!.toString().toLowerCase() != 'female') {
                            return 'Gender can only be Male or Female';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          gender = value;
                        },
                      ),
                      FormInputWidget(
                        false,
                        labelText: 'Phone',
                        icon: Icons.call,
                        hintText: 'Enter your PhoneNumber',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a Phonenumber';
                          } else if (value.toString().length != 10) {
                            return 'A valid phone number should have atleast 10 digits';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          phone = value;
                        },
                      ),
                      FormInputWidget(
                        false,
                        labelText: 'Specialities',
                        icon: Icons.medical_services,
                        hintText: 'Enter your Specialities',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          specialties = value;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      FormInputWidget(
                        false,
                        labelText: 'county',
                        icon: Icons.location_on,
                        hintText: 'Enter your County',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your County of Residence';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          county = value;
                        },
                      ),
                      FormInputWidget(
                        false,
                        labelText: 'Patients Per Day',
                        icon: Icons.people,
                        hintText: 'Enter your Maximum Patients Per Day',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Maximum Patients per day';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          description = value;
                        },
                      ),
                      FormInputWidget(
                        true,
                        labelText: 'description',
                        icon: Icons.receipt,
                        hintText: 'Enter your Professional Description',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Description';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          description = value;
                        },
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      _isloading
                          ? const CircularProgressIndicator(
                              strokeWidth: 1.0,
                            )
                          : SizedBox(
                              height: 40.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(5.0),
                                shadowColor: Colors.black,
                                color: Colors.black,
                                elevation: 10.0,
                                child: TextButton(
                                  onPressed: trySubmit,
                                  child: const Center(
                                    child: Text(
                                      "Upload Details",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class FormInputWidget extends StatefulWidget {
  final String labelText;
  final IconData icon;
  final String hintText;
  final dynamic onChanged;
  final dynamic validator;
  final bool isdescrip;
  const FormInputWidget(
    this.isdescrip, {
    super.key,
    required this.onChanged,
    required this.labelText,
    required this.icon,
    required this.hintText,
    required this.validator,
  });

  @override
  State<FormInputWidget> createState() => _FormInputWidgetState();
}

class _FormInputWidgetState extends State<FormInputWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.isdescrip ? 8 : 1,
      decoration: InputDecoration(
        labelText: widget.labelText,
        icon: Icon(
          widget.icon,
          size: 16,
        ),
        hintText: widget.hintText,
      ),
      validator: widget.validator,
      onChanged: widget.onChanged,
    );
  }
}
