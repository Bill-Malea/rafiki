import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rafiki/Providers/JournalProvider.dart';
import 'package:rafiki/Providers/SlotsProvider.dart';
import 'package:rafiki/Providers/TherapyProvider.dart';
import 'package:rafiki/Providers/UserProvider.dart';
import 'package:rafiki/SelectUser.dart';
import 'package:rafiki/screens/Patient/Homescreen.dart';
import 'package:rafiki/screens/Patient/splash_screen.dart';
import 'Providers/BottomNavProvider.dart';
import 'package:get_storage/get_storage.dart';

import 'screens/Therapist/TherapistHomescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();

  runApp(MultiProvider(
      key: ObjectKey(DateTime.now().toString()),
      providers: [
        ChangeNotifierProvider(
          create: (context) => BottomNavProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TherapyProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SlotProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => JournalProvider(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
      )));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final user = box.read('user');

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rafiki',
        theme: ThemeData(
            primaryColor: const Color(0xFFffcc00),
            textTheme: GoogleFonts.poppinsTextTheme(),
            buttonTheme: ButtonTheme.of(context).copyWith(
                buttonColor: Colors.pink,
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(background: Colors.white)
                .copyWith(secondary: Colors.black)
                .copyWith(primary: Colors.black)),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }
            if (userSnapshot.hasData &&
                user.toString().toLowerCase() == 'patient') {
              return const Homescreen();
            }

            if (!userSnapshot.hasData && user == null) {
              return const SelectUser();
            }
            if (userSnapshot.hasData && user != null) {
              return const SelectUser();
            }
            if (userSnapshot.hasData &&
                user.toString().toLowerCase() == 'therapist') {
              return const TherapistHomeScreen();
            }

            return const SelectUser();
          },
        ));
  }
}
