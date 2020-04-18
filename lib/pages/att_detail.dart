import 'package:flutter/material.dart';

class Att_detail extends StatefulWidget {
  @override
  _Att_detailState createState() => _Att_detailState();
}

class _Att_detailState extends State<Att_detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Screen"),),
        body: Container(
          child:Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text("hello"),
              RaisedButton(onPressed: (){

              },child: Text("Detect"),)

            ],
          
          ),
          )
          

        ),
      
    );
  }
}