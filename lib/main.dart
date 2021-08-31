import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psychology_cu/screen/teacher/teacher_details_screen.dart';
import 'package:psychology_cu/screen/teacher/upload_teacher_information.dart';

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
import '../screen/teacher/teacher_screen.dart';
import 'splash_screen.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.black,
        fontFamily: 'Lato',
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.white,
        fontFamily: 'Lato',
      ),

      initialRoute: SplashScreen.routeName,
      routes: {

        //
        SplashScreen.routeName : (context) => SplashScreen(),
        DashboardScreen.routeName : (context) => DashboardScreen(),
        LoginScreen.routeName : (context) => LoginScreen(),
        RegisterInfoScreen.routeName : (context) => RegisterInfoScreen(),
        RegisterScreen.routeName : (context) => RegisterScreen(),
        ProfileScreen.routeName : (context) => ProfileScreen(),

        //
        HomeScreen.routeName: (context) => HomeScreen(),

        TeacherScreen.routeName: (context) => TeacherScreen(),
        TeacherDetailsScreen.routeName: (context) => TeacherDetailsScreen(),
        UploadTeacherInformation.routeName : (context) => UploadTeacherInformation(),

        StudentScreen.routeName: (context) => StudentScreen(),
        OfficeScreen.routeName: (context) => OfficeScreen(),
        CommunityScreen.routeName: (context) => CommunityScreen(),

        //
        StudyScreen.routeName: (context) => StudyScreen(),
        
      },
    );
  }
}





