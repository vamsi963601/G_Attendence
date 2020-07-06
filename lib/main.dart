import 'package:G_Attendence/pages/att_detail.dart';
import 'package:G_Attendence/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Saira'),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("G-Attendence", style: TextStyle(fontWeight: FontWeight.w400),),
          backgroundColor: Color.fromRGBO(177, 4, 14, 1),
        ),
        body: HomePage(),
      ),
    );
  }
}