import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData hmTheme = ThemeData(
  primaryColor: Color(0xFFFF9900),
  
	textTheme:
      GoogleFonts.exo2TextTheme(),
  
	textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
			textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
			primary: Colors.white,
			backgroundColor: Color(0xFFFF9900),
			shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),

  inputDecorationTheme: InputDecorationTheme(  
		enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        borderSide: BorderSide(color: Color(0xFF025FA3).withOpacity(0.2), width: 1)),
    
		focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(color: Color(0xFFFF9900))),
    
		errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(color: Colors.red)),
    
		focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(color: Colors.red)),
  ),
  dividerColor: Colors.grey[600],
	iconTheme: IconThemeData(color: Color(0xFF025FA3), size: 30),

);
