// @dart = 2.10
import 'dart:convert';

import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onegini/model/onegini_list_response.dart';
import 'package:onegini/onegini.dart';
import 'package:onegini_example/models/application_details.dart';
import 'package:onegini_example/models/client_resource.dart';
import 'package:onegini_example/screens/qr_scan_screen.dart';
import 'package:url_launcher/url_launcher.dart';

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
  List<OneginiListResponse> registeredAuthenticators = [];
  List<OneginiListResponse> notRegisteredAuthenticators = [];

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
    getAuthenticators();

    //testDeregisterAuthenticator();
  }

  // testDeregisterAuthenticator() async {
  //   var result = await Onegini.instance.userClient.deregisterAuthenticator(context, "com.onegini.authenticator.TouchID");
  //   print(result);
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  Future<void> getAuthenticators() async {
    notRegisteredAuthenticators = await Onegini.instance.userClient
        .getNotRegisteredAuthenticators(context);
    registeredAuthenticators =
        await Onegini.instance.userClient.getRegisteredAuthenticators(context);
  }

  Future<List<OneginiListResponse>> getAllSortAuthenticators() async {
    var allAuthenticators =
        await Onegini.instance.userClient.getAllAuthenticators(context);
    allAuthenticators.sort((a, b) {
      return compareAsciiUpperCase(a.name, b.name);
    });
    return allAuthenticators;
  }

  Future<List<OneginiListResponse>> getNotRegisteredAuthenticators() async {
    var authenticators = await Onegini.instance.userClient
        .getNotRegisteredAuthenticators(context);
    return authenticators;
  }

  registerAuthenticator(String authenticatorId) async {
    await Onegini.instance.userClient
        .registerAuthenticator(context, authenticatorId)
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
        .deregisterAuthenticator(context, authenticatorId)
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
    await getAuthenticators();
    setState(() {});
  }

  setPreferredAuthenticator(String authenticatorId) async {
    await Onegini.instance.userClient
        .setPreferredAuthenticator(context, authenticatorId)
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
    Navigator.pop(context);
  }

  deregister(BuildContext context) async {
    Navigator.pop(context);
    var profiles = await Onegini.instance.userClient.fetchUserProfiles();
    var profileId = profiles.first?.profileId;
    if (profileId == null) {
      return;
    }

    var isLogOut = await Onegini.instance.userClient
        .deregisterUser(profileId)
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
    if (isLogOut != null && isLogOut) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  changePin(BuildContext context) {
    Navigator.pop(context);
    Onegini.instance.userClient.changePin(context).catchError((error) {
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
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
            FutureBuilder<List<OneginiListResponse>>(
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
            FutureBuilder<List<OneginiListResponse>>(
              future: Onegini.instance.userClient
                  .getRegisteredAuthenticators(context),
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
  authWithOpt(BuildContext context) async {
    Onegini.instance.setEventContext(context);
    var data = await Navigator.push(
      context,
      MaterialPageRoute<String>(builder: (_) => QrScanScreen()),
    );
    if (data != null) {
      var isSuccess = await Onegini.instance.userClient
          .mobileAuthWithOtp(data)
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

  getAppToWebSingleSignOn(BuildContext context) async {
    var oneginiAppToWebSingleSignOn = await Onegini.instance.userClient
        .getAppToWebSingleSignOn(
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
    if (oneginiAppToWebSingleSignOn != null) {
      await launch(
        oneginiAppToWebSingleSignOn.redirectUrl,
        enableDomStorage: true,
      );
    }
  }

  userProfiles(BuildContext context) async {
    var data = await Onegini.instance.userClient.fetchUserProfiles();
    var msg = "";
    data.forEach((element) {
      msg = msg + element.profileId + ", ";
    });
    msg = msg.substring(0, msg.length - 2);
    Fluttertoast.showToast(
        msg: msg,
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
                getAppToWebSingleSignOn(context);
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
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                userProfiles(context);
              },
              child: Text('User profiles'),
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
    var response = "";
    var success = await Onegini.instance.userClient.authenticateDevice(["read", "write", "application-details"]);
    if(success!=null && success){
      response = await Onegini.instance.resourcesMethods
          .getResourceAnonymous("application-details");
    }
    var res = json.decode(response);
    return applicationDetailsFromJson(res["body"]);
  }

  Future<ClientResource> getClientResource() async {
    var response =
    await Onegini.instance.resourcesMethods.getResource("devices");
    var res = json.decode(response);
    return clientResourceFromJson(res["body"]);
  }

  Future<String> getImplicitUserDetails() async {
    var returnString = "";
    var user = await Onegini.instance.userClient.authenticateUserImplicitly(["read"]);
    if(user!=null && user.profileId != null){
      var response = await Onegini.instance.resourcesMethods
          .getResourceImplicit("user-id-decorated");
      var res = json.decode(response);
      returnString = json.decode(res["body"])["decorated_user_id"];
    }
    return returnString;
  }

  Future<String> makeUnaunthenticatedRequest() async {
    var headers = {'Declareren-Appversion': 'CZ.app'};
    var response = await Onegini.instance.resourcesMethods
        .getUnauthenticatedResource("devices", headers: headers, method: 'GET').catchError((onError) {
          debugPrint(onError);
        });
    var res = json.decode(response);
    return res["body"];
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
              SizedBox(
                height: 20,
              ),
              FutureBuilder<String>(
                //implicit
                future: makeUnaunthenticatedRequest(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "UnaunthenticatedRequest - Users:",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(snapshot.data, style: TextStyle(fontSize: 20)),
                          ],
                        )
                      : SizedBox.shrink();
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
