import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryEmployee extends StatefulWidget {
  const CategoryEmployee({Key? key}) : super(key: key);

  @override
  State<CategoryEmployee> createState() => _CategoryEmployeeState();
}

class _CategoryEmployeeState extends State<CategoryEmployee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee', style: GoogleFonts.balooBhai2()),
      ),
    );
  }
}
