import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:psy_assistant/screen/welcome/welcome_screen.dart';

import '/screen/about/about_screen.dart';
import '/screen/auth/login_screen.dart';
import '/screen/auth/register_info_screen.dart';
import '/screen/auth/register_screen.dart';
import '/screen/dashboard/dashboard_screen.dart';
import '/screen/home/home_screen.dart';
import '/screen/office/office_screen.dart';
import '/screen/profile/profile_screen.dart';
import '/screen/student/student_screen.dart';
import '/screen/study/study_screen.dart';
import '/screen/teacher/teacher_details_screen.dart';
import '/screen/teacher/teacher_screen.dart';
import 'admob/ad_state.dart';
import 'splash_screen.dart';
import 'theme.dart';

void main() async {
  // initialize firebase
  WidgetsFlutterBinding.ensureInitialized();

  // init admob before flutter init
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);

  //firebase app init
  await Firebase.initializeApp();

  // downloader init
  await FlutterDownloader.initialize(debug: true);

  //status bar transparent
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  // force to stick portrait screen
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown,
  ]).then(
    (value) => runApp(
      // const MyApp(),
      Provider.value(
        value: adState,
        builder: (context, child) => const MyApp(),
      ),
    ),
  );
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
        WelcomeScreen.routeName: (context) => const WelcomeScreen(),

        DashboardScreen.routeName: (context) => const DashboardScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        RegisterInfoScreen.routeName: (context) => const RegisterInfoScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),

        // home
        HomeScreen.routeName: (context) => const HomeScreen(),

        TeacherScreen.routeName: (context) => TeacherScreen(),
        TeacherDetailsScreen.routeName: (context) =>
            const TeacherDetailsScreen(),

        StudentScreen.routeName: (context) => const StudentScreen(),
        OfficeScreen.routeName: (context) => OfficeScreen(),
        AboutScreen.routeName: (context) => const AboutScreen(),

        // study
        StudyScreen.routeName: (context) => const StudyScreen(),

        //profile
        ProfileScreen.routeName: (context) => const ProfileScreen(),
      },
    );
  }
}
