import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

import '../../helper/firestoreHelper.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({Key? key}) : super(key: key);

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {

  File? showEmpImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee'),
      ),
      body: StreamBuilder(
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

                      });

                      tempDir.delete();

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
          }),
    );
  }
}
