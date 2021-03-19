// @dart = 2.10
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onegini/callbacks/onegini_pin_authentication_callback.dart';
import 'package:onegini/callbacks/onegini_registration_callback.dart';
import 'package:onegini/model/onegini_identity_provider.dart';
import 'package:onegini/onegini.dart';
import 'package:onegini_example/constants.dart';
import 'package:onegini_example/models/event.dart';
import 'package:onegini_example/screens/otp_screen.dart';
import 'package:onegini_example/screens/user_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  EventChannel _eventChannel = const EventChannel("exemple_events");
  bool isLoading = false;
  bool isRegistrationFlow = false;

  @override
  initState() {
    _eventChannel.receiveBroadcastStream("exemple_events").listen((str) {
      Event event = eventFromJson(str);
      if (event.eventName == "OPEN_OTP") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtpScreen(
                    password: event.eventValue,
                  )),
        );
      }
    });
    super.initState();
  }

  openWeb() async {
    /// Start registration
    setState(() => {isLoading = true, isRegistrationFlow = true});
    var userId = await Onegini.instance.userClient
        .registerUser(
            context,
            null,
            Constants.DEFAULT_SCOPES,)
        .catchError((error) {
      setState(() => isLoading = false);
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
    if (userId != null)
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => UserScreen(
                    userProfileId: userId,
                  )),
          (Route<dynamic> route) => false);
  }

  registrationWithIdentityProvider(String identityProviderId) async {
    setState(() => {isLoading = true, isRegistrationFlow = true});
    var userId = await Onegini.instance.userClient
        .registerUser(
            context,
            identityProviderId,
            Constants.DEFAULT_SCOPES,
            )
        .catchError((error) {
      setState(() => isLoading = false);
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
    if (userId != null)
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => UserScreen(
                    userProfileId: userId,
                  )),
          (Route<dynamic> route) => false);
  }

  pinAuthentication() async {
    setState(() => {isLoading = true, isRegistrationFlow = false});
    var userId = await Onegini.instance.userClient
        .authenticateUser(
            context,
            null,)
        .catchError((error) {
      setState(() => isLoading = false);
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
    if (userId != null)
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => UserScreen(
                    userProfileId: userId,
                  )),
          (Route<dynamic> route) => false);
  }

  authenticateWithRegisteredAuthenticators(
      String registeredAuthenticatorId) async {
    setState(() => {isLoading = true, isRegistrationFlow = false});
    var userId = await Onegini.instance.userClient
        .authenticateUser(context, registeredAuthenticatorId).catchError((error) {
      setState(() => isLoading = false);
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
    if (userId != null)
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => UserScreen(
                    userProfileId: userId,
                  )),
          (Route<dynamic> route) => false);
  }

  cancelRegistration() async {
    setState(() => isLoading = false);
    OneginiRegistrationCallback()
        .cancelRegistration()
        .catchError((error) {
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
  }

  cancelAuth() async {
    setState(() => isLoading = false);
     OneginiPinAuthenticationCallback()
        .denyAuthenticationRequest()
        .catchError((error) {
      setState(() => isLoading = false);
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
      body: isLoading
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      isRegistrationFlow ? cancelRegistration() : cancelAuth();
                    },
                    child: Text('Cancel'),
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      pinAuthentication();
                    },
                    child: Text('Authenticate with PIN'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FutureBuilder<List<OneginiListResponse>>(
                    future: Onegini.instance.userClient
                        .getRegisteredAuthenticators(context),
                    builder: (BuildContext context, snapshot) {
                      return snapshot.hasData
                          ? PopupMenuButton<String>(
                              child: Container(
                                padding: EdgeInsets.all(20),
                                color: Colors.blue,
                                child: Text(
                                  "Authenticators",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              onSelected: (value) {
                                authenticateWithRegisteredAuthenticators(value);
                              },
                              itemBuilder: (context) {
                                return snapshot.data
                                    .map((e) => PopupMenuItem<String>(
                                          child: Text(e.name ?? ""),
                                          value: e.id,
                                        ))
                                    .toList();
                              })
                          : SizedBox.shrink();
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      openWeb();
                    },
                    child: Text('Run WEB'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FutureBuilder<List<OneginiListResponse>>(
                    future: Onegini.instance.userClient
                        .getIdentityProviders(context),
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
                                          child: Text(e.name ?? ""),
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
