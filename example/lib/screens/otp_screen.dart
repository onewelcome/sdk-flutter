// @dart = 2.10
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/callbacks/onegini_custom_registration_callback.dart';
import 'package:onegini_example/components/display_toast.dart';

import 'login_screen.dart';

class OtpScreen extends StatefulWidget {
  final String password;
  final String providerId;

  const OtpScreen({Key key, this.password, this.providerId}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final myController = TextEditingController();

  ok() async {
    if (myController.text.isNotEmpty) {
      OneginiCustomRegistrationCallback()
          .submitSuccessAction(myController.text ?? " ")
          .catchError((error) => {
                if (error is PlatformException)
                  {showFlutterToast(error.message)}
              });
    } else {
      showFlutterToast("Enter code");
    }
  }

  cancel() async {
    OneginiCustomRegistrationCallback()
        .submitErrorAction("Registration canceled")
        .catchError((error) {
      if (error is PlatformException) {
        showFlutterToast(error.message);
      }
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await cancel();
        return true;
      },
      child: Scaffold(
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
              Text(
                "Enter the Code",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                widget.password,
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: myController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      cancel();
                    },
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        ok();
                      },
                      child: Text("Ok")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
