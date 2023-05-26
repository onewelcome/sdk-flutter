import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/callbacks/onegini_custom_registration_callback.dart';
import 'package:onegini/callbacks/onegini_registration_callback.dart';
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini/model/request_details.dart';
import 'package:onegini/onegini.dart';
import 'package:onegini/onegini.gen.dart';
import 'package:onegini_example/ow_broadcast_helper.dart';
import 'package:onegini_example/screens/user_screen.dart';
import 'package:collection/collection.dart';

import '../components/display_toast.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
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
    setState(() => isLoading = true);

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
    setState(() => isLoading = true);
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

  cancelRegistration() async {
    setState(() => isLoading = false);
    try {
      await Future.any([
        OneginiRegistrationCallback().cancelBrowserRegistration(),
        OneginiCustomRegistrationCallback().submitErrorAction('Canceled')
      ]);
    } on PlatformException catch (error) {
      showFlutterToast(error.message);
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
              child: _buildCancelRegistrationWidget(),
            )
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  LoginSection(),
                  SizedBox(height: 20),
                  _buildRegisterWidget(),
                ],
              ),
            ),
    );
  }

  Column _buildRegisterWidget() {
    return Column(
      children: [
        Text(
          "──── Register ────",
          style: TextStyle(fontSize: 30),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            openWeb();
          },
          child: Text('Run WEB'),
        ),
        SizedBox(height: 20),
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
    );
  }

  Column _buildCancelRegistrationWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            cancelRegistration();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}

class LoginSection extends StatefulWidget {
  @override
  _LoginSectionState createState() => _LoginSectionState();
}

class _LoginSectionState extends State<LoginSection> {
  List<OWUserProfile> userProfiles = [];
  String? selectedProfileId;

  @override
  initState() {
    super.initState();
    fetchUserProfiles();
  }

  @override
  Widget build(BuildContext context) {
    final _selectedProfileId = selectedProfileId;
    return (userProfiles.length > 0 && _selectedProfileId != null)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Text(
                  "──── Login ────",
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                _buildSelectUserProfile(userProfiles),
                _buildImplicitUserData(_selectedProfileId),
                ElevatedButton(
                  onPressed: () {
                    authenticate(_selectedProfileId, null);
                  },
                  child: Text('Preferred authenticator'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        authenticate(
                            _selectedProfileId, OWAuthenticatorType.pin);
                      },
                      child: Text('Pin'),
                    ),
                    SizedBox(height: 10, width: 10),
                    ElevatedButton(
                      onPressed: () {
                        authenticate(
                            _selectedProfileId, OWAuthenticatorType.biometric);
                      },
                      child: Text('Biometrics'),
                    ),
                  ],
                ),
              ])
        : SizedBox.shrink();
  }

  DropdownButton _buildSelectUserProfile(List<OWUserProfile> profiles) {
    return DropdownButton(
        value: selectedProfileId,
        items: profiles
            .map((e) =>
                DropdownMenuItem(value: e.profileId, child: Text(e.profileId)))
            .toList(),
        onChanged: (profileId) =>
            {setState(() => selectedProfileId = profileId)});
  }

  Future<List<OWUserProfile>> fetchUserProfiles() async {
    try {
      final profiles = await Onegini.instance.userClient.getUserProfiles();
      setState(() {
        userProfiles = profiles;
        selectedProfileId =
            selectedProfileId ?? profiles.firstOrNull?.profileId;
      });
      return profiles;
    } catch (err) {
      print("caught error in getUserProfiles: $err");
      return [];
    }
  }

  Widget _buildImplicitUserData(final String profileId) {
    return FutureBuilder<String>(
        future: getImplicitUserDetails(profileId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Text("${snapshot.data}");
          } else if (snapshot.hasError) {
            return Text("Error getting implicit details.");
          }
          return CircularProgressIndicator();
        });
  }

  Future<String> getImplicitUserDetails(final String profileId) async {
    try {
      await Onegini.instance.userClient
          .authenticateUserImplicitly(profileId, ["read"]);
      var response = await Onegini.instance.resourcesMethods.requestResource(
          ResourceRequestType.implicit,
          RequestDetails(
              path: "user-id-decorated", method: HttpRequestMethod.get));

      var res = json.decode(response.body);

      return res["decorated_user_id"];
    } catch (err) {
      print("Caught error: $err");
      return "Error occured check logs";
    }
  }

  authenticate(
      final String profileId, OWAuthenticatorType? authenticatorType) async {
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
}
