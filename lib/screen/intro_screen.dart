import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroScreenPage extends StatefulWidget {
  const IntroScreenPage({Key? key}) : super(key: key);

  @override
  State<IntroScreenPage> createState() => _IntroScreenPageState();
}

class _IntroScreenPageState extends State<IntroScreenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 140),
            Image.asset('assets/image/home-services.png'),
            const Spacer(),
            Container(
              height: 250,
              alignment: Alignment.center,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(150, 80),
                  topRight: Radius.elliptical(150, 80),
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Best Solution \nFor Your Home',textAlign: TextAlign.center, style: GoogleFonts.habibi(fontSize: 27,),),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, 'signUp_page');
                    },
                    child: Container(
                      height: 55,
                      width: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xff2f4550)
                      ),
                      alignment: Alignment.center,
                      child: Text('Start', style: GoogleFonts.balooBhai2(fontSize: 22,color: Colors.white),),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
