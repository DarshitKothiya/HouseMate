import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemate/component/dashboard.dart';
import 'package:housemate/modal/modal.dart';
import 'package:path_provider/path_provider.dart';

import '../../component/profile.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Modal.bottomNavIndex =0;
  }

  File? showImage;

  @override
  Widget build(BuildContext context) {

    Map res = ModalRoute.of(context)!.settings.arguments as Map;


    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;



    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: IndexedStack(
          index: Modal.bottomNavIndex,
          children: [
            const DashBoard(),
            Container(color: Colors.blue,),
            const Profile(),
          ],
        ),
      ),
      drawer: Drawer(
        width: _width * 0.77,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: _height * 0.30,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.black45,
              ),
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.white54,
                backgroundImage: FileImage(res['image']!)
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: drawerItems(
                name: "Services",
                color: Colors.purple,
                icon: const Icon(Icons.miscellaneous_services_rounded),
              ),
            ),
            Divider(
              color: Colors.black.withOpacity(0.2),
              height: 2,
              thickness: 1,
            ),
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, 'employee_page');
              },
              child: drawerItems(
                name: "Employee",
                color: Colors.red,
                icon: const Icon(Icons.people_alt_outlined),
              ),
            ),
            Divider(
              color: Colors.black.withOpacity(0.2),
              height: 2,
              thickness: 1,
            ),
            GestureDetector(
              onTap: (){
                setState(() {
                  Navigator.pop(context);
                  Modal.bottomNavIndex = 2;
                });
              },
              child: drawerItems(
                name: "Profile",
                color: Colors.amber,
                icon: const Icon(Icons.person),
              ),
            ),
            Divider(
              color: Colors.black.withOpacity(0.2),
              height: 2,
              thickness: 1,
            ),
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, 'contactUs_page');
              },
              child: drawerItems(
                name: "Contact us",
                color: Colors.red,
                icon: const Icon(Icons.perm_contact_cal_outlined),
              ),
            ),
            Divider(
              color: Colors.black.withOpacity(0.2),
              height: 2,
              thickness: 1,
            ),
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, 'aboutUs_page');
              },
              child: drawerItems(
                name: "About Us",
                color: Colors.amber,
                icon: const Icon(Icons.align_vertical_bottom_outlined),
              ),
            ),
            Divider(
              color: Colors.black.withOpacity(0.2),
              height: 2,
              thickness: 1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, //params
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: const Color(0xffedf2f4),
        child: Icon(
          Modal.bottomNavIcons[Modal.bottomNavIndex],
          color: const Color(0xffd90429),
          size: 25,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: Modal.bottomNavIcons,
        iconSize: 27,
        inactiveColor: const Color(0xff8d99ae),
        activeColor: Colors.white,
        backgroundColor: const Color(0xff4a4e69),
        activeIndex: Modal.bottomNavIndex,
        height: 65,
        gapLocation: GapLocation.end,
        notchSmoothness: NotchSmoothness.smoothEdge,
        onTap: (index) => setState(
              () {
            Modal.bottomNavIndex = index;
          },
        ),
        //other params
      ),
    );
  }

  drawerItems(
      {required String name, required Color color, required Icon icon}) {
    return Row(
      children: [
        IconButton(
          icon: icon,
          color: color,
          onPressed: () {},
        ),
        const SizedBox(width: 5),
        Text(
          name,
          style: GoogleFonts.habibi(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
