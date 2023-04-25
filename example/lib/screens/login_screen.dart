import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/callbacks/onegini_registration_callback.dart';
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini/model/request_details.dart';
import 'package:onegini/onegini.dart';
import 'package:onegini/pigeon.dart';
import 'package:onegini_example/ow_broadcast_helper.dart';
import 'package:onegini_example/screens/user_screen.dart';

import '../components/display_toast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  List<StreamSubscription<OWEvent>>? registrationSubscriptions;
  List<StreamSubscription<OWEvent>>? authenticationSubscriptions;

  @override
  initState() {
    // Init subscriptipons for registration and authentication
    this.registrationSubscriptions =
        OWBroadcastHelper.initRegistrationSubscriptions(context);
    this.authenticationSubscriptions =
        OWBroadcastHelper.initAuthenticationSubscriptions(context);

    super.initState();
  }

  @override
  void dispose() {
    OWBroadcastHelper.stopListening(registrationSubscriptions);
    OWBroadcastHelper.stopListening(authenticationSubscriptions);

    super.dispose();
  }

  openWeb() async {
    /// Start registration
    setState(() => {isLoading = true});

    try {
      var registrationResponse = await Onegini.instance.userClient.registerUser(
        null,
        ["read"],
      );

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
        showFlutterToast(error.message);
      }
    }
  }

  registrationWithIdentityProvider(String identityProviderId) async {
    setState(() => {isLoading = true});
    try {
      var registrationResponse = await Onegini.instance.userClient.registerUser(
        identityProviderId,
        ["read"],
      );

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
        showFlutterToast(error.message);
      }
    }
  }

  authenticate(String profileId, OWAuthenticatorType? authenticatorType) async {
    try {
      var registrationResponse = await Onegini.instance.userClient
          .authenticateUser(profileId, authenticatorType);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => UserScreen(
                    userProfileId: registrationResponse.userProfile.profileId,
                  )),
          (Route<dynamic> route) => false);
    } catch (error) {
      if (error is PlatformException) {
        showFlutterToast(error.message);
      }
    }
  }

  cancelRegistration() async {
    setState(() => isLoading = false);

    await OneginiRegistrationCallback()
        .cancelBrowserRegistration()
        .catchError((error) {
      if (error is PlatformException) {
        showFlutterToast(error.message);
      }
    });
  }

  Future<List<OWUserProfile>> getUserProfiles() async {
    try {
      var profiles = await Onegini.instance.userClient.getUserProfiles();
      return profiles;
    } catch (err) {
      print("caught error in getUserProfiles: $err");
      return [];
    }
  }

  Future<String> getImplicitUserDetails(String profileId) async {
    var returnString = "";
    try {
      await Onegini.instance.userClient
          .authenticateUserImplicitly(profileId, ["read"]);
      var response = await Onegini.instance.resourcesMethods.requestResource(
          ResourceRequestType.implicit,
          RequestDetails(
              path: "user-id-decorated", method: HttpRequestMethod.get));

      var res = json.decode(response.body);

      returnString = res["decorated_user_id"];

      return returnString;
    } catch (err) {
      print("Caught error: $err");
      return "Error occured check logs";
    }
  }

  Widget _buildImplicitUserData(String profileId) {
    return FutureBuilder<String>(
        future: getImplicitUserDetails(profileId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text("${snapshot.data}");
          } else if (snapshot.hasError) {
            return Text("Error getting implicit details.");
          }
          return CircularProgressIndicator();
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
                  SizedBox(
                    height: 20,
                  ),
                  FutureBuilder<List<OWUserProfile>>(
                      //userProfiles
                      future: getUserProfiles(),
                      builder: (context, snapshot) {
                        final userProfileData = snapshot.data;
                        return (userProfileData != null &&
                                userProfileData.length > 0)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Text(
                                      "──── Login ────",
                                      style: TextStyle(fontSize: 30),
                                      textAlign: TextAlign.center,
                                    ),
                                    _buildImplicitUserData(
                                        userProfileData.first.profileId),
                                    ElevatedButton(
                                      onPressed: () {
                                        authenticate(
                                            userProfileData.first.profileId,
                                            null);
                                      },
                                      child: Text('Preferred authenticator'),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            authenticate(
                                                userProfileData.first.profileId,
                                                OWAuthenticatorType.pin);
                                          },
                                          child: Text('Pin'),
                                        ),
                                        SizedBox(height: 10, width: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            authenticate(
                                                userProfileData.first.profileId,
                                                OWAuthenticatorType.biometric);
                                          },
                                          child: Text('Biometrics'),
                                        ),
                                      ],
                                    ),
                                  ])
                            : SizedBox.shrink();
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "──── Register ────",
                    style: TextStyle(fontSize: 30),
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
                  FutureBuilder<List<OWIdentityProvider>>(
                    future: Onegini.instance.userClient.getIdentityProviders(),
                    builder: (BuildContext context, snapshot) {
                      final identityProviders = snapshot.data;
                      return identityProviders != null
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
                                return identityProviders
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
