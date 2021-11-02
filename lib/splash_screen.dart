import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/constants.dart';
import '/screen/auth/register_info_screen.dart';
import 'screen/dashboard/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = 'splash_screen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    var user = FirebaseAuth.instance.currentUser;

    Timer(
      const Duration(seconds: 1),
      () => Navigator.pushReplacementNamed(
          context,
          user != null
              ? DashboardScreen.routeName
              : RegisterInfoScreen.routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset('assets/logo/psycho_logo.png', height: 88, width: 88),
              const Spacer(),
              const Text(
                kDepartmentName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
              const SizedBox(height: 4),
              const Text(kUniversityName,
                  style: TextStyle(
                    fontSize: 14,
                  )),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
