import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onegini/model/onegini_identity_provider.dart';
import 'package:onegini/onegini.dart';
import 'package:onegini_example/models/application_details.dart';
import 'package:onegini_example/models/client_resource.dart';
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
  bool isContainNotRegisteredAuthenticators = true;

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
    var isLogOut = await Onegini.instance.authenticationMethods
        .logOut()
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
    if (isLogOut) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  Future<List<OneginiIdentityProvider>> getNotRegisteredAuthenticators() async {
    List<OneginiIdentityProvider>  authenticators  = await Onegini.instance.authenticationMethods.getNotRegisteredAuthenticators(context);
    if(authenticators.isEmpty) {
      setState(() => isContainNotRegisteredAuthenticators = false);
    } else {
      setState(() => isContainNotRegisteredAuthenticators = true);
    }
    return authenticators;
  }

  registerAuthenticator(String authenticatorId) async {
    Navigator.pop(context);
    await Onegini.instance.authenticationMethods
        .registeredAuthenticator(authenticatorId).catchError((error) {
     if (error is PlatformException)
     {
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

  deregister(BuildContext context) async {
    Navigator.pop(context);
    var isLogOut = await Onegini.instance.registrationMethods
        .deregisterUser()
        .catchError((error) => {
              if (error is PlatformException)
                {
                  Fluttertoast.showToast(
                      msg: error.message,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black38,
                      textColor: Colors.white,
                      fontSize: 16.0)
                }
            });
    if (isLogOut) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  changePin(BuildContext context) {
    Onegini.instance.changePin(context).catchError((error) {
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
            FutureBuilder<List<OneginiIdentityProvider>>(
              future: getNotRegisteredAuthenticators(),
              builder: (BuildContext context, snapshot) {
                return snapshot.hasData && isContainNotRegisteredAuthenticators
                    ? PopupMenuButton<String>(
                        child: ListTile(
                          title: Text("register authenticator"),
                          leading: Icon(Icons.fingerprint),
                        ),
                        onSelected: (value) {
                        registerAuthenticator(value);
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
    Onegini.instance.setEventContext(context);
    var data = await Navigator.push(
      context,
      MaterialPageRoute<String>(builder: (_) => QrScanScreen()),
    );
    if (data != null) {
      var isSuccess =
          await Onegini.instance.sendQrCodeData(data).catchError((error) {
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
      if (isSuccess != null && isSuccess.isNotEmpty)
        Fluttertoast.showToast(
            msg: isSuccess,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black38,
            textColor: Colors.white,
            fontSize: 16.0);
    }
  }

  singleSignOn(BuildContext context) async {
    var oneginiAppToWebSingleSignOn = await Onegini.instance
        .singleSingOn(
            "https://login-mobile.test.onegini.com/personal/dashboard")
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
    if (oneginiAppToWebSingleSignOn != null)
      Fluttertoast.showToast(
          msg: oneginiAppToWebSingleSignOn,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black38,
          textColor: Colors.white,
          fontSize: 16.0);
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
                singleSignOn(context);
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
  Future<ApplicationDetails> getApplicationDetails() async {
    var response = await Onegini.instance.resourcesMethods
        .getResourceWithAnonymousResourceOkHttpClient(
            "application-details", "application-details");
    return applicationDetailsFromJson(response);
  }

  Future<ClientResource> getClientResource() async {
    var response = await Onegini.instance.resourcesMethods
        .getResourceWithResourceOkHttpClient("devices");
    return clientResourceFromJson(response);
  }

  Future<String> getImplicitUserDetails() async {
    var response = await Onegini.instance.resourcesMethods
        .getResourceWithImplicitResourceOkHttpClient(
            "user-id-decorated", "read");
    Map<String, dynamic> responseAsJson = json.decode(response);
    return responseAsJson["decorated_user_id"];
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
