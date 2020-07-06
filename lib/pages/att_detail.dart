import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Att_detail extends StatefulWidget {
  @override
  _Att_detailState createState() => _Att_detailState();
}

class _Att_detailState extends State<Att_detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(76, 90, 142, 1),
        title: Text("Attendance Post"),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: _choose,
                child: Text('Choose Image'),
              ),
              SizedBox(width: 10.0),
              RaisedButton(
                onPressed: _upload,

                // FutureBuilder(
                //   future: _upload(),
                //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                //     if (snapshot.data.length == null) {
                //       return AlertDialog(title: Text("loading"));
                //     }
                //     return ListView.builder(
                //         itemCount: snapshot.data.length,
                //         itemBuilder: (BuildContext context, int index) {
                //           return ListTile();
                //         });
                //   },
                // ),
                child: Text('Upload Image'),
              ),
            ],
          ),

          (file == null) ? Text('No Image Selected') : Text('Image Selected'),
          // Image.file(file)
        ],
      ),
      
    );
  }

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: Color.fromRGBO(76, 90, 142, 1),
  //       title: Text("Attendance Post"),),
  //       body: Container(
  //         child:Center(
  //             child: Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: <Widget>[
  //             Text("hello"),
  //             RaisedButton(onPressed: (){

  //             },child: Text("Detect"),)

  //           ],

  //         ),
  //         )

  //       ),

  //   );
  // }
  final String phpEndPoint = 'http://35.154.161.95:3000/detect-face';
//final String nodeEndPoint = 'http://192.168.43.171:3000/image';
  File file;
  String responseJson;

  void _choose() async {
    file = await ImagePicker.pickImage(source: ImageSource.camera);
// file = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<List<Students>> _upload() async {
    String base64Image = base64Encode(file.readAsBytesSync());
    Map<String, String> headers = {
      "Cache-Control": "no-cache",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate, br",
      "Content-Type": "application/x-www-form-urlencoded; charseet=UTF-8",
      "Connection": "keep-alive",
    };

    http.Response response = await http
        .post(phpEndPoint, headers: headers, body: {"photo": base64Image});

    int statusCode = response.statusCode;
    print('This is the statuscode: $statusCode');
    final responseJson = json.decode(response.body);
    print(responseJson);

    List<Students> students = [];

    for (var s in responseJson) {
      Students student = Students(s["ExternalImageId"]);
      students.add(student);
    }


    

    //print('This is the API response: $responseJson');
  }
  

//  void _upload() {
//   //  if (file == null) return;
//       String base64Image = base64Encode(file.readAsBytesSync());
//   //  String fileName = file.path.split("/").last;

//    http.post(phpEndPoint, headers: {
//      "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
//      "Host" : "localhost:3000",
//      "Cache-Control" : "no-cache",
//      "photo": base64Image,
//    },
//    body: {

//    }).then((res) {
//      print(res.statusCode);
//    }).catchError((err) {
//      print(err);
//    });
//  }

}

class Students {
  final String externalimageid;
  Students(this.externalimageid);
}
