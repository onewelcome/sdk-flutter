import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/model/application_details.dart';
import 'package:onegini/model/client_resource.dart';
import 'package:onegini/onegini.dart';
import 'package:onegini_example/screens/qr_scan_screen.dart';

import 'login_screen.dart';

class UserScreen extends StatefulWidget {
  final String userProfileId;

  const UserScreen({Key key, this.userProfileId}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  int _currentIndex = 0;
  List<Widget> _children;
  bool isNotEnableFingerprint = true;

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
  }

  logOut(BuildContext context) async {
    Navigator.pop(context);
    var isLogOut =
        await Onegini.logOut().catchError((error) => print(error.toString()));
    if (isLogOut) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  deregister(BuildContext context) async {
    Navigator.pop(context);
    var isLogOut = await Onegini.deregisterUser().catchError((error) => {
          //todo OneginiDeregistrationError
        });
    if (isLogOut) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  registerFingerprint(BuildContext context) async {
    var data = await Onegini.registerFingerprint(context)
        .catchError((error) => print(error.toString()));
    setState(() => isNotEnableFingerprint = data!=null );
    Navigator.pop(context);
  }

  changePin(BuildContext context) {
    Onegini.changePin(context);
    Navigator.pop(context);
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
            FutureBuilder<bool>(
              future: Onegini.isUserNotRegisteredFingerprint(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData) {
                  isNotEnableFingerprint = snapshot.data;
                  return  snapshot.data && isNotEnableFingerprint
                      ? ListTile(
                          title: Text("enable fingerprint auth"),
                          onTap: () => registerFingerprint(context),
                    leading: Icon(Icons.fingerprint_outlined),
                        )
                      : SizedBox.shrink();
                } else {
                  return SizedBox.shrink();
                }
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
  authWithOpt(BuildContext context) async {
    Onegini.setEventContext(context);
    var data = await Navigator.push(
      context,
      MaterialPageRoute<String>(builder: (_) => QrScanScreen()),
    );
    if (data != null) Onegini.sendQrCodeData(data);
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
                Onegini.singleSingOn("https://login-mobile.test.onegini.com/personal/dashboard");
              },
              child: Text('Single Sign On'),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                authWithOpt(context);
              },
              child: Text('auth with opt'),
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
  final MethodChannel _channel = const MethodChannel('example');

  Future<ApplicationDetails> getApplicationDetails() async {
    try {
      var resource = await _channel.invokeMethod("getApplicationDetails");
      return ApplicationDetails.fromJson(jsonDecode(resource));
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<ClientResource> getClientResource() async {
    try {
      var resource = await _channel.invokeMethod("getClientResource");
      return clientResourceFromJson(resource);
    } on PlatformException catch (error) {
      print(error.details.toString());
      throw error;
    } on Exception catch (error) {
      throw error;
    }
  }

  Future<String> getImplicitUserDetails() async {
    try {
      var resource = await _channel.invokeMethod("getImplicitUserDetails");
      return resource;
    } on PlatformException catch (error) {
      throw error;
    }
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
              Row(
                children: [
                  Text(
                    "User profile id => ",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(widget.userProfileId, style: TextStyle(fontSize: 20)),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              FutureBuilder<String>(
                  //implicit
                  future: getImplicitUserDetails(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Decorated profile id:",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(snapshot.data,
                                  style: TextStyle(fontSize: 20)),
                            ],
                          )
                        : SizedBox.shrink();
                  }),
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
                                  snapshot.data.applicationIdentifier,
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
                                  snapshot.data.applicationPlatform,
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
                                  snapshot.data.applicationVersion,
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
