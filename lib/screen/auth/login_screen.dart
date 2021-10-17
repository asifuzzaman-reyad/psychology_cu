import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/screen/auth/register_info_screen.dart';
import '/screen/dashboard/dashboard_screen.dart';
import '/widgets/loading.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailField = TextEditingController();
  final TextEditingController _passwordField = TextEditingController();

  bool _isObscure = true;
  var regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: loading
            ? const Loading()
            : Container(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),

                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Login to get started',
                          style: TextStyle(fontSize: 16),
                        ),

                        const SizedBox(height: 32),

                        //email
                        TextFormField(
                          controller: _emailField,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter your email';
                            } else if (!regExp.hasMatch(val)) {
                              return 'Enter valid email';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 16),

                        //password
                        TextFormField(
                          controller: _passwordField,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter your password';
                            } else if (val.length < 8) {
                              return 'Password at least 8 character';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: GestureDetector(
                                onTap: () =>
                                    setState(() => _isObscure = !_isObscure),
                                child: _isObscure == true
                                    ? const Icon(Icons.visibility)
                                    : const Icon(
                                        Icons.visibility_off_outlined)),
                          ),
                          obscureText: _isObscure,
                          keyboardType: TextInputType.text,
                        ),

                        const SizedBox(height: 32),

                        //button
                        SizedBox(
                          width: double.infinity,
                          child: MaterialButton(
                            onPressed: () {
                              //
                              if (_formKey.currentState!.validate()) {
                                setState(() => loading = true);

                                //
                                login(_emailField.text, _passwordField.text);
                              }
                            },
                            child: const Text('Login'),
                            color: Colors.black87,
                            textColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account?'),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterInfoScreen()));
                                },
                                child: const Text('Sign Up',
                                    style: TextStyle(color: Colors.blue))),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  // user login
  login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      //
      var user = userCredential.user;
      print(user);
      if (user != null) {
        setState(() => loading = false);
        Fluttertoast.showToast(msg: 'Login Successful');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => DashboardScreen()));
      } else {
        setState(() => loading = false);
        print('No user found');
        Fluttertoast.showToast(msg: 'login failed: No user found');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() => loading = false);
        Fluttertoast.showToast(msg: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        setState(() => loading = false);
        Fluttertoast.showToast(msg: 'Wrong password provided for that user.');
      }
    } catch (e) {
      setState(() => loading = false);
      Fluttertoast.showToast(msg: 'Some thing wrong.');
      print(e);
    }
  }
}
