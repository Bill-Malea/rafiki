import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

var _userEmail = '';

class _ForgotPasswordState extends State<ForgotPassword> {
  final auth = FirebaseAuth.instance;
  var _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool isemailvalid(String email) {
    bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
        .hasMatch(email);
    return emailValid;
  }

  void forgotpwd(String email) async {
    setState(() {
      _isLoading = true;
    });
    await auth.sendPasswordResetEmail(email: email).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Password reset link has been sent to Your Email'),
        backgroundColor: Colors.green,
      ));
    });
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      forgotpwd(_userEmail.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/register.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
          body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _isLoading
              ? const CircularProgressIndicator(
                  strokeWidth: 1,
                )
              : Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                      child: Container(
                          padding: const EdgeInsets.only(
                              top: 54.0, left: 20.0, right: 30.0),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                key: const ValueKey('email'),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    labelText: 'EMAIL',
                                    labelStyle:
                                        const TextStyle(color: Colors.black),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    )),
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                enableSuggestions: false,
                                validator: (value) {
                                  if (!isemailvalid(value!)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _userEmail = value!;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 40.0,
                                child: Material(
                                  borderRadius: BorderRadius.circular(5.0),
                                  shadowColor: Colors.black,
                                  color: Colors.black,
                                  elevation: 10.0,
                                  child: TextButton(
                                    onPressed: _trySubmit,
                                    child: const Center(
                                      child: Text(
                                        "Reset Password",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )))),
        ],
      )),
    );
  }
}
