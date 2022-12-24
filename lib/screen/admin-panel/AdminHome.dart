import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemate/component/adminDashboard.dart';
import 'package:housemate/helper/firebaseAuthHelper.dart';
import 'package:housemate/helper/firestoreHelper.dart';
import 'package:image_picker/image_picker.dart';

import '../../component/ManageDataService.dart';
import '../../helper/localNotificatinHelper.dart';
import '../../modal/modal.dart';

class AdminHomepage extends StatefulWidget {
  const AdminHomepage({Key? key}) : super(key: key);

  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController categoryController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController featureController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();


  TextEditingController empNameController = TextEditingController();
  TextEditingController empProofController = TextEditingController();
  TextEditingController empMobileController = TextEditingController();
  TextEditingController empAddressController = TextEditingController();
  TextEditingController empSalaryController = TextEditingController();
  TextEditingController empDescriptionController = TextEditingController();
  TextEditingController empCategoryController = TextEditingController();

  File? showImage;
  File? empImage;
  String? image;

  bool isImageValidate = true;
  bool isEmpImageValidate = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Modal.bottomNavIndex =0;

    super.initState();
    var adroidIntialzeSettings =
    AndroidInitializationSettings("mipmap/ic_launcher");
    var iosIntialzeSettings = DarwinInitializationSettings();
    var initalizeSettins = InitializationSettings(
        android: adroidIntialzeSettings, iOS: iosIntialzeSettings);

    LocalNotificationHelper.flutterLocalNotificationsPlugin
        .initialize(initalizeSettins,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          print("================");
          print(response);
          print("================");
        });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: const Text('Admin Panel'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuthHelper.firebaseAuthHelper.logOutUser();
              Navigator.pushReplacementNamed(context, 'signUp_page');
            },
            icon: const Icon(Icons.power_settings_new),
          ),
        ],
      ),
      body: IndexedStack(
        index: Modal.bottomNavIndex,
        children: const [
          AdminDashboard(),
          ManageServiceData(),
        ],
      ),
      floatingActionButton: (Modal.bottomNavIndex==1) ?FloatingActionButton(
        onPressed: () {

          (Modal.manageDataIndex ==0) ? insertServices():insertEmployee();
        }, //params
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: const Color(0xff4a4e69),
        child: const Icon(
         CupertinoIcons.add,
          color: Colors.white,
          size: 25,
        ),
      ):Container(),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: Modal.bottomNavIcons,
        iconSize: 27,
        inactiveColor: const Color(0xff8d99ae),
        activeColor: Colors.white,
        backgroundColor: const Color(0xff4a4e69),
        activeIndex: Modal.bottomNavIndex,
        height: 65,
        gapLocation: GapLocation.none,
        onTap: (index) => setState(
              () {
            Modal.bottomNavIndex = index;
          },
        ),
      ),
    );
  }

  insertServices() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context,  setState){
            return AlertDialog(
              title: Center(
                child: Text('Add Category',style: GoogleFonts.balooBhai2(fontSize: 24),),
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () async{

                          ImagePicker picker = ImagePicker();

                          XFile? xFile = await picker.pickImage(source: ImageSource.camera);

                          Uint8List? imgData = await xFile?.readAsBytes();

                          imgData = await FlutterImageCompress.compressWithList(
                            imgData!,
                            minHeight: 200,
                            minWidth: 200,
                            quality: 80,
                          );

                          setState((){
                            showImage = File(xFile!.path);
                            image = base64.encode(imgData!);
                          });

                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.black45,
                          child: (showImage==null) ?const Text('Add Icon'): const Text(''),
                          backgroundImage: (showImage!=null) ?FileImage(showImage!):null,
                        ),
                      ),
                      (isImageValidate)? const Text(''):const Text('Pick Image First....',style: TextStyle(color: Colors.red),),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: categoryController,
                          validator: (val) {
                            return (val!.isEmpty) ? 'Enter Category first...' : null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'enter Category Name',
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: durationController,
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            return (val!.isEmpty)
                                ? 'Enter Duration first...'
                                : null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'enter Category Duration',
                            labelText: 'Duration',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: featureController,
                          validator: (val) {
                            return (val!.isEmpty)
                                ? 'Enter Feature first...'
                                : null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'enter Category Feature',
                            labelText: 'Feature',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: descriptionController,
                          validator: (val) {
                            return (val!.isEmpty)
                                ? 'Enter Description first...'
                                : null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'enter Category Description',
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async{

                    if(formKey.currentState!.validate()&&showImage!=null){


                        Map<String, dynamic> data = {
                          'image': image,
                          'name': categoryController.text,
                          'duration': '${durationController.text} Hr',
                          'feature': featureController.text,
                          'description': descriptionController.text,
                        };

                        DocumentReference docRef = await FireStoreHelper.fireStoreHelper.insertCategoryData(data: data);

                        Navigator.of(context).pop();

                        isImageValidate = true;
                        showImage=null;
                        categoryController.clear();
                        durationController.clear();
                        featureController.clear();
                        descriptionController.clear();

                    }else{
                      setState((){
                        isImageValidate=false;
                      });
                    }
                  },
                  child: const Text('Add'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    isImageValidate = true;
                    showImage = null;
                    categoryController.clear();
                    durationController.clear();
                    featureController.clear();
                    descriptionController.clear();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
        },
        );
      },
    );
  }

  insertEmployee() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context,  setState){
            return AlertDialog(
              title: Center(
                child: Text('Add Employee',style: GoogleFonts.balooBhai2(fontSize: 24),),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () async{

                          ImagePicker picker = ImagePicker();

                          XFile? xFile = await picker.pickImage(source: ImageSource.camera);

                          Uint8List? imgData = await xFile?.readAsBytes();

                          imgData = await FlutterImageCompress.compressWithList(
                            imgData!,
                            minHeight: 200,
                            minWidth: 200,
                            quality: 80,
                          );

                          setState((){
                            empImage = File(xFile!.path);
                            image = base64.encode(imgData!);
                          });

                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.black45,
                          backgroundImage: (empImage!=null) ?FileImage(empImage!):null,
                          child: (empImage==null) ?const Text('Add Photo'): const Text(''),
                        ),
                      ),
                      (isEmpImageValidate)? const Text(''):const Text('Pick Image First....',style: TextStyle(color: Colors.red),),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: empNameController,
                        validator: (val) {
                          return (val!.isEmpty) ? 'Enter Employee Name first...' : null;
                        },
                        decoration: InputDecoration(
                          hintText: 'enter Employee Name',
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: empMobileController,
                        validator: (val) {
                          return (val!.isEmpty) ? 'Enter Employee Mobile first...' : null;
                        },
                        decoration: InputDecoration(
                          hintText: 'enter Employee Mobile No.',
                          labelText: 'Mobile No.',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: empAddressController,
                        validator: (val) {
                          return (val!.isEmpty) ? 'Enter Employee Address first...' : null;
                        },
                        decoration: InputDecoration(
                          hintText: 'enter Employee Address ',
                          labelText: 'Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: empDescriptionController,
                        validator: (val) {
                          return (val!.isEmpty) ? 'Enter Employee Description first...' : null;
                        },
                        decoration: InputDecoration(
                          hintText: 'enter Employee Description ',
                          labelText: 'Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: empCategoryController,
                        validator: (val) {
                          return (val!.isEmpty) ? 'Enter Employee Category first...' : null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter Employee Category ',
                          labelText: 'Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async{

                    if(formKey.currentState!.validate()&&empImage!=null){


                      Map<String, dynamic> data = {
                        'image': image,
                        'name': empNameController.text,
                        'mobile': empMobileController.text,
                        'address': empAddressController.text,
                        'description' : empDescriptionController.text,
                        'category': empCategoryController.text,
                      };

                      DocumentReference docRef = await FireStoreHelper.fireStoreHelper.insertEmployeeData(data: data);

                      print('-----------------------------------------------------------');
                      print(docRef.id);
                      print('-----------------------------------------------------------');

                      isEmpImageValidate = true;
                      empImage =null;
                      empNameController.clear();
                      empMobileController.clear();
                      empAddressController.clear();
                      empDescriptionController.clear();
                      empCategoryController.clear();

                      Navigator.of(context).pop();
                    }else{
                      setState((){
                        isEmpImageValidate=false;
                      });
                    }
                  },
                  child: const Text('Add'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    isEmpImageValidate = true;
                    empImage =null;
                    empNameController.clear();
                    empMobileController.clear();
                    empAddressController.clear();
                    empDescriptionController.clear();
                    empCategoryController.clear();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
