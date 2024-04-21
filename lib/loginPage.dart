import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/registration.dart';
import 'package:flutter_todo_app/screens/map_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var reqBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      var response = await http.post(Uri.parse(login),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody)
      );

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        var myToken = jsonResponse['token'];
        prefs.setString('token', myToken);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MapScreen(token: myToken)));
      } else {
        print('Something went wrong');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                  child: Text(
                    'LOGIN',
                    style:
                    TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(260.0, 125.0, 0.0, 0.0),
                  child: Text(
                    '.',
                    style: TextStyle(
                        fontSize: 80.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                )
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'EMAIL',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        // hintText: 'EMAIL',
                        // hintStyle: ,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'PASSWORD ',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                    obscureText: true,
                  ),
                  SizedBox(height: 10.0),
                  // TextField(
                  //   decoration: InputDecoration(
                  //       labelText: 'USER NAME ',
                  //       labelStyle: TextStyle(
                  //           fontFamily: 'Montserrat',
                  //           fontWeight: FontWeight.bold,
                  //           color: Colors.grey),
                  //       focusedBorder: UnderlineInputBorder(
                  //           borderSide: BorderSide(color: Colors.green))),
                  // ),
                  SizedBox(height: 50.0),
                  Container(
                      height: 40.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.greenAccent,
                        color: Colors.green,
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: ()=>{
                            loginUser()
                          },
                          // onTap: () {},
                          child: Center(
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(height: 20.0),
                  Container(
                    height: 40.0,
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 1.0),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()
                          ),
                          );
                        },
                        child:

                        Center(
                          child: Text('SIGN UP',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat')),
                        ),


                      ),
                    ),
                  ),
                ],
              )),
          // SizedBox(height: 15.0),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     Text(
          //       'New to Spotify?',
          //       style: TextStyle(
          //         fontFamily: 'Montserrat',
          //       ),
          //     ),
          //     SizedBox(width: 5.0),
          //     InkWell(
          //       child: Text('Register',
          //           style: TextStyle(
          //               color: Colors.green,
          //               fontFamily: 'Montserrat',
          //               fontWeight: FontWeight.bold,
          //               decoration: TextDecoration.underline)),
          //     )
          //   ],
          // )
        ]));
  }
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //     child: Scaffold(
  //       body: Container(
  //         width: MediaQuery
  //             .of(context)
  //             .size
  //             .width,
  //         height: MediaQuery
  //             .of(context)
  //             .size
  //             .height,
  //         decoration: BoxDecoration(
  //           gradient: LinearGradient(
  //               colors: [const Color(0xFFFFFFFF), const Color(0xFF93E173)],
  //               // colors: [const Color(0XFFF95A3B),const Color(0XFFF96713)],
  //               begin: FractionalOffset.topLeft,
  //               end: FractionalOffset.bottomCenter,
  //               stops: [0.0, 0.8],
  //               tileMode: TileMode.mirror
  //           ),
  //         ),
  //         child: Center(
  //           child: SingleChildScrollView(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: <Widget>[
  //                 CommonLogo(),
  //                 HeightBox(10),
  //                 "Email Sign-In".text
  //                     .size(22)
  //                     .black
  //                     .make(),
  //
  //                 TextField(
  //                   controller: emailController,
  //                   keyboardType: TextInputType.text,
  //                   decoration: InputDecoration(
  //                       filled: true,
  //                       fillColor: Colors.white,
  //                       hintText: "Email",
  //                       errorText: _isNotValidate ? "Enter Proper Info" : null,
  //                       border: OutlineInputBorder(
  //                           borderRadius: BorderRadius.all(
  //                               Radius.circular(20.0)))),
  //                 ).p4().px24(),
  //                 TextField(
  //                   controller: passwordController,
  //                   keyboardType: TextInputType.text,
  //                   decoration: InputDecoration(
  //                       filled: true,
  //                       fillColor: Colors.white,
  //                       hintText: "Password",
  //                       errorText: _isNotValidate ? "Enter Proper Info" : null,
  //                       border: OutlineInputBorder(
  //                           borderRadius: BorderRadius.all(
  //                               Radius.circular(20.0)))),
  //                 ).p4().px24(),
  //                 GestureDetector(
  //                   onTap: () {
  //                     loginUser();
  //                   },
  //                   child: HStack([
  //                     VxBox(child: "LogIn".text.white.makeCentered().p16())
  //                         .green600.roundedLg.make(),
  //                   ]),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //       bottomNavigationBar: GestureDetector(
  //         onTap: () {
  //           Navigator.push(context,
  //               MaterialPageRoute(builder: (context) => Registration()));
  //         },
  //         child: Container(
  //             height: 25,
  //             color: Colors.lightBlue,
  //             child: Center(child: "Create a new Account..! Sign Up".text.white
  //                 .makeCentered())),
  //       ),
  //     ),
  //   );
  // }
}