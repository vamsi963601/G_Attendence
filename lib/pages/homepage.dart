import 'dart:convert';

import 'package:G_Attendence/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  void initState() {
    _autoLogin();
    super.initState();
  }

  _autoLogin() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String u,p;
    u = sharedPreferences.getString("user_id");
    p = sharedPreferences.getString("password");
    if(u!=null && u!="" && p!=null && p!=""){
      progress(context);
      _checkLogin(u, p);
      print(u);
    }
  }

  final String url ="http://3.6.138.40/GAtt/api/modules/test.php?/=login";
  ProgressDialog pd;
  String userid;
  String password,urlTB;
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    double screen_height = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: screen_height/10, bottom: screen_height/10, left: screen_width/10, right: screen_width/10),
      child: Wrap(
        children: <Widget>[
          Card(
            elevation: 5,
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Form(
                    key: _key,
                    autovalidate: _validate,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("GITAM",style: TextStyle(fontWeight: FontWeight.w700, fontSize: screen_width/10, color: Color.fromRGBO(177, 4, 14, 1))),
                        // Text("G-",style: TextStyle(fontSize: screen_width/20),),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'User Id'
                          ),
                          autofocus: true,
                          validator: (String value){
                            if(value.length<4){
                              return "Enter Valid User ID";
                            }
                            else{
                              userid = value;
                              return null;
                            }
                          },

                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password'
                          ),
                          validator: (String value){
                            if(value.length<4){
                              return "Minimum 4 Charecters";
                            }
                            else{
                              password = value;
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 25,),
                        Container(
                          width: double.infinity,
                          child: RaisedButton(
                            elevation: 10,
                            onPressed: (){
                              _validateAndSubmit(context);
                            },
                            child: Text("Submit",style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white),),
                            color: Color.fromRGBO(177, 4, 14, 1),
                            
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("Follow Us On"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                            icon: FaIcon(FontAwesomeIcons.facebook, color: Color.fromRGBO(66,103,178,1),),
                            iconSize: 36,
                            onPressed: (){
                              setState(() {
                                urlTB = 'https://www.facebook.com/gitamdeemeduniversity/';
                                launchURL();
                              });
                            },
                          ),
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.youtube, color: Color.fromRGBO(255,0,0,1),),
                            iconSize: 36,
                            onPressed: (){
                              setState(() {
                                urlTB = 'https://www.youtube.com/gitamdeemeduniversity';
                                launchURL();
                              });
                            },
                          ),
                          
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  _validateAndSubmit(BuildContext context){
      if(!_key.currentState.validate()){
          setState(() {
            _validate = true;
          });
      }
      else{
        progress(context);
        _checkLogin(userid,password);
      }
  }

  Widget progress(BuildContext context){
    pd = new ProgressDialog(context,type: ProgressDialogType.Normal);
      pd.style(
          message: 'Logging In...',
          borderRadius: 10.0,
          backgroundColor: Colors.white,
          progressWidget: CircularProgressIndicator(),
          elevation: 10.0,
          insetAnimCurve: Curves.easeInOut,
          progress: 0.0,
          maxProgress: 100.0,
          progressTextStyle: TextStyle(
              color: Colors.black, fontSize: 8.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(
              color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w600)
      );
      pd.show();
  }
List course,att;
    Future<String> _checkLogin(String uid, String pass) async{
    print("logging in");
    http.Response response = await http.post(Uri.encodeFull(url),
      body: {
        "user_id":uid,
        "password":pass
      }
    );
    Map<String, dynamic> user = jsonDecode(response.body);
    int status = user['status'];
    String message = user['message'];
    if(response.statusCode==200){
      print(status);
      if(status==1){
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString("user_id", uid);
        sharedPreferences.setString("password", pass);
        sharedPreferences.setString("user_name", user['user_name']);
        getCoursesData();
      }else{
        Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_LONG,gravity: ToastGravity.CENTER);
        pd.dismiss();
      }
    }else{
      Fluttertoast.showToast(msg: "Unable to Reach the Server", toastLength: Toast.LENGTH_LONG,gravity: ToastGravity.CENTER);
      pd.dismiss();
    }
  }

  Future<String> getCoursesData() async{
    final String url = 'http://3.6.138.40/GAtt/api/modules/test.php?/=getCourses';
    final String url1 = 'http://3.6.138.40/GAtt/api/modules/test.php?/=getTodayAtt';
    var sp = await SharedPreferences.getInstance();
    String uid = sp.getString("user_id");
    http.Response response = await http.post(Uri.encodeFull(url),
      body: {
        "user_id":uid
      }
    );
    http.Response response1 = await http.post(Uri.encodeFull(url1),
      body: {
        "user_id":uid
      }
    );
    Map<String, dynamic> user = jsonDecode(response.body);
    Map<String, dynamic> user1 = jsonDecode(response.body);
    setState(() {
      course = user['data'];
      att = user1['data'];
    });
    pd.dismiss();
    Navigator.pushReplacement(context,MaterialPageRoute(
            builder: (context) => Welcome(course: course,att: att),
          ),
        );
}

  launchURL() async{
  if (await canLaunch(urlTB)) {
    launch(urlTB);
  } else {
    print('Could not launch');
  }
}
}