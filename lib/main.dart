import 'package:flutter/material.dart';
import './home.dart';

void main() {
  runApp(
    MaterialApp(
      title: "The hello weather App",
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        
        body: Home(),
      ),
    ),
  );
}