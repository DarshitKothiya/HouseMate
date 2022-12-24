import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemate/helper/firestoreHelper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class EmployeeData extends StatefulWidget {
  const EmployeeData({Key? key}) : super(key: key);

  @override
  State<EmployeeData> createState() => _EmployeeDataState();
}

class _EmployeeDataState extends State<EmployeeData> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController empNameController = TextEditingController();
  TextEditingController empProofController = TextEditingController();
  TextEditingController empMobileController = TextEditingController();
  TextEditingController empAddressController = TextEditingController();
  TextEditingController empSalaryController = TextEditingController();
  TextEditingController empDescriptionController = TextEditingController();
  TextEditingController empCategoryController = TextEditingController();

  Uint8List? imgData;
  File? showEmpImage;
  String? image;

  bool isImageValidate = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FireStoreHelper.fireStoreHelper.fetchEmployeeData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            QuerySnapshot? querySnapShot = snapshot.data;

            List<QueryDocumentSnapshot> data = querySnapShot!.docs;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, i) {
                Uint8List empIconImage = base64.decode(data[i]['image']);

                return GestureDetector(
                  onTap: () async {

                    String tmpImage = data[i]['name'];

                    final tempDir = await getTemporaryDirectory();
                    showEmpImage = await File('${tempDir.path}/$tmpImage.png').create();
                    setState(() {
                      showEmpImage!.writeAsBytesSync(empIconImage);
                      empNameController.value = TextEditingValue(text: data[i]['name']);
                      empMobileController.value = TextEditingValue(text: data[i]['mobile']);
                      empAddressController.value = TextEditingValue(text: data[i]['address']);
                      empDescriptionController.value = TextEditingValue(text: data[i]['description']);
                      empCategoryController.value = TextEditingValue(text: data[i]['category']);
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
                                  'Update Category',
                                  style: GoogleFonts.balooBhai2(fontSize: 24),
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                        onTap: () async {
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
                                            showEmpImage = File(xFile!.path);
                                          });
                                        },
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.black45,
                                          child: (showEmpImage == null)
                                              ? const Text('Add Icon')
                                              : const Text(''),
                                          backgroundImage: (showEmpImage != null)
                                              ? FileImage(showEmpImage!)
                                              : null,
                                        )),
                                    (isImageValidate)
                                        ? const Text('')
                                        : const Text(
                                      'Pick Image First....',
                                      style: TextStyle(color: Colors.red),
                                    ),
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
                              actions: [
                                ElevatedButton(
                                  onPressed: () async {

                                     if(formKey.currentState!.validate()){
                                       image = base64.encode((imgData != null)
                                           ? imgData!
                                           : empIconImage);

                                       String id = data[i].id;

                                       Map<String, dynamic> newData = {
                                         'image': image,
                                         'name': empNameController.text,
                                         'mobile': empMobileController.text,
                                         'address': empAddressController.text,
                                         'description' : empDescriptionController.text,
                                         'category': empCategoryController.text,
                                       };

                                       FireStoreHelper.fireStoreHelper.updateEmployeeData(data: newData, id: id);

                                       setState((){
                                         showEmpImage = null;
                                         empNameController.clear();
                                         empMobileController.clear();
                                         empAddressController.clear();
                                         empDescriptionController.clear();
                                         empCategoryController.clear();
                                       });

                                       Navigator.of(context).pop();
                                     }
                                  },
                                  child: const Text('Update'),
                                ),
                                IconButton(
                                  onPressed: () {

                                    String id = data[i].id;

                                    FireStoreHelper.fireStoreHelper.deleteEmployeeData(id: id);
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

                                    setState((){
                                      showEmpImage = null;
                                      empNameController.clear();
                                      empMobileController.clear();
                                      empAddressController.clear();
                                      empDescriptionController.clear();
                                      empCategoryController.clear();
                                    });
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
                  child: Card(
                    elevation: 3,
                    child: Container(
                      height: 70,
                      alignment: Alignment.center,
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 40,
                          backgroundImage: MemoryImage(empIconImage),
                        ),
                        title: Text(data[i]['name']),
                        subtitle: Text('${data[i]['mobile']} \n${data[i]['address']}'),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
