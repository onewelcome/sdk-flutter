import 'package:flutter/material.dart';
import 'package:onegini/model/applicationDetails.dart';
import 'package:onegini/model/clientResource.dart';
import 'package:onegini/onegini.dart';
import 'package:onegini_example/loginScreen.dart';

class UserScreen extends StatefulWidget {
  final String userProfileId;

  const UserScreen({Key key, this.userProfileId}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  int _currentIndex = 0;
  List<Widget> _children;

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

  logOut(BuildContext context) async {
    var isLogOut =
        await Onegini.logOut().catchError((error) => print(error.toString()));
    if (isLogOut) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  deregister(BuildContext context) async {
    var isLogOut = await Onegini.deregisterUser()
        .catchError((error) => print(error.toString()));
    if (isLogOut) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
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
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Onegini.singleSingOn();
              },
              child: Text('Single Sign On'),
            ),


            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                logOut(context);
              },
              child: Text('logOut'),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                deregister(context);
              },
              child: Text('Deregister'),
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
  @override
  Widget build(BuildContext context) {
    return Stack(
          children: [ Container(
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
                future: Onegini.getImplicitUserDetails(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Decorated profile id:",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(snapshot.data, style: TextStyle(fontSize: 20)),
                          ],
                        )
                      : SizedBox.shrink();
                }),
            SizedBox(
              height: 20,
            ),
            FutureBuilder<ApplicationDetails>(
              future: Onegini.getApplicationDetails(),
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
                future: Onegini.getClientResource(),
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
