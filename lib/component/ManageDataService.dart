import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:housemate/component/employeeData.dart';
import 'package:housemate/component/serviceData.dart';
import 'package:housemate/modal/modal.dart';

class ManageServiceData extends StatefulWidget {
  const ManageServiceData({Key? key}) : super(key: key);

  @override
  State<ManageServiceData> createState() => _ManageServiceDataState();
}

class _ManageServiceDataState extends State<ManageServiceData> {
  bool isServicesSelected = true;
  bool isEmployeeSelected = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            height: 55,
            width: 325,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.black)),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        Modal.manageDataIndex = 0;
                        isServicesSelected = true;
                        isEmployeeSelected = false;
                      });
                    },
                    child: Container(
                      height: 50,
                      width: 150,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: (isServicesSelected)
                              ? Colors.black12
                              : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            bottomLeft: Radius.circular(25),
                          )),
                      child: Text(
                        'Services',
                        style: GoogleFonts.balooBhai2(
                            fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        Modal.manageDataIndex = 1;
                        isServicesSelected = false;
                        isEmployeeSelected = true;
                      });
                    },
                    child: Container(
                      height: 50,
                      width: 150,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: (isEmployeeSelected)
                              ? Colors.black12
                              : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          )),
                      child: Text(
                        'Employee',
                        style: GoogleFonts.balooBhai2(
                            color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IndexedStack(
                index: Modal.manageDataIndex,
                children: const [
                  ServicesData(),
                  EmployeeData(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
