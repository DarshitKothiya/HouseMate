import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../helper/firestoreHelper.dart';

class ServicesData extends StatefulWidget {
  const ServicesData({Key? key}) : super(key: key);

  @override
  State<ServicesData> createState() => _ServicesDataState();
}

class _ServicesDataState extends State<ServicesData> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController categoryController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController featureController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  File? showImage;
  String? image;
  Uint8List? imgData;

  bool isImageValidate = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
                childAspectRatio: 0.8),
            padding: const EdgeInsets.only(bottom: 10),
            itemCount: data.length,
            itemBuilder: (context, i) {
              Uint8List iconImage = base64.decode(data[i]['image']);

              return GestureDetector(
                onTap: () async {

                  String tmpImage = data[i]['name'];

                    final tempDir = await getTemporaryDirectory();
                    showImage = await File('${tempDir.path}/$tmpImage.png').create();
                  setState(() {
                    showImage!.writeAsBytesSync(iconImage);
                    categoryController.value =
                        TextEditingValue(text: data[i]['name']);
                    durationController.value =
                        TextEditingValue(text: data[i]['duration']);
                    featureController.value =
                        TextEditingValue(text: data[i]['feature']);
                    descriptionController.value =
                        TextEditingValue(text: data[i]['description']);
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
                            content: Form(
                              key: formKey,
                              child: SingleChildScrollView(
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
                                            showImage = File(xFile!.path);
                                          });
                                        },
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.black45,
                                          backgroundImage: (showImage != null)
                                              ? FileImage(showImage!)
                                              : null,
                                          child: (showImage == null)
                                              ? const Text('Add Icon')
                                              : const Text(''),
                                        ),
                                    ),
                                    (isImageValidate)
                                        ? const Text('')
                                        : const Text(
                                            'Pick Image First....',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      height: 50,
                                      child: TextFormField(
                                        controller: categoryController,
                                        validator: (val) {
                                          return (val!.isEmpty)
                                              ? 'Enter Category first...'
                                              : null;
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
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    image = base64.encode((imgData != null)
                                        ? imgData!
                                        : iconImage);

                                    String id = data[i].id;

                                    Map<String, dynamic> newData = {
                                      'image': image,
                                      'name': categoryController.text,
                                      'duration': '${durationController.text} Hr',
                                      'feature': featureController.text,
                                      'description': descriptionController.text,
                                    };

                                    FireStoreHelper.fireStoreHelper
                                        .updateCategoryData(
                                            data: newData, id: id);

                                    setState((){
                                      showImage = null;
                                      categoryController.clear();
                                      durationController.clear();
                                      featureController.clear();
                                      descriptionController.clear();
                                    });

                                    Navigator.of(context).pop();
                                  }
                                },
                                child: const Text('Update'),
                              ),
                              IconButton(
                                onPressed: () {

                                  String id = data[i].id;

                                  FireStoreHelper.fireStoreHelper.deleteCategoryData(id: id);
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
                                    showImage = null;
                                    categoryController.clear();
                                    durationController.clear();
                                    featureController.clear();
                                    descriptionController.clear();
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
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.cyan),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: MemoryImage(iconImage),
                                  fit: BoxFit.cover)),
                        ),
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
    );
  }
}
