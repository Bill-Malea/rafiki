import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rafiki/screens/Patient/auth_screen.dart';
import 'package:rafiki/screens/Therapist/Auth/TherapistAuth.dart';

class SelectUser extends StatefulWidget {
  const SelectUser({super.key});

  @override
  State<SelectUser> createState() => _SelectUserState();
}

class _SelectUserState extends State<SelectUser> {
  final box = GetStorage();
  _setuser(String user) {
    box.write('user', user);
  }

  void _showAlertDialog(BuildContext context, String user) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text(
            'Select User',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          content: Text("Would you like to continue as $user ?"),
          actions: <Widget>[
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                _setuser(user);

                if (user.toLowerCase() == 'patient') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AuthScreen()));
                } else if (user.toLowerCase() == 'therapist') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TherapistAuth()));
                }
                Navigator.of(ctx).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select User',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    _showAlertDialog(context, 'therapist');
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, right: 10),
                    width: 80,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(child: Text('Therapist')),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _showAlertDialog(context, 'patient');
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, right: 10),
                    width: 80,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(child: Text('Patient')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
