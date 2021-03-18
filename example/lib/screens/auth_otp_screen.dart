// @dart = 2.10
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onegini/callbacks/onegini_otp_accept_deny_callback.dart';



class AuthOtpScreen extends StatefulWidget {
  final String message;

  const AuthOtpScreen({Key key, this.message}) : super(key: key);

  @override
  _AuthOtpScreenState createState() => _AuthOtpScreenState();
}

class _AuthOtpScreenState extends State<AuthOtpScreen> {

  accept(BuildContext context) async {
    OneginiOtpAcceptDenyCallback().acceptAuthenticationRequest(context).catchError((error){
      if(error is PlatformException) {
        Fluttertoast.showToast(
            msg: error.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black38,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    });
  }

  deny(BuildContext context) async {
    OneginiOtpAcceptDenyCallback().acceptAuthenticationRequest(context).catchError((error){
      if(error is PlatformException) {
        Fluttertoast.showToast(
            msg: error.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black38,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.asset(
            "assets/logo_onegini.png",
            width: 200,
            height: 50,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30,),
            Text(widget.message,style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {
                  deny(context);
                }, child: Text("DENY"),

                ),
                ElevatedButton(onPressed: () {
                  accept(context);
                }, child: Text("ACCEPT")),
              ],)
          ],
        ),
      ),
    );
  }
}
