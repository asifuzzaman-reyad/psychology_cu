import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme.dart';
import 'splash_screen.dart';
import '../screen/teacher/teacher_details_screen.dart';
import '../screen/teacher/upload_teacher_information.dart';
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

void main() async {
  //status bar transparent
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  // initialize firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // force to stick portrait screen
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // themeMode: ThemeMode.dark,
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      initialRoute: SplashScreen.routeName,
      routes: {
        //
        SplashScreen.routeName: (context) => SplashScreen(),
        DashboardScreen.routeName: (context) => DashboardScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterInfoScreen.routeName: (context) => RegisterInfoScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        ProfileScreen.routeName: (context) => ProfileScreen(),

        //
        HomeScreen.routeName: (context) => HomeScreen(),

        TeacherScreen.routeName: (context) => TeacherScreen(),
        TeacherDetailsScreen.routeName: (context) => TeacherDetailsScreen(),
        UploadTeacherInformation.routeName: (context) =>
            UploadTeacherInformation(),

        StudentScreen.routeName: (context) => StudentScreen(),
        OfficeScreen.routeName: (context) => OfficeScreen(),
        CommunityScreen.routeName: (context) => CommunityScreen(),

        //
        StudyScreen.routeName: (context) => StudyScreen(),
      },
    );
  }
}
