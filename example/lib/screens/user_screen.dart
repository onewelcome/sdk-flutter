import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini/model/request_details.dart';
import 'package:onegini/onegini.dart';
import 'package:onegini_example/components/display_toast.dart';
import 'package:onegini_example/models/application_details.dart';
import 'package:onegini_example/models/client_resource.dart';
import 'package:onegini_example/ow_broadcast_helper.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:onegini_example/screens/qr_scan_screen.dart';
import 'package:onegini_example/subscription_handlers/otp_subscriptions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:onegini/onegini.gen.dart';
// ignore: import_of_legacy_library_into_null_safe
import '../main.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'login_screen.dart';

class UserScreen extends StatefulWidget {
  final String userProfileId;

  const UserScreen({Key? key, required this.userProfileId}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> with RouteAware {
  int _currentIndex = 0;
  late List<Widget> _children;
  OWAuthenticator? _biometricAuthenticator = null;
  OWAuthenticator? _preferredAuthenticator = null;
  String profileId = "";
  late final List<StreamSubscription<OWEvent>>? registrationSubscriptions;
  late final List<StreamSubscription<OWEvent>>? authenticationSubscriptions;
  late final List<StreamSubscription<OWEvent>>? otpSubscriptions;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    _children = [
      Home(),
      Info(
        userProfileId: widget.userProfileId,
      ),
    ];
    super.initState();
    this.profileId = widget.userProfileId;

    // Init listeners for changePin, setPreferredAuthenticators
    this.registrationSubscriptions =
        OWBroadcastHelper.initRegistrationSubscriptions(context);
    this.authenticationSubscriptions =
        OWBroadcastHelper.initAuthenticationSubscriptions(context);
    this.otpSubscriptions = initOtpSubscriptions(context);

    getAuthenticators();
  }

  getAuthenticators() async {
    try {
      final preferredAuthenticator = await Onegini.instance.userClient
          .getPreferredAuthenticator(profileId);
      setState(() {
        _preferredAuthenticator = preferredAuthenticator;
      });
    } on PlatformException catch (err) {
      showFlutterToast(err.message);
    }

    try {
      final biometricAuthenticator = await Onegini.instance.userClient
          .getBiometricAuthenticator(profileId);
      setState(() {
        _biometricAuthenticator = biometricAuthenticator;
      });
    } on PlatformException catch (err) {
      if (err.code != "8060") {
        showFlutterToast(err.message);
      }
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    OWBroadcastHelper.stopListening(authenticationSubscriptions);
    OWBroadcastHelper.stopListening(registrationSubscriptions);
    OWBroadcastHelper.stopListening(otpSubscriptions);
    super.dispose();
  }

  @override
  void didPopNext() {
    getAuthenticators();
  }

  logOut(BuildContext context) async {
    Navigator.pop(context);
    await Onegini.instance.userClient.logout().catchError((error) {
      if (error is PlatformException) {
        showFlutterToast(error.message);
      }
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  deregister(BuildContext context) async {
    await Onegini.instance.userClient
        .deregisterUser(profileId)
        .catchError((error) {
      if (error is PlatformException) {
        showFlutterToast(error.message);
      }
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  changePin(BuildContext context) {
    Navigator.pop(context);

    Onegini.instance.userClient.changePin().catchError((error) {
      if (error is PlatformException) {
        showFlutterToast(error.message);
        // FIXME: this should be extracted into a seperate method and should also use constants (dont exist yet)
        if (error.code == "8002" ||
            error.code == "9002" ||
            error.code == "9003" ||
            error.code == "9010" ||
            error.code == "10012") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => LoginScreen()),
          );
        }
      }
    });
  }

  Widget biometricAuthenticatorWidget() {
    final authenticator = _biometricAuthenticator;
    if (authenticator != null) {
      return ListTile(
        title: Text(authenticator.name),
        leading: Switch(
            value: authenticator.isRegistered,
            onChanged: (newValue) => {
                  if (newValue)
                    {
                      Onegini.instance.userClient
                          .registerBiometricAuthenticator()
                          .whenComplete(() => getAuthenticators())
                    }
                  else
                    {
                      Onegini.instance.userClient
                          .deregisterBiometricAuthenticator()
                          .whenComplete(() => getAuthenticators())
                    }
                }),
      );
    }
    return SizedBox.shrink();
  }

  Widget preferredAuthenticatorSelectorWidget() {
    final biometricAuthenticator = _biometricAuthenticator;
    return PopupMenuButton<OWAuthenticatorType>(
        child: ListTile(
          title: Text("set preferred authenticator"),
          leading: Icon(Icons.add_to_home_screen),
        ),
        onSelected: (value) {
          Onegini.instance.userClient
              .setPreferredAuthenticator(value)
              .whenComplete(() => getAuthenticators());
        },
        itemBuilder: (context) {
          return [
            PopupMenuItem<OWAuthenticatorType>(
              child: Text("Pin"),
              value: OWAuthenticatorType.pin,
            ),
            if (biometricAuthenticator != null &&
                biometricAuthenticator.isRegistered)
              PopupMenuItem<OWAuthenticatorType>(
                child: Text(biometricAuthenticator.name),
                value: OWAuthenticatorType.biometric,
              ),
          ];
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
      body: _children[_currentIndex],
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Container(),
            ),
            ListTile(
              title: Text("ProfileId: ${profileId}"),
              leading: Icon(Icons.person),
            ),
            Divider(),
            ListTile(
              title: Text("Authenticators"),
              leading: Icon(Icons.lock_rounded),
            ),
            ListTile(
              title: Text("Pin"),
              leading: Switch(value: true, onChanged: null),
            ),
            biometricAuthenticatorWidget(),
            ListTile(
              title: Text(
                  "Preferred Authenticator: ${_preferredAuthenticator?.name} "),
            ),
            preferredAuthenticatorSelectorWidget(),
            Divider(),
            ListTile(
              title: Text("Change pin"),
              onTap: () => changePin(context),
              leading: Icon(Icons.vpn_key_rounded),
            ),
            ListTile(
              title: Text("Log Out"),
              onTap: () => logOut(context),
              leading: Icon(Icons.logout),
            ),
            ListTile(
              title: Text("Deregister"),
              onTap: () => deregister(context),
              leading: Icon(Icons.delete),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "Info")
        ],
      ),
    );
  }
}

class Home extends StatelessWidget {
  enrollMobileAuthentication() async {
    await Onegini.instance.userClient
        .enrollMobileAuthentication()
        .then((value) =>
            showFlutterToast("Mobile Authentication enrollment success"))
        .catchError((error) {
      if (error is PlatformException) {
        showFlutterToast(error.message);
      }
    });
  }

  authWithOpt(BuildContext context) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute<String>(builder: (_) => QrScanScreen()),
    );

    if (data != null) {
      await Onegini.instance.userClient
          .handleMobileAuthWithOtp(data)
          .then(
              (value) => showFlutterToast("OTP Authentication is successfull"))
          .catchError((error) {
        if (error is PlatformException) {
          print(error.message);
        }
      });
    }
  }

  getAppToWebSingleSignOn(BuildContext context) async {
    try {
      final oneginiAppToWebSingleSignOn = await Onegini.instance.userClient
          .getAppToWebSingleSignOn(
              "https://login-mobile.test.onegini.com/personal/dashboard");
      if (!await launchUrl(Uri.parse(oneginiAppToWebSingleSignOn.redirectUrl),
          mode: LaunchMode.externalApplication)) {
        throw Exception(
            'Could not launch ${oneginiAppToWebSingleSignOn.redirectUrl}');
      }
    } on PlatformException catch (error) {
      showFlutterToast(error.message);
    }
  }

  userProfiles(BuildContext context) async {
    var data = await Onegini.instance.userClient.getUserProfiles();
    var msg = "";
    data.forEach((element) {
      msg = msg + element.profileId + ", ";
    });
    msg = msg.substring(0, msg.length - 2);
    showFlutterToast(msg);
  }

  showAuthenticatedUserProfile(BuildContext context) async {
    var profile =
        await Onegini.instance.userClient.getAuthenticatedUserProfile();
    showFlutterToast('Authenticated Userprofile: ${profile.profileId}');
  }

  showAccessToken(BuildContext context) async {
    var accessToken = await Onegini.instance.userClient.getAccessToken();
    showFlutterToast(accessToken);
  }

  performUnauthenticatedRequest() async {
    try {
      final response = await Onegini.instance.resourcesMethods
          .requestResourceUnauthenticated(RequestDetails(
              path: "unauthenticated", method: HttpRequestMethod.get));
      showFlutterToast("Response: ${response.body}");
    } on PlatformException catch (error) {
      print("An error occured ${error.message}");
      showFlutterToast("An error occured ${error.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  getAppToWebSingleSignOn(context);
                },
                child: Text('Single Sign On'),
              ),
              ElevatedButton(
                onPressed: () {
                  enrollMobileAuthentication();
                },
                child: Text('Enroll for Mobile Authentication'),
              ),
              ElevatedButton(
                onPressed: () {
                  authWithOpt(context);
                },
                child: Text('Auth with opt'),
              ),
              ElevatedButton(
                onPressed: () {
                  userProfiles(context);
                },
                child: Text('User profiles'),
              ),
              ElevatedButton(
                onPressed: () {
                  showAuthenticatedUserProfile(context);
                },
                child: Text('Authenticated Userprofile'),
              ),
              ElevatedButton(
                onPressed: () {
                  showAccessToken(context);
                },
                child: Text('Access Token'),
              ),
              ElevatedButton(
                onPressed: () {
                  performUnauthenticatedRequest();
                },
                child: Text('Perform Unauthenticated Request'),
              ),
            ]),
      ),
    );
  }
}

class Info extends StatefulWidget {
  final String userProfileId;

  const Info({Key? key, required this.userProfileId}) : super(key: key);

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  Future<ApplicationDetails> getApplicationDetails() async {
    await Onegini.instance.userClient
        .authenticateDevice(["read", "write", "application-details"]);
    var response = await Onegini.instance.resourcesMethods.requestResource(
        ResourceRequestType.anonymous,
        RequestDetails(
            path: "application-details", method: HttpRequestMethod.get));
    var res = json.decode(response.body);
    return applicationDetailsFromJson(res);
  }

  Future<ClientResource> getClientResource() async {
    var response = await Onegini.instance.resourcesMethods
        .requestResourceAuthenticated(
            RequestDetails(path: "devices", method: HttpRequestMethod.get))
        // Will be fixed in FP-51
        // ignore: body_might_complete_normally_catch_error
        .catchError((error) {
      print('Caught error: $error');

      showFlutterToast(error.message);
    });

    return clientResourceFromJson(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              FutureBuilder<ApplicationDetails>(
                future: getApplicationDetails(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "application identifier => ",
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  snapshot.data?.applicationIdentifier ?? "",
                                  style: TextStyle(fontSize: 18),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  "application platform => ",
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  snapshot.data?.applicationPlatform ?? "",
                                  style: TextStyle(fontSize: 18),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  "application version => ",
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  snapshot.data?.applicationVersion ?? "",
                                  style: TextStyle(fontSize: 18),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      : Text("");
                },
              ),
              Expanded(
                child: FutureBuilder<ClientResource>(
                  future: getClientResource(),
                  builder: (context, snapshot) {
                    final snapshotData = snapshot.data;
                    return snapshotData != null
                        ? ListView.builder(
                            itemCount: snapshotData.devices.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ExpansionTile(
                                title: Text(snapshotData.devices[index].name),
                                expandedCrossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Id => ${snapshotData.devices[index].id}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Application => ${snapshotData.devices[index].application}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Mobile authentication enabled => ${snapshotData.devices[index].mobileAuthenticationEnabled.toString()}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Platform => ${snapshotData.devices[index].platform}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            },
                          )
                        : Center(
                            child: SizedBox(
                              child: CircularProgressIndicator(),
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
