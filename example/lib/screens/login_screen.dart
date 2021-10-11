// @dart = 2.10
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onegini/callbacks/onegini_registration_callback.dart';
import 'package:onegini/model/onegini_list_response.dart';
import 'package:onegini/onegini.dart';
import 'package:onegini_example/screens/user_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  @override
  initState() {
    super.initState();
  }

  openWeb() async {
    /// Start registration
    setState(() => {isLoading = true});
    try {
      var registrationResponse = await Onegini.instance.userClient.registerUser(
        context,
        null,
        ["read"],
      );

      if (registrationResponse.userProfile.profileId != null)
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => UserScreen(
                      userProfileId: registrationResponse.userProfile.profileId,
                    )),
            (Route<dynamic> route) => false);
    } catch (error) {
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
    }
  }

  registrationWithIdentityProvider(String identityProviderId) async {
    setState(() => {isLoading = true});
    try {
      var registrationResponse = await Onegini.instance.userClient.registerUser(
        context,
        identityProviderId,
        ["read"],
      );
      if (registrationResponse.userProfile.profileId != null)
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => UserScreen(
                      userProfileId: registrationResponse.userProfile.profileId,
                    )),
            (Route<dynamic> route) => false);
    } catch (error) {
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
    }
  }

  preferredAuthentication() async {
    setState(() => {isLoading = true});
    var response = await Onegini.instance.userClient
        .authenticateUser(
      context,
      null,
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
    if (response.userProfile != null)
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => UserScreen(
                    userProfileId: response.userProfile.profileId,
                  )),
          (Route<dynamic> route) => false);
  }

  authenticateWithRegisteredAuthenticators(
      String registeredAuthenticatorId) async {
    setState(() => {isLoading = true});
    // var result = await Onegini.instance.userClient.setPreferredAuthenticator(context, registeredAuthenticatorId);
    // print(result);

    var response = await Onegini.instance.userClient
        .authenticateUser(context, registeredAuthenticatorId)
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
    if (response.userProfile != null)
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => UserScreen(
                    userProfileId: response.userProfile.profileId,
                  )),
          (Route<dynamic> route) => false);
  }

  cancelRegistration() async {
    setState(() => isLoading = false);

    await OneginiRegistrationCallback()
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
                      cancelRegistration();
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
                      preferredAuthentication();
                    },
                    child: Text('Authenticate with preferred authenticator'),
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
