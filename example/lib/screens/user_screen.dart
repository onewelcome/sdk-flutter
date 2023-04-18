// @dart = 2.10
import 'dart:async';
import 'dart:convert';

import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini/model/request_details.dart';
import 'package:onegini/onegini.dart';
import 'package:onegini_example/components/display_toast.dart';
import 'package:onegini_example/models/application_details.dart';
import 'package:onegini_example/models/client_resource.dart';
import 'package:onegini_example/ow_broadcast_helper.dart';
import 'package:onegini_example/screens/qr_scan_screen.dart';
import 'package:onegini_example/subscription_handlers/otp_subscriptions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:onegini/pigeon.dart';

import '../main.dart';
import 'login_screen.dart';

class UserScreen extends StatefulWidget {
  final String userProfileId;

  const UserScreen({Key key, this.userProfileId}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> with RouteAware {
  int _currentIndex = 0;
  List<Widget> _children;
  bool isContainNotRegisteredAuthenticators = true;
  List<OWAuthenticator> registeredAuthenticators = [];
  List<OWAuthenticator> notRegisteredAuthenticators = [];
  String profileId = "";
  OWBroadcastHelper broadcastHelper;
  List<StreamSubscription<OWEvent>> registrationSubscriptions;
  List<StreamSubscription<OWEvent>> authenticationSubscriptions;
  List<StreamSubscription<OWEvent>> otpSubscriptions;


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
    this.registrationSubscriptions = OWBroadcastHelper.initRegistrationSubscriptions(context);
    this.authenticationSubscriptions = OWBroadcastHelper.initAuthenticationSubscriptions(context);

    getAuthenticators();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);

    OWBroadcastHelper.stopListening(authenticationSubscriptions);
    OWBroadcastHelper.stopListening(registrationSubscriptions);

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

  Future<void> getAuthenticators() async {
    notRegisteredAuthenticators = await Onegini.instance.userClient
        .getNotRegisteredAuthenticators(this.profileId);

    registeredAuthenticators = await Onegini.instance.userClient
        .getRegisteredAuthenticators(this.profileId);
  }

  Future<List<OWAuthenticator>> getAllSortAuthenticators() async {
    var allAuthenticators = await Onegini.instance.userClient
        .getAllAuthenticators(this.profileId);
    allAuthenticators.sort((a, b) {
      return compareAsciiUpperCase(a.name, b.name);
    });
    return allAuthenticators;
  }

  Future<List<OWAuthenticator>> getNotRegisteredAuthenticators() async {
    var authenticators = await Onegini.instance.userClient
        .getNotRegisteredAuthenticators(this.profileId);
    return authenticators;
  }

  registerAuthenticator(String authenticatorId) async {
    await Onegini.instance.userClient
        .registerAuthenticator(authenticatorId)
        .catchError((error) {
      if (error is PlatformException) {
        showFlutterToast(error.message);
      }
    });
    await getAuthenticators();
    setState(() {});
  }

  bool isRegisteredAuthenticator(String authenticatorId) {
    for (var authenticator in registeredAuthenticators) {
      if (authenticator.id == authenticatorId) return true;
    }
    return false;
  }

  deregisterAuthenticator(String authenticatorId) async {
    await Onegini.instance.userClient
        .deregisterAuthenticator(authenticatorId)
        .catchError((error) {
      if (error is PlatformException) {
        showFlutterToast(error.message);
      }
    });
    await getAuthenticators();
    setState(() {});
  }

  setPreferredAuthenticator(String authenticatorId) async {
    await Onegini.instance.userClient
        .setPreferredAuthenticator(authenticatorId)
        .catchError((error) {
      if (error is PlatformException) {
        showFlutterToast(error.message);
      }
    });
    Navigator.pop(context);
  }

  deregister(BuildContext context) async {
    Navigator.pop(context);
    var profiles = await Onegini.instance.userClient.getUserProfiles();
    var profileId = profiles.first?.profileId;
    if (profileId == null) {
      return;
    }

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
            FutureBuilder<List<OWAuthenticator>>(
              future: getAllSortAuthenticators(),
              builder: (BuildContext context, snapshot) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.hasData ? snapshot.data.length : 0,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          snapshot.data[index].name,
                        ),
                        leading: Switch(
                          value: snapshot.data[index].name == "PIN"
                              ? true
                              : isRegisteredAuthenticator(
                                  snapshot.data[index].id),
                          onChanged: snapshot.data[index].name == "PIN"
                              ? null
                              : (value) {
                                  value
                                      ? registerAuthenticator(
                                          snapshot.data[index].id)
                                      : deregisterAuthenticator(
                                          snapshot.data[index].id);
                                },
                        ),
                      );
                    });
              },
            ),
            FutureBuilder<List<OWAuthenticator>>(
              future: Onegini.instance.userClient
                  .getRegisteredAuthenticators(this.profileId),
              builder: (BuildContext context, snapshot) {
                return PopupMenuButton<String>(
                    child: ListTile(
                      title: Text("set preferred authenticator"),
                      leading: Icon(Icons.add_to_home_screen),
                    ),
                    onSelected: (value) {
                      setPreferredAuthenticator(value);
                    },
                    itemBuilder: (context) {
                      return snapshot.data
                          .map((e) => PopupMenuItem<String>(
                                child: Text(e.name ?? ""),
                                value: e.id,
                              ))
                          .toList();
                    });
              },
            ),
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
              leading: Icon(Icons.app_registration),
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
        .then((value) => showFlutterToast("Mobile Authentication enrollment success"))
        .catchError((error) {
          if (error is PlatformException) {
            showFlutterToast(error.message);
          }
      });
  }

  authWithOpt(BuildContext context) async {
    List<StreamSubscription> otpSubscriptions = OtpSubscriptions.getSubscriptions(context);

    var data = await Navigator.push(
      context,
      MaterialPageRoute<String>(builder: (_) => QrScanScreen()),
    );

    if (data != null) {
      await Onegini.instance.userClient
        .handleMobileAuthWithOtp(data)
        .then((value) => showFlutterToast("OTP Authentication is successfull"))
        .catchError((error) {
          if (error is PlatformException) {
            print(error.message);
          }
      });
    }

    OWBroadcastHelper.stopListening(otpSubscriptions);
  }

  getAppToWebSingleSignOn(BuildContext context) async {
    var oneginiAppToWebSingleSignOn = await Onegini.instance.userClient
        .getAppToWebSingleSignOn(
            "https://login-mobile.test.onegini.com/personal/dashboard")
        .catchError((error) {
      if (error is PlatformException) {
        showFlutterToast(error.message);
      }
    });
    if (oneginiAppToWebSingleSignOn != null) {
      await launch(
        oneginiAppToWebSingleSignOn.redirectUrl,
        enableDomStorage: true,
      );
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
    var response = await Onegini.instance.resourcesMethods
        .requestResourceUnauthenticated(RequestDetails(path: "unauthenticated", method: HttpRequestMethod.get))
        .catchError((error) {
          print("An error occured $error");
          showFlutterToast("An error occured $error");
    });

    showFlutterToast("Response: ${response.body}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                getAppToWebSingleSignOn(context);
              },
              child: Text('Single Sign On'),
            ),
            SizedBox(
              height: 20,
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
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                userProfiles(context);
              },
              child: Text('User profiles'),
            ),
            SizedBox(
              height: 20,
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
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class Info extends StatefulWidget {
  final String userProfileId;

  const Info({Key key, this.userProfileId}) : super(key: key);

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  Future<ApplicationDetails> getApplicationDetails() async {
    await Onegini.instance.userClient
        .authenticateDevice(["read", "write", "application-details"]);
    var response = await Onegini.instance.resourcesMethods.requestResource(ResourceRequestType.anonymous, RequestDetails(path: "application-details", method: HttpRequestMethod.get));
    var res = json.decode(response.body);
    return applicationDetailsFromJson(res);
  }

  Future<ClientResource> getClientResource() async {
    var response = await Onegini.instance.resourcesMethods
        .requestResourceAuthenticated(RequestDetails(path: "devices", method: HttpRequestMethod.get))
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
                                  snapshot.data.applicationIdentifier ?? "",
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
                                  snapshot.data.applicationPlatform ?? "",
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
                                  snapshot.data.applicationVersion ?? "",
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
                    return snapshot.hasData
                        ? ListView.builder(
                            itemCount: snapshot.data.devices.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ExpansionTile(
                                title: Text(snapshot.data.devices[index].name),
                                expandedCrossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Id => ${snapshot.data.devices[index].id}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Application => ${snapshot.data.devices[index].application}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Mobile authentication enabled => ${snapshot.data.devices[index].mobileAuthenticationEnabled.toString()}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Platform => ${snapshot.data.devices[index].platform}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            },
                          )
                        : SizedBox.shrink();
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
