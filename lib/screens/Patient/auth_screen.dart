import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rafiki/screens/Patient/Homescreen.dart';
import 'package:rafiki/screens/Patient/PatientData/PatientData.dart';

import 'widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    String userName,
    bool isLogin,
    BuildContext ctx,
  ) async {
    // ignore: unused_local_variable
    UserCredential userCredential;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userCredential = await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) {
          value.user!.uid.isNotEmpty
              ? Navigator.pushReplacement(
                  ctx,
                  MaterialPageRoute(builder: (context) => const Homescreen()),
                )
              : null;
          return value;
        });
      } else {
        userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) {
          value.user!.uid.isNotEmpty
              ? Navigator.pushReplacement(
                  ctx,
                  MaterialPageRoute(builder: (context) => const PatientData()),
                )
              : null;
          return value;
        });
      }
    } on PlatformException catch (err) {
      var message = "An error occured please check your credentails";

      if (err.message != null) {
        message = err.message!;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).colorScheme.error,
      ));

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      // ignore: avoid_print
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
