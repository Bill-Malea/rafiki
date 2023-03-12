import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rafiki/screens/Homescreen.dart';
import 'Providers/BottomNavProvider.dart';
import 'screens/splash_screen.dart';
import '/screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MultiProvider(
      key: ObjectKey(DateTime.now().toString()),
      providers: [
        ChangeNotifierProvider(
          create: (context) => BottomNavProvider(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                .copyWith(primary: const Color(0xFFffcc00))),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }
            if (userSnapshot.hasData) {
              return const Homescreen();
            }
            return const AuthScreen();
          },
        ));
  }
}
