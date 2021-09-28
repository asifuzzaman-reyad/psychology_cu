import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psychology_cu/constants.dart';
import 'package:psychology_cu/screen/auth/register_info_screen.dart';

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
      Duration(seconds: 2),
      () => Navigator.pushReplacementNamed(context,
          user != null ? DashboardScreen.routeName : RegisterInfoScreen.routeName),
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
              Spacer(),
              Image.asset('assets/logo/psycho_logo.png', height: 88, width: 88),
              Spacer(),
              Text(
                kDepartmentName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
              SizedBox(height: 4),
              Text(kUniversityName,
                  style: TextStyle(
                    fontSize: 14,
                  )),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
