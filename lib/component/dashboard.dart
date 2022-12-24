import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemate/helper/firebaseAuthHelper.dart';
import 'package:housemate/helper/firestoreHelper.dart';
import 'package:path_provider/path_provider.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  File? showImage;

  int index = 0;

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 38),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 2, bottom: 2),
              child: IconButton(
                onPressed: () {

                },
                icon: const Icon(Icons.menu,color: Colors.white,),
              ),
            ),
            const SizedBox(width: 15),
            Text(
              'Welcome 👋',
              textAlign: TextAlign.left,
              style: GoogleFonts.habibi(fontSize: 16, color: Colors.white),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                FirebaseAuthHelper.firebaseAuthHelper.logOutUser();
                Navigator.pushReplacementNamed(context, 'signUp_page');
              },
              icon: const Icon(CupertinoIcons.power),
              color: Colors.white,
            ),
            const SizedBox(width: 5),
          ],
        ),
        const SizedBox(height: 25),
        TextField(
          style: GoogleFonts.balooBhai2(color: Colors.white, fontSize: 17),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white12,
            hintText: 'Search',
            hintStyle:
                GoogleFonts.balooBhai2(color: Colors.white54, fontSize: 17),
            prefixIcon: const Icon(
              CupertinoIcons.search,
              color: Colors.white,
            ),
            contentPadding: const EdgeInsets.only(left: 14.0, top: 8),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white10),
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white10),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Special Offer',
          style: GoogleFonts.habibi(fontSize: 16, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Container(
          height: _height * 0.23,
          width: _width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.teal,
              image: const DecorationImage(
                  image: NetworkImage(
                      'https://thumbs.dreamstime.com/b/housekeeping-background-cleaning-items-illustration-service-design-advertising-housekeeping-background-cleaning-169774805.jpg'),
                  fit: BoxFit.cover)),
        ),
        const SizedBox(height: 20),
        Text(
          'Category',
          style: GoogleFonts.habibi(fontSize: 16, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: StreamBuilder(
            stream: FireStoreHelper.fireStoreHelper.fetchCategoryData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error ${snapshot.error}'),
                );
              } else if (snapshot.hasData) {
                QuerySnapshot? querySnapShot = snapshot.data;

                List<QueryDocumentSnapshot> data = querySnapShot!.docs;

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.9),
                  padding: const EdgeInsets.only(bottom: 10),
                  itemCount: data.length,
                  itemBuilder: (context, i) {

                    index = i;


                      Uint8List iconImage = base64.decode(data[index]['image']);


                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white54),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              (showImage != null)
                                  ? Image.memory(
                                      iconImage!,
                                      height: 70,
                                      width: 70,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(),
                              Text(
                                '${data[i]['name']}',
                                style: GoogleFonts.balooBhai2(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              )
                            ],
                          )),
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ],
    );
  }

  getImage(
      {required Uint8List image, required QueryDocumentSnapshot data}) async {

    print('__________________________________________________');
    print('hello');
    print('__________________________________________________');

    String tmpImage = data['name'];
    final tempDir = await getTemporaryDirectory();
    showImage = await File('${tempDir.path}/$tmpImage.png').create();
    showImage!.writeAsBytesSync(image);
  }
}
