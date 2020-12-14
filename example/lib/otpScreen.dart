import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini_example/loginScreen.dart';

class OtpScreen extends StatefulWidget {
  final String password;

  const OtpScreen({Key key, this.password}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final MethodChannel _channel = const MethodChannel('example');
  final myController = TextEditingController();

  ok() async {
  _channel.invokeMethod("otpOk", <String, String>{
      'password': myController.text,
    });

  }

  cancel() async {
    _channel.invokeMethod("otpCancel");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginScreen()),
    );
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
            Text("Enter the Code",style: TextStyle(fontSize: 24),),
            SizedBox(height: 30,),
            Text(widget.password,style: TextStyle(fontSize: 30),),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                controller: myController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              ElevatedButton(onPressed: () {
                cancel();
              }, child: Text("Cancel"),

              ),
              ElevatedButton(onPressed: () {
                ok();
              }, child: Text("Ok")),
            ],)
          ],
        ),
      ),
    );
  }
}
