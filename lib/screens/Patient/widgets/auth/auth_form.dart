import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../ForgotpasswordPage.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitFn, this.isLoading, {Key? key}) : super(key: key);

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String userName,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(_userEmail.trim(), _userPassword.trim(), _userName.trim(),
          _isLogin, context);
    }
  }

  bool isemailvalid(String email) {
    bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
        .hasMatch(email);
    return emailValid;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      padding: const EdgeInsets.only(
        top: 35,
        left: 25,
      ),
      child: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(15.0, 50.0, 0.0, 0.0),
                    child: const Text('Hi',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 80.0,
                            fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(15.0, 125.0, 0.0, 0.0),
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 80.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          WavyAnimatedText("There"),
                          WavyAnimatedText('Again'),
                        ],
                        isRepeatingAnimation: false,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(235.0, 125.0, 0.0, 0.0),
                    child: const Text('.',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  )
                ],
              ),
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.only(
                          top: 54.0, left: 20.0, right: 30.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            key: const ValueKey('email'),
                            decoration: const InputDecoration(
                                labelText: 'EMAIL',
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
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
                          const SizedBox(height: 20.0),
                          TextFormField(
                            key: const ValueKey('password'),
                            decoration: const InputDecoration(
                              labelText: 'PASSWORD',
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                            ),
                            obscureText: true,

                            // ignore: missing_return
                            validator: (value) {
                              if (value!.isEmpty || value.length < 7) {
                                return 'Please enter a long password';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userPassword = value!;
                            },
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          if (widget.isLoading)
                            const CircularProgressIndicator(
                              strokeWidth: 1.0,
                            ),
                          if (!widget.isLoading)
                            SizedBox(
                              height: 40.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(5.0),
                                shadowColor: Colors.black,
                                color: Colors.black,
                                elevation: 10.0,
                                child: TextButton(
                                  onPressed: _trySubmit,
                                  child: Center(
                                    child: Text(
                                      _isLogin ? "Login" : "Sign up",
                                      style: const TextStyle(
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
                          if (!widget.isLoading)
                            SizedBox(
                              height: 40.0,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Center(
                                  child: Text(
                                    _isLogin
                                        ? "Create new account"
                                        : "I already have an account",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (_isLogin)
                            InkWell(
                              onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const ForgotPassword()));
                              },
                              child: const Center(
                                child: Text(
                                  'Forgot Password ?',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context)
                                      .viewInsets
                                      .bottom)),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
