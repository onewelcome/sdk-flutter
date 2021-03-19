// @dart = 2.10
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onegini/onegini.dart';
import 'package:onegini_example/screens/login_screen.dart';

import 'onegini_listener.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onegini test app',
      home: Scaffold(
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
          child: BodyWidget(),
        ),
      ),
    );
  }
}

class BodyWidget extends StatefulWidget {
  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  var _appStarted = false;
  var appError;

  @override
  void initState() {
    _startApplication();
    super.initState();
  }

  void _startApplication() async {
    /// init Onegini sdk on native side
    var removedUserProfiles = await Onegini.instance.startApplication(OneginiListener()).catchError((error) {
      if (error is PlatformException) {
        Fluttertoast.showToast(
            msg: error.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black38,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
    _appStarted = removedUserProfiles!=null;
    if (_appStarted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator();
  }
}
