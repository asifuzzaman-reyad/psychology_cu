import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screen/auth/login_screen.dart';
import 'screen/dashboard/dashboard_screen.dart';


class SplashScreen extends StatefulWidget {
  static const routeName = 'splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    var user = FirebaseAuth.instance.currentUser;

    Timer(
      Duration(seconds: 1),
      () => Navigator.pushReplacementNamed(context,
          user != null ? DashboardScreen.routeName : LoginScreen.routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlutterLogo(
                size: 48,
              ),
              SizedBox(height: 32),
              CupertinoActivityIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
