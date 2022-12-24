import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemate/helper/firestoreHelper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({Key? key}) : super(key: key);

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  GlobalKey<FormState> fromKey = GlobalKey<FormState>();

  TextEditingController dateInput = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  File? showImage;
  String? image;
  Uint8List? imgData;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    dateInput.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fill Your Profile",
          style: GoogleFonts.balooBhai2(fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('forget_pass');
            },
            icon: const Icon(Icons.near_me),
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Form(
          key: fromKey,
          child: ListView(
            children: [
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      maxRadius: 60,
                      backgroundColor: Colors.grey.shade800,
                      backgroundImage:
                          (showImage != null) ? FileImage(showImage!) : null,
                    ),
                    Positioned(
                      top: 75,
                      child: FloatingActionButton(
                        onPressed: () async {
                          ImagePicker picker = ImagePicker();

                          XFile? xFile = await picker.pickImage(
                              source: ImageSource.camera);

                          imgData = await xFile?.readAsBytes();

                          imgData = await FlutterImageCompress.compressWithList(
                            imgData!,
                            minHeight: 200,
                            minWidth: 200,
                            quality: 80,
                          );

                          setState(() {
                            showImage = File(xFile!.path);
                          });
                        },
                        child: const Icon(Icons.edit),
                        mini: true,
                        backgroundColor: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 50,
                child: TextFormField(
                  validator: (val) {
                    return (val!.isEmpty) ? 'Enter First Name...' : null;
                  },
                  controller: fullNameController,
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white24)),
                      hintText: "Full Name",
                      hintStyle:
                          TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      filled: true,
                      fillColor: Colors.grey.shade900),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: nickNameController,
                  validator: (val) {
                    return (val!.isEmpty) ? 'Enter Nickname ...' : null;
                  },
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      hintText: "Nick Name",
                      hintStyle:
                          TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      filled: true,
                      fillColor: Colors.grey.shade900),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: TextFormField(
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                  validator: (val) {
                    return (val!.isEmpty) ? 'Select DOB...' : null;
                  },
                  controller: dateInput,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      hintText: "Date of Birth",
                      hintStyle:
                          TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      filled: true,
                      fillColor: Colors.grey.shade900),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2101));

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('dd-MM-yyyy').format(pickedDate);

                      setState(() {
                        dateInput.text = formattedDate;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    return (val!.isEmpty) ? 'Enter Email...' : null;
                  },
                  controller: emailController,
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      hintText: "Email",
                      hintStyle:
                          TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      filled: true,
                      fillColor: Colors.grey.shade900),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    return (val!.isEmpty) ? 'Enter Phone Number' : null;
                  },
                  controller: phoneController,
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      hintText: "Phone Number",
                      hintStyle:
                          TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      filled: true,
                      fillColor: Colors.grey.shade900),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: TextFormField(
                  validator: (val) {
                    return (val!.isEmpty) ? 'Enter Address' : null;
                  },
                  controller: addressController,
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      hintText: "Address",
                      hintStyle:
                          TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      filled: true,
                      fillColor: Colors.grey.shade900),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () async {
                  if (fromKey.currentState!.validate()) {
                    image = base64.encode(imgData!);

                    setState(() {
                      userData = {
                        'image': image,
                        'fullName': fullNameController.text,
                        'nickname': nickNameController.text,
                        'dob': dateInput.text,
                        'mobile': phoneController.text,
                        'email': emailController.text,
                        'address': addressController.text,
                      };
                    });

                    DocumentReference docRef = await FireStoreHelper
                        .fireStoreHelper
                        .insertUserData(data: userData as Map<String, dynamic>);

                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Container(
                                height: 300,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade900,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.deepPurpleAccent,
                                      size: 120,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    const Text(
                                      "Created Successfully",
                                      style: TextStyle(
                                          fontSize: 22, color: Colors.white),
                                    ),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                       setState(() {
                                         userData = {
                                           'image': showImage,
                                           'fullName': fullNameController.text,
                                           'nickname': nickNameController.text,
                                           'dob': dateInput.text,
                                           'mobile': phoneController.text,
                                           'email': emailController.text,
                                           'address': addressController.text,
                                         };
                                       });
                                        Navigator.of(context)
                                            .pushReplacementNamed('/',
                                                arguments: userData);
                                        setState(() {
                                          showImage = null;
                                        });
                                        fullNameController.clear();
                                        nickNameController.clear();
                                        dateInput.clear();
                                        phoneController.clear();
                                        emailController.clear();
                                        addressController.clear();
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: const Text(
                                          "OK",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                        height: 45,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurpleAccent,
                                          borderRadius:
                                              BorderRadius.circular(70),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Text(
                    "Continue",
                    style: GoogleFonts.balooBhai2(
                        fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
