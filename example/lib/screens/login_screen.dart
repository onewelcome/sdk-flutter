// @dart = 2.10
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/callbacks/onegini_registration_callback.dart';
import 'package:onegini/model/onegini_list_response.dart';
import 'package:onegini/model/registration_response.dart';
import 'package:onegini/onegini.dart';
import 'package:onegini/pigeon.dart';
import 'package:onegini_example/screens/user_screen.dart';

import '../components/display_toast.dart';

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
        showFlutterToast(error.message);
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
        showFlutterToast(error.message);
      }
    }
  }

  authenticateWithPreferredAuthenticator(String profileId) async {
    setState(() => {isLoading = true});
    var registrationResponse = await Onegini.instance.userClient
        .authenticateUser(context, profileId, null)
        .catchError((error) {
      setState(() => isLoading = false);
      if (error is PlatformException) {
        showFlutterToast(error.message);
      }
    });
    if (registrationResponse?.userProfile?.profileId != null)
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => UserScreen(
                    userProfileId: registrationResponse.userProfile.profileId,
                  )),
          (Route<dynamic> route) => false);
  }

  authenticateWithRegisteredAuthenticators(
      String registeredAuthenticatorId, String profileId) async {
    setState(() => {isLoading = true});
    // var result = await Onegini.instance.userClient.setPreferredAuthenticator(context, registeredAuthenticatorId);
    // print(result);

    var registrationResponse = await Onegini.instance.userClient
        .authenticateUser(context, profileId, registeredAuthenticatorId)
        .catchError((error) {
      setState(() => isLoading = false);
      if (error is PlatformException) {
        showFlutterToast(error.message);
      }
    });
    if (registrationResponse.userProfile?.profileId != null)
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => UserScreen(
                    userProfileId: registrationResponse.userProfile.profileId,
                  )),
          (Route<dynamic> route) => false);
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

  Future<List<UserProfile>> getUserProfiles() async {
    try {
      var userApi = UserClientApi();
      var derp = await userApi.fetchUserProfiles();
      print(derp[0].profileId);

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
      var userProfileId = await Onegini.instance.userClient
          .authenticateUserImplicitly(profileId, ["read"]);

      if (userProfileId != null) {
        var response = await Onegini.instance.resourcesMethods
            .getResourceImplicit("user-id-decorated");
        var res = json.decode(response);

        returnString = json.decode(res["body"])["decorated_user_id"];
      }

      return returnString;
    } catch (err) {
      print("Caught error: $err");
      return "Error occured check logs";
    }
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
                  FutureBuilder<List<UserProfile>>(
                      //userProfiles
                      future: getUserProfiles(),
                      builder: (context, userProfiles) {
                        return (userProfiles.hasData &&
                                userProfiles.data.length > 0)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    FutureBuilder<String>(
                                        //implicit
                                        future: getImplicitUserDetails(
                                            userProfiles.data.first?.profileId),
                                        builder:
                                            (context, implicitUserDetails) {
                                          return implicitUserDetails.hasData
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                      Text(
                                                        "──── Login ────",
                                                        style: TextStyle(
                                                            fontSize: 30),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        implicitUserDetails
                                                            .data,
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          authenticateWithPreferredAuthenticator(
                                                              userProfiles
                                                                  .data
                                                                  .first
                                                                  ?.profileId);
                                                        },
                                                        child: Text(
                                                            'Authenticate with preferred authenticator'),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      FutureBuilder<
                                                          List<
                                                              OneginiListResponse>>(
                                                        future: Onegini
                                                            .instance.userClient
                                                            .getRegisteredAuthenticators(
                                                                context,
                                                                userProfiles
                                                                    .data
                                                                    .first
                                                                    ?.profileId),
                                                        builder: (BuildContext
                                                                context,
                                                            registeredAuthenticators) {
                                                          return registeredAuthenticators
                                                                  .hasData
                                                              ? PopupMenuButton<
                                                                      String>(
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            20),
                                                                    color: Colors
                                                                        .blue,
                                                                    child: Text(
                                                                      "Authenticators",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                  ),
                                                                  onSelected:
                                                                      (value) {
                                                                    authenticateWithRegisteredAuthenticators(
                                                                        userProfiles
                                                                            .data
                                                                            .first
                                                                            ?.profileId,
                                                                        value);
                                                                  },
                                                                  itemBuilder:
                                                                      (context) {
                                                                    return registeredAuthenticators
                                                                        .data
                                                                        .map((e) =>
                                                                            PopupMenuItem<String>(
                                                                              child: Text(e.name ?? ""),
                                                                              value: e.id,
                                                                            ))
                                                                        .toList();
                                                                  })
                                                              : SizedBox
                                                                  .shrink();
                                                        },
                                                      )
                                                    ])
                                              : SizedBox.shrink();
                                        })
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
                  FutureBuilder<List<OneginiListResponse>>(
                    future: Onegini.instance.userClient
                        .getIdentityProviders(context),
                    builder: (BuildContext context, identityProviders) {
                      return identityProviders.hasData
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
                                return identityProviders.data
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
