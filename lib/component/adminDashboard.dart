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
import 'package:path_provider/path_provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {

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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FireStoreHelper.fireStoreHelper.fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        else if (snapshot.hasData) {
          QuerySnapshot? querySnapShot = snapshot.data;

          List<QueryDocumentSnapshot> data = querySnapShot!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {

              Uint8List leadingImage = base64.decode(data[i]['image']);

              return Card(
                elevation: 5,
                child: ListTile(
                  onTap: () async{

                      String tmpImage = data[i]['fullName'];

                      final tempDir = await getTemporaryDirectory();
                      showImage = await File('${tempDir.path}/$tmpImage.png').create();
                      setState(() {
                        showImage!.writeAsBytesSync(leadingImage);
                        fullNameController.value =
                            TextEditingValue(text: data[i]['fullName']);
                        nickNameController.value =
                            TextEditingValue(text: data[i]['nickname']);
                        emailController.value =
                            TextEditingValue(text: data[i]['email']);
                        dateInput.value =
                            TextEditingValue(text: data[i]['dob']);
                        phoneController.value =
                            TextEditingValue(text: data[i]['mobile']);
                        addressController.value =
                            TextEditingValue(text: data[i]['address']);
                      });

                      tempDir.delete();

                      showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                title: Center(
                                  child: Text(
                                    'Update User',
                                    style: GoogleFonts.balooBhai2(fontSize: 24),
                                  ),
                                ),
                                content: Form(
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
                                              backgroundImage: (showImage != null)
                                                  ? FileImage(showImage!)
                                                  : null,
                                            ),
                                            Positioned(
                                              top: 75,
                                              child: FloatingActionButton(
                                                onPressed: () async{
                                                  ImagePicker picker = ImagePicker();

                                                  XFile? xFile = await picker.pickImage(
                                                      source: ImageSource.camera);

                                                  imgData = await xFile?.readAsBytes();

                                                  imgData = await FlutterImageCompress
                                                      .compressWithList(
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

                                                shape:  RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      SizedBox(
                                        height: 50,
                                        child: TextFormField(
                                          validator: (val){
                                            (val!.isEmpty) ? 'Enter First Name...':null;
                                          },
                                          controller: fullNameController,
                                          style: const TextStyle(color: Colors.white, fontSize: 17),
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                  borderSide: BorderSide(color: Colors.white24)
                                              ),
                                              hintText: "Full Name",
                                              hintStyle:
                                              TextStyle(color: Colors.grey.shade600, fontSize: 16),
                                              filled: true,
                                              fillColor: Colors.grey.shade900),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        height: 50,
                                        child: TextFormField(
                                          controller: nickNameController,
                                          validator: (val){
                                            (val!.isEmpty) ?'Enter Nickname ...':null;
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
                                        height: 5,
                                      ),
                                      SizedBox(
                                        height: 50,
                                        child: TextFormField(
                                          style: const TextStyle(color: Colors.white, fontSize: 17),
                                          validator: (val){
                                            (val!.isEmpty) ? 'Select DOB...':null;
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
                                        height: 5,
                                      ),
                                      SizedBox(
                                        height: 50,
                                        child: TextFormField(
                                          keyboardType: TextInputType.emailAddress,
                                          validator: (val){
                                            (val!.isEmpty) ?'Enter Email...':null;
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
                                        height: 5,
                                      ),
                                      SizedBox(
                                        height: 50,
                                        child: TextFormField(
                                          keyboardType: TextInputType.phone,
                                          validator: (val){
                                            (val!.isEmpty)?'Enter Phone Number':null;
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
                                        height: 5,
                                      ),
                                      SizedBox(
                                        height: 50,
                                        child: TextFormField(
                                          validator: (val){
                                            (val!.isEmpty)?'Enter Address':null;
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
                                    ],
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (fromKey.currentState!.validate()) {
                                        image = base64.encode((imgData != null)
                                            ? imgData!
                                            : leadingImage);

                                        String id = data[i].id;

                                        Map<String, dynamic> newData = {
                                          'image': image,
                                          'fullName' : fullNameController.text,
                                          'nickname': nickNameController.text,
                                          'dob': dateInput.text,
                                          'mobile': phoneController.text,
                                          'email': emailController.text,
                                          'address': addressController.text,
                                        };

                                        FireStoreHelper.fireStoreHelper
                                            .updateUserData(
                                            data: newData, id: id,
                                        );

                                        setState(() {
                                          showImage=null;
                                        });
                                        fullNameController.clear();
                                        nickNameController.clear();
                                        dateInput.clear();
                                        phoneController.clear();
                                        emailController.clear();
                                        addressController.clear();

                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: const Text('Update'),
                                  ),
                                  IconButton(
                                    onPressed: () {

                                      String id = data[i].id;

                                      FireStoreHelper.fireStoreHelper.deleteUserData(id: id);
                                      Navigator.pop(context);

                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);

                                      setState(() {
                                        showImage=null;
                                      });
                                      fullNameController.clear();
                                      nickNameController.clear();
                                      dateInput.clear();
                                      phoneController.clear();
                                      emailController.clear();
                                      addressController.clear();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  leading: Image.memory(leadingImage),
                  title: Text(data[i]['fullName']),
                ),
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
