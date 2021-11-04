import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import '../screen/auth/login_screen.dart';
import '../screen/auth/register_info_screen.dart';
import '../screen/auth/register_screen.dart';
import '../screen/community/community_screen.dart';
import '../screen/dashboard/dashboard_screen.dart';
import '../screen/home/home_screen.dart';
import '../screen/office/office_screen.dart';
import '../screen/profile/profile_screen.dart';
import '../screen/student/student_screen.dart';
import '../screen/study/study_screen.dart';
import '../screen/teacher/teacher_details_screen.dart';
import '../screen/teacher/teacher_screen.dart';
import 'splash_screen.dart';
import 'theme.dart';

void main() async {
  //status bar transparent
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  // initialize firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(debug: true);

  // force to stick portrait screen
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Psy Assistant',
      debugShowCheckedModeBanner: false,
      // themeMode: ThemeMode.dark,
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
      initialRoute: SplashScreen.routeName,
      routes: {
        //
        SplashScreen.routeName: (context) => const SplashScreen(),
        DashboardScreen.routeName: (context) => const DashboardScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        RegisterInfoScreen.routeName: (context) => const RegisterInfoScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        ProfileScreen.routeName: (context) => const ProfileScreen(),

        //
        HomeScreen.routeName: (context) => const HomeScreen(),

        TeacherScreen.routeName: (context) => TeacherScreen(),
        TeacherDetailsScreen.routeName: (context) =>
            const TeacherDetailsScreen(),

        StudentScreen.routeName: (context) => StudentScreen(),
        OfficeScreen.routeName: (context) => OfficeScreen(),
        CommunityScreen.routeName: (context) => const CommunityScreen(),

        //
        StudyScreen.routeName: (context) => const StudyScreen(),
      },
    );
  }
}
