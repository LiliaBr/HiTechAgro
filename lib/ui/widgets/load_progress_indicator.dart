import 'package:flutter/material.dart';

class LoadProgressIndicator extends StatelessWidget {
    @override
    Widget build(context) { 
      return Container(
        width: double.infinity,
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircularProgressIndicator()]) 
      );
    }
}