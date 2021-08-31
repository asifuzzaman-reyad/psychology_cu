import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:psychology_cu/screen/auth/register_info_screen.dart';
import 'package:psychology_cu/screen/dashboard/dashboard_screen.dart';
import 'package:psychology_cu/widget/loading.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();

  bool _isObscure = true;
  var regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: loading ? Loading() : Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 32),

                  Text(
                    'Login'.toUpperCase(),
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 32),

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
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),

                  SizedBox(height: 16),

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
                      border: OutlineInputBorder(),
                      suffixIcon: GestureDetector(
                          onTap: () => setState(() => _isObscure = !_isObscure),
                          child: _isObscure == true
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off_outlined)),
                    ),
                    obscureText: _isObscure,
                    keyboardType: TextInputType.text,
                  ),

                  SizedBox(height: 32),

                  //button
                  Container(
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
                      child: Text('Login'),
                      color: Colors.black87,
                      textColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),

                  SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account?'),
                      TextButton(onPressed: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterInfoScreen()));
                      }, child: Text('Sign Up')),
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

        setState(() {
          loading = false;
          Fluttertoast.showToast(msg: 'Login Successful');
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DashboardScreen()));
        });

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
