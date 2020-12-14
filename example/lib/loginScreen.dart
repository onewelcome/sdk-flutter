import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/model/Provider.dart';
import 'package:onegini/onegini.dart';
import 'package:onegini_example/otpScreen.dart';
import 'package:onegini_example/user_screen.dart';

import 'event.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  EventChannel _eventChannel = const EventChannel("exemple_events");
  @override
  initState(){
    _eventChannel.receiveBroadcastStream().listen((str){
      Event event  = eventFromJson(str);
      if(event.key == "OPEN_OTP"){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtpScreen(
                password: event.value,
              )),
        );
      }
    });
    super.initState();
  }

  openWeb() async {
    /// Start registration
    var userId = await Onegini.registration(context)
        .catchError((error) => print(error.toString()));
    if (userId != null)
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => UserScreen(
                    userProfileId: userId,
                  )),(Route<dynamic> route) => false
        );

  }

  registrationWithIdentityProvider(String identityProviderId) async {
    var userId = await Onegini.registrationWithIdentityProvider(identityProviderId)
        .catchError((error) => print(error.toString()));
    if (userId != null)
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => UserScreen(
                userProfileId: userId,
              )),(Route<dynamic> route) => false
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                openWeb();
              },
              child: Text('Run WEB'),
            ),
            SizedBox(
              height: 20,
            ),
            FutureBuilder<List<Provider>>(
              future: Onegini.getIdentityProviders(context),
              builder: (BuildContext context, snapshot) {
                return snapshot.hasData
                    ? PopupMenuButton<String>(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          color: Colors.blue,
                          child: Text(
                            "Run with providers",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        onSelected: (value) {
                          registrationWithIdentityProvider(value);
                        },
                        itemBuilder: (context) {
                          return snapshot.data
                              .map((e) => PopupMenuItem<String>(
                                    child: Text(e.name),
                                    value: e.id,
                                  ))
                              .toList();
                        })
                    : SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
