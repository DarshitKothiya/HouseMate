import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 5), () {
      Navigator.pushNamed(context, 'intro_screen');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 70),
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage('assets/image/app_logo.png'),
                  fit: BoxFit.cover
                )
              ),
            ),
            const SizedBox(height: 25),
            Text('House MATE', style: GoogleFonts.rasa(fontSize: 40,color: Colors.white),),
            const SizedBox(height: 220,),
            const CircularProgressIndicator(
              backgroundColor: Colors.grey,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
