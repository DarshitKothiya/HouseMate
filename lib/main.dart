import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:housemate/screen/admin-panel/AdminHome.dart';
import 'package:housemate/screen/intro_screen.dart';
import 'package:housemate/screen/signInPage.dart';
import 'package:housemate/screen/signUpPage.dart';
import 'package:housemate/screen/splashscreen.dart';
import 'package:housemate/screen/user-panel/AboutUs.dart';
import 'package:housemate/screen/user-panel/Contactus.dart';
import 'package:housemate/screen/user-panel/Employee.dart';
import 'package:housemate/screen/user-panel/homepage.dart';
import 'package:housemate/screen/user-panel/userDetail.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      initialRoute: 'splash_screen',
      routes: {
        '/' : (context) => const Homepage(),
        'splash_screen' : (context) => const SplashScreenPage(),
        'intro_screen' : (context) => const IntroScreenPage(),
        'signUp_page' : (context) => const SignUpPage(),
        'signIn_page' : (context) => const SignInPage(),
        'userDetail_page' : (context) => const UserDetail(),
        'admin_homepage' : (context) => const AdminHomepage(),
        'employee_page' : (context) => const EmployeePage(),
        'contactUs_page' : (context) => const ContactUsPage(),
        'aboutUs_page' : (context) => const AboutUsPage(),
      },
    ),
  );
}