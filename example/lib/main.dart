import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onegini/onegini.dart';

import 'loginScreen.dart';


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
    _appStarted = await Onegini.startApplication().catchError((error) => appError = error
    );
    if(_appStarted){
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

