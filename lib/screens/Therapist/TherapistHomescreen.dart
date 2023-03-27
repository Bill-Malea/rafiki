import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:rafiki/screens/Therapist/Screens/Appointment.dart';
import '../../Providers/BottomNavProvider.dart';
import '../../Providers/TherapyProvider.dart';
import 'BottomTherapist/BottomNavTherapist.dart';
import 'Screens/Patients.dart';
import 'Screens/Slots.dart';
import 'Screens/TherapistHome.dart';

class TherapistHomeScreen extends StatefulWidget {
  const TherapistHomeScreen({super.key});

  @override
  State<TherapistHomeScreen> createState() => _TherapistHomeScreenState();
}

class _TherapistHomeScreenState extends State<TherapistHomeScreen> {
  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();

    Provider.of<TherapyProvider>(context, listen: false).fetchTherapyData();
  }

  final List<Widget> _pages = <Widget>[
    const TherapistHome(),
    const Appointment(),
    const Patients(),
    const Slots(),
  ];
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    var selectedIndex = Provider.of<BottomNavProvider>(context).selectetab;

    setuser() {
      box.write('user', null);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Rafiki Doctor'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              auth.signOut();
              setuser();
            },
            child: Row(
              children: const [
                Text('Log Out'),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: _pages.elementAt(selectedIndex),
      ),
      bottomNavigationBar: const TherapistNav(),
    );
  }
}
