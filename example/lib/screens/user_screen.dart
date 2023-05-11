import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/errors/error_codes.dart';
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini/model/request_details.dart';
import 'package:onegini/onegini.dart';
import 'package:onegini_example/components/display_toast.dart';
import 'package:onegini_example/models/application_details.dart';
import 'package:onegini_example/models/client_resource.dart';
import 'package:onegini_example/ow_broadcast_helper.dart';
import 'package:onegini_example/screens/push_auth_screen.dart';
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
      if (err.code != WrapperErrorCodes.biometricAuthenticationNotAvailable) {
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
        // FIXME: this should be extracted into a seperate method
        if (error.code == WrapperErrorCodes.notAuthenticatedUser ||
            error.code == PlatformErrorCodes.deviceDeregistered ||
            error.code == PlatformErrorCodes.userDeregistered ||
            error.code == PlatformErrorCodes.userNotAuthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => LoginScreen()),
          );
        }
      }
    });
  }

  Widget _buildBiometricAuthenticatorWidget() {
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

  Widget _buildPreferredAuthenticatorWidget() {
    final biometricAuthenticator = _biometricAuthenticator;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      ListTile(
        title:
            Text("Preferred Authenticator: ${_preferredAuthenticator?.name} "),
      ),
      PopupMenuButton<OWAuthenticatorType>(
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
          })
    ]);
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
        child: ListView(
          children: [
            DrawerHeader(
              child: ListTile(
                title: Text("ProfileId: ${profileId}"),
                leading: Icon(Icons.person),
              ),
            ),
            ListTile(
              title: Text("Authenticators"),
              leading: Icon(Icons.lock_rounded),
            ),
            ListTile(
              title: Text("Pin"),
              leading: Switch(value: true, onChanged: null),
            ),
            _buildBiometricAuthenticatorWidget(),
            _buildPreferredAuthenticatorWidget(),
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
              ElevatedButton(
                onPressed: () async {
                  try {
                    final fcmToken =
                        await FirebaseMessaging.instance.getToken();
                    if (fcmToken != null) {
                      Onegini.instance.api
                          .enrollUserForMobileAuthWithPush(fcmToken);
                      showFlutterToast("enroll for push success");
                    } else {
                      showFlutterToast("FCMToken is null");
                    }
                  } on PlatformException catch (error) {
                    showFlutterToast(error.message);
                  } catch (error) {
                    print(error.toString());
                    showFlutterToast(error.toString());
                  }
                },
                child: Text('Enroll for mobile authentication with push'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PushAuthScreen()));
                },
                child: Text('Pending pushes'),
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
  Future<ApplicationDetails> _getApplicationDetails() async {
    await Onegini.instance.userClient
        .authenticateDevice(["read", "write", "application-details"]);
    final response = await Onegini.instance.resourcesMethods.requestResource(
        ResourceRequestType.anonymous,
        RequestDetails(
            path: "application-details", method: HttpRequestMethod.get));
    return applicationDetailsFromJson(response.body);
  }

  Future<ClientResource> _getClientResource() async {
    final response = await Onegini.instance.resourcesMethods
        .requestResourceAuthenticated(
            RequestDetails(path: "devices", method: HttpRequestMethod.get));
    return clientResourceFromJson(response.body);
  }

  FutureBuilder<ClientResource> _buildDeviceInfoList() {
    return FutureBuilder<ClientResource>(
      future: _getClientResource(),
      builder: (context, snapshot) {
        final snapshotData = snapshot.data;
        return snapshotData != null
            ? ListView.builder(
                itemCount: snapshotData.devices.length,
                itemBuilder: (BuildContext context, int index) {
                  return ExpansionTile(
                    title: Text(snapshotData.devices[index].name),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                          title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Id => ${snapshotData.devices[index].id}",
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Application => ${snapshotData.devices[index].application}",
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Mobile authentication enabled => ${snapshotData.devices[index].mobileAuthenticationEnabled.toString()}",
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Platform => ${snapshotData.devices[index].platform}",
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(),
                        ],
                      ))
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
    );
  }

  FutureBuilder<ApplicationDetails> _buildApplicationDetails() {
    return FutureBuilder<ApplicationDetails>(
      future: _getApplicationDetails(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "application identifier => ${snapshot.data?.applicationIdentifier}",
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "application platform => ${snapshot.data?.applicationPlatform}",
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "application version => ${snapshot.data?.applicationVersion}",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              )
            : CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 20),
              _buildApplicationDetails(),
              Divider(),
              Expanded(
                child: _buildDeviceInfoList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
