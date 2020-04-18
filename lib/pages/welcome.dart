import 'package:G_Attendence/main.dart';
import 'package:G_Attendence/pages/att_detail.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'att_detail.dart';

class Welcome extends StatefulWidget {
  List course,att;
  Welcome({this.course, this.att});

  @override
  _WelcomeState createState() => _WelcomeState(course,att);
}

class _WelcomeState extends State<Welcome> {
  List course,att;
  _WelcomeState(this.course,this.att);
  var result,result1;
  bool perm,perm1;
  final PermissionHandler _permissionHandler = PermissionHandler();

  @override
  void initState() {
    checkPermissions();
    checkPermissions1();
    super.initState();
  }

  checkPermissions() async{
    var per = await _permissionHandler.checkPermissionStatus(PermissionGroup.storage);
    switch (per) {
    case PermissionStatus.granted:
      setState(() {
        perm = true;
      });
      break;
    case PermissionStatus.denied:
      result1 = await _permissionHandler.requestPermissions([PermissionGroup.camera]);
      result = await _permissionHandler.requestPermissions([PermissionGroup.storage]);
      break;
    case PermissionStatus.disabled:
      result = await _permissionHandler.requestPermissions([PermissionGroup.storage]);
      break;
    case PermissionStatus.restricted:
      result = await _permissionHandler.requestPermissions([PermissionGroup.storage]);
      break;
    case PermissionStatus.unknown:
      result = await _permissionHandler.requestPermissions([PermissionGroup.storage]);
      break;
  }
  
  }
  checkPermissions1() async{
    var per1 = await _permissionHandler.checkPermissionStatus(PermissionGroup.camera);
    switch (per1) {
        case PermissionStatus.granted:
          setState(() {
            perm = true;
          });
          break;
        case PermissionStatus.denied:
          break;
        case PermissionStatus.disabled:
          result1 = await _permissionHandler.requestPermissions([PermissionGroup.camera]);
          break;
        case PermissionStatus.restricted:
          result1 = await _permissionHandler.requestPermissions([PermissionGroup.camera]);
          break;
        case PermissionStatus.unknown:
          result1 = await _permissionHandler.requestPermissions([PermissionGroup.camera]);
          break;
      }
  }
  
  void _logout() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("user_id", null);
    sharedPreferences.setString("password", null);
  }


  double screen_width,screen_height;
  @override
  Widget build(BuildContext context) {
    screen_width = MediaQuery.of(context).size.width;
    screen_height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("G-Attendence"),
        backgroundColor: Color.fromRGBO(76, 90, 142, 1),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app, color: Colors.white,),
              onPressed: (){
                _logout();
                 Navigator. pushReplacement(context,MaterialPageRoute(
                    builder: (context) => MyApp(),
                  ),
                );
              },
            )
        ],
      ),
      body: new Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: screen_width/35, left: screen_width/35, right: screen_width/35, bottom: 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Card(
                elevation: 5,
                child: _Courses(),
              ),
              Card(
                elevation: 5,
                child: _Attendence(),
              )
            ],
          ),
        ),
        ),
    );
  }

  Widget _Attendence(){
    return ConfigurableExpansionTile(
                headerBackgroundColorStart: Color.fromRGBO(76, 90, 142, 1),
                expandedBackgroundColor: Colors.white,
                initiallyExpanded: false,
                headerBackgroundColorEnd: Color.fromRGBO(76, 90, 142, 1),
                kExpand: Duration(milliseconds: 500),
                animatedWidgetFollowingHeader: Container(
                  height: screen_height/15,
                  child: const Icon(
                  Icons.expand_more,
                  color: Colors.white,
                  textDirection: TextDirection.rtl,
                ),
                ),
                headerExpanded: Container(
                  alignment: Alignment.topRight,
                  child: Text("Today's Attendence",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.white,fontSize: 20
                  ),),
                ),
                header: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text("Today's Attendence",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                        ),
                      ),
                    )
                  ],
                ),
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 5,right: 5, bottom: 15, top: 15),
                    child: Column(
                      children: <Widget>[
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: att.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context,index){
                            return Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context){
                                      return Att_detail();
                                    }));
                                    // checkPermissions();
                                    // checkPermissions1();
                                    // showAlertDialog(context, att[index]['course_id']+" / "+att[index]['branch']+" / SEC: "+att[index]['sec']);
                                    },
                                    child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Color.fromRGBO(141, 141, 141, 1)),
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight:  Radius.circular(10)),
                                      color: Color.fromRGBO(218, 226, 255, 1),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.only(left: 10, right: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(att[index]['course_id'], style: TextStyle(color: Color.fromRGBO(76, 90, 142, 1), fontSize: 24),),
                                          Text(att[index]['subj'],
                                          style: TextStyle(
                                            color: Color.fromRGBO(76, 90, 142, 1),
                                            fontSize: 16),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text("VSP",
                                              style: TextStyle(
                                                color: Color.fromRGBO(76, 90, 142, 1),
                                                fontSize: 16
                                                )),
                                              Container(
                                                width: 10,
                                                alignment: Alignment.center,
                                                child: Text("|", style: TextStyle(fontSize: 22),),
                                              ),
                                              Text("GIT",
                                              style: TextStyle(
                                                color: Color.fromRGBO(76, 90, 142, 1),
                                                fontSize: 16
                                                )),
                                              Container(
                                                width: 10,
                                                alignment: Alignment.center,
                                                child: Text("|", style: TextStyle(fontSize: 22),),
                                              ),
                                              Text(att[index]['branch'],
                                              style: TextStyle(
                                                color: Color.fromRGBO(76, 90, 142, 1),
                                                fontSize: 16
                                                )),
                                              Container(
                                                width: 10,
                                                alignment: Alignment.center,
                                                child: Text("|", style: TextStyle(fontSize: 22),),
                                              ),
                                              Text("Sem/Tri-"+att[index]['sem'],
                                              style: TextStyle(
                                                color: Color.fromRGBO(76, 90, 142, 1),
                                                fontSize: 16
                                                )),
                                              Container(
                                                width: 10,
                                                alignment: Alignment.center,
                                                child: Text("|", style: TextStyle(fontSize: 22),),
                                              ),
                                              Text(att[index]['year'],
                                              style: TextStyle(
                                                color: Color.fromRGBO(76, 90, 142, 1),
                                                fontSize: 16
                                                )),
                                              Container(
                                                width: 10,
                                                alignment: Alignment.center,
                                                child: Text("|", style: TextStyle(fontSize: 22),),
                                              ),
                                              Text("Sec-"+att[index]['sec'],
                                              style: TextStyle(
                                                color: Color.fromRGBO(76, 90, 142, 1),
                                                fontSize: 16
                                                )),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                )
                              ],
                            );
                          }
                        )
                      ],
                    ),
                  )
                ],
              );
  }
// showAlertDialog(BuildContext context, String cId){
//   return showDialog(
//     context: context,
//     builder: (BuildContext context){
//       return AlertDialog(
//         backgroundColor: Colors.transparent,
//         content: Wrap(
//           children: <Widget>[
//             Container(
//               padding: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(15)),
//                 color: Color.fromRGBO(191, 221, 255, 0.8)
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Text("Choose From", style: TextStyle(color: Color.fromRGBO(76, 90, 142, 1)),),
//                   Center(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: <Widget>[
//                         InkWell(
//                           onTap: () => openGallery(),
//                           child: Card(
//                             elevation: 3,
//                             child: Padding(
//                               padding: EdgeInsets.all(15),
//                               child: Icon(
//                                 Icons.photo_library, color: Color.fromRGBO(76, 90, 142, 1),size: 30,
//                                 )
//                                 ),
//                               shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(50.0)
//                             ),
//                           ),
//                         ),
//                         Text("Or",style: TextStyle(fontWeight: FontWeight.w700, color: Color.fromRGBO(76, 90, 142, 1)),),
//                         InkWell(
//                           onTap: (){},
//                           child: Card(
//                             elevation: 3,
//                             child: Padding(
//                               padding: EdgeInsets.all(15),
//                               child: Icon(
//                                 Icons.camera_alt, color: Color.fromRGBO(76, 90, 142, 1),size: 30,
//                                 )
//                                 ),
//                               shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(50.0)
//                             ),
//                           ),
//                         )
//                       ],
//                     )
//                   ),
//                   Text("Class: '' "+cId+" ''", style: TextStyle(color: Color.fromRGBO(76, 90, 142, 1), fontWeight: FontWeight.w700),)
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//   );
// }
// var Image;
// openGallery() async{
//   var resultList = await MultiImagePicker.pickImages(
//       maxImages :  10 ,
//       enableCamera: true,
//     );
    
//     // The data selected here comes back in the list
//     print(resultList);
//     if(resultList!=null){
//       for ( var imageFile in resultList) {
//          setState(() {
//             Image = imageFile;
//           });
//       }
//     }
//     print(Image);
// }

  Widget _Courses(){
    return ConfigurableExpansionTile(
                headerBackgroundColorStart: Color.fromRGBO(76, 90, 142, 1),
                expandedBackgroundColor: Colors.white,
                initiallyExpanded: true,
                headerBackgroundColorEnd: Color.fromRGBO(76, 90, 142, 1),
                kExpand: Duration(milliseconds: 500),
                animatedWidgetFollowingHeader: Container(
                  height: screen_height/15,
                  child: const Icon(
                  Icons.expand_more,
                  color: Colors.white,
                  textDirection: TextDirection.rtl,
                ),
                ),
                headerExpanded: Container(
                  alignment: Alignment.topRight,
                  child: Text("Courses",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.white,fontSize: 20
                  ),),
                ),
                header: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text("Courses",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                        ),
                      ),
                    )
                  ],
                ),
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 5,right: 5, bottom: 15, top: 15),
                    child: Column(
                      children: <Widget>[
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: course.length,
                          itemBuilder: (context,index){
                            return Column(
                                    children: <Widget>[
                                      Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Color.fromRGBO(141, 141, 141, 1)),
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight:  Radius.circular(10)),
                                      color: Color.fromRGBO(218, 226, 255, 1),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.only(left: 10, right: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,

                                        children: <Widget>[

                                          Text(course[index]['course_id'], style: TextStyle(color: Color.fromRGBO(76, 90, 142, 1), fontSize: 24),),
                                          Text(course[index]['subj'],
                                          style: TextStyle(
                                            color: Color.fromRGBO(76, 90, 142, 1),
                                            fontSize: 16),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text("VSP",
                                              style: TextStyle(
                                                color: Color.fromRGBO(76, 90, 142, 1),
                                                fontSize: 16
                                                )),
                                              Container(
                                                width: 10,
                                                alignment: Alignment.center,
                                                child: Text("|", style: TextStyle(fontSize: 22),),
                                              ),
                                              Text("GIT",
                                              style: TextStyle(
                                                color: Color.fromRGBO(76, 90, 142, 1),
                                                fontSize: 16
                                                )),
                                              Container(
                                                width: 10,
                                                alignment: Alignment.center,
                                                child: Text("|", style: TextStyle(fontSize: 22),),
                                              ),
                                              Text(course[index]['branch'],
                                              style: TextStyle(
                                                color: Color.fromRGBO(76, 90, 142, 1),
                                                fontSize: 16
                                                )),
                                              Container(
                                                width: 10,
                                                alignment: Alignment.center,
                                                child: Text("|", style: TextStyle(fontSize: 22),),
                                              ),
                                              Text("Sem/Tri-"+course[index]['sem'],
                                              style: TextStyle(
                                                color: Color.fromRGBO(76, 90, 142, 1),
                                                fontSize: 16
                                                )),
                                              Container(
                                                width: 10,
                                                alignment: Alignment.center,
                                                child: Text("|", style: TextStyle(fontSize: 22),),
                                              ),
                                              Text(course[index]['year'],
                                              style: TextStyle(
                                                color: Color.fromRGBO(76, 90, 142, 1),
                                                fontSize: 16
                                                )),
                                              Container(
                                                width: 10,
                                                alignment: Alignment.center,
                                                child: Text("|", style: TextStyle(fontSize: 22),),
                                              ),
                                              Text("Sec-"+course[index]['sec'],
                                              style: TextStyle(
                                                color: Color.fromRGBO(76, 90, 142, 1),
                                                fontSize: 16
                                                )),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                              ],
                            );
                          }),
                      ],
                    )
                  )
                ],
              );
  }
}

