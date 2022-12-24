import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helper/firebaseAuthHelper.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? email;
  String? password;

  bool isPasswordShow = true;

  @override
  Widget build(BuildContext context) {
    double _Height = MediaQuery.of(context).size.height;
    double _Weight = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: _Height * 0.15,
            ),
            Text(
              'Create your Account',
              style: GoogleFonts.yaldevi(
                  fontSize: 38,
                  letterSpacing: 2,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: _Height * 0.07,
            ),
            TextField(
              style: GoogleFonts.balooBhai2(color: Colors.white, fontSize: 17),
              controller: emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white38,
                hintText: 'Email',
                hintStyle:
                    GoogleFonts.balooBhai2(color: Colors.white54, fontSize: 17),
                prefixIcon: const Icon(
                  CupertinoIcons.mail,
                  color: Colors.white,
                ),
                contentPadding: const EdgeInsets.only(left: 14.0, top: 8),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white24),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white10),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              style: GoogleFonts.balooBhai2(color: Colors.white, fontSize: 17),
              controller: passwordController,
              obscureText: isPasswordShow,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white38,
                hintText: 'Password',
                hintStyle:
                    GoogleFonts.balooBhai2(color: Colors.white54, fontSize: 17),
                prefixIcon: const Icon(
                  CupertinoIcons.lock_fill,
                  color: Colors.white,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isPasswordShow = !isPasswordShow;
                    });
                  },
                  icon: Icon(
                    (isPasswordShow) ?CupertinoIcons.eye_fill: CupertinoIcons.eye_slash_fill,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                contentPadding: const EdgeInsets.only(left: 14.0, top: 8),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white24),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white10),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () async{
                email = emailController.text;
                password = passwordController.text;

                User? user = await FirebaseAuthHelper.firebaseAuthHelper.signUpUser(email: email!, password: password!);

                if (user != null) {

                  Navigator.of(context).pushReplacementNamed('signIn_page');

                  emailController.clear();
                  passwordController.clear();
                  email = null;
                  password = null;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Signup Successfully...'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {

                  emailController.clear();
                  passwordController.clear();
                  email = null;
                  password = null;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('signup failed...'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Container(
                height: 50,
                width: _Weight*0.7,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xff7210ff),
                  borderRadius: BorderRadius.circular(35)
                ),
                child: Text('Sign Up', style: GoogleFonts.balooBhai2(fontSize: 18,color: Colors.white),),
              ),
            ),
            const SizedBox(height: 30,),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: [
               Container(height: 2,width: _Weight*0.3,color: Colors.white54,),
               Text('or Continue with', style: GoogleFonts.balooBhai2(fontSize: 15,color: Colors.white),),
               Container(height: 2,width: _Weight*0.3,color: Colors.white54,),
             ],
           ),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: () async{

                User? user = await FirebaseAuthHelper.firebaseAuthHelper.signInWithGoogle();

                if (user != null) {

                  Navigator.of(context).pushReplacementNamed('/');

                  emailController.clear();
                  passwordController.clear();
                  email = null;
                  password = null;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Signup Successfully...'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('signup failed...'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Container(
                height: 50,
                width: _Weight*0.8,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: const Color(0xff6f3abb),
                    borderRadius: BorderRadius.circular(35)
                ),
                child: Text('Google', style: GoogleFonts.balooBhai2(fontSize: 18,color: Colors.white),),
              ),
            ),
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already Have an Account?', style: GoogleFonts.balooBhai2(fontSize: 15,color: Colors.white70),),
                TextButton(onPressed: (){Navigator.pushReplacementNamed(context, 'signIn_page');}, child: Text('Sign In', style: GoogleFonts.balooBhai2(fontSize: 16,color: Colors.blue),),),
              ],
            )
          ],
        ),
      ),
    );
  }

}
