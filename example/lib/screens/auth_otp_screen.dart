// @dart = 2.10
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onegini/callbacks/onegini_otp_accept_deny_callback.dart';
import 'package:onegini/onegini.dart';
import '../components/display_toast.dart';

class AuthOtpScreen extends StatefulWidget {
  final String message;

  const AuthOtpScreen({Key key, this.message}) : super(key: key);

  @override
  _AuthOtpScreenState createState() => _AuthOtpScreenState();
}

class _AuthOtpScreenState extends State<AuthOtpScreen> {
  accept(BuildContext context) async {
    Onegini.instance.setEventContext(context);
    OneginiOtpAcceptDenyCallback()
        .acceptAuthenticationRequest(context)
        .catchError((error) {
      if (error is PlatformException) {
        showFlutterToast(error.message);
      }
    });
  }

  deny(BuildContext context) async {
    OneginiOtpAcceptDenyCallback()
        .denyAuthenticationRequest()
        .catchError((error) {
      if (error is PlatformException) {
        showFlutterToast(error.message);
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
            SizedBox(
              height: 30,
            ),
            Text(
              widget.message,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    deny(context);
                  },
                  child: Text("DENY"),
                ),
                ElevatedButton(
                    onPressed: () {
                      accept(context);
                    },
                    child: Text("ACCEPT")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
