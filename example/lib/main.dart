import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onegini/onegini.dart';


final String oneginiLogo = 'assets/oneginiLogo.svg';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onegini test app',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Example App"),
        ),
        body: Center(
          child: BodyWidget(),
        ),
      ),
    );
  }
}

class BodyWidget extends StatefulWidget {
  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  var _appStarted = false;
  var appError;

  @override
  void initState() {
    _startApplication(context);
    super.initState();
  }

  void _startApplication(BuildContext context) async {


    /// init Onegini sdk on native side
    _appStarted = await Onegini.startApplication(context).catchError((error) => appError = error
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        LoginWidget(
          appStarted: _appStarted,
        )
      ],
    );
  }
}

class LoginWidget extends StatefulWidget {
  final bool appStarted;

  const LoginWidget({Key key, this.appStarted}) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool loggedIn = false;
  String userId;


  openWeb()async{
    /// Start registration
    var userId = await Onegini.registration().catchError((error) => print(error.toString()));
    if(userId != null) setState(() {
      loggedIn = true;
      this.userId = userId;
    });
  }


  customIdentityProvider()async{
    var userId = await Onegini.registrationCustomIdentityProvider().catchError((error) => print(error.toString()));
    if(userId != null) setState(() {
      loggedIn = true;
      this.userId = userId;
    });
  }

  logOut()async{
    var isLogOut = await Onegini.logOut().catchError((error) => print(error.toString()));
    if(isLogOut) setState(() {
      loggedIn = false;
      this.userId = null;
    });
  }


  deregister()async{
    var isLogOut = await Onegini.deregisterUser().catchError((error) => print(error.toString()));
    if(isLogOut) setState(() {
      loggedIn = false;
      this.userId = null;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (widget.appStarted && !loggedIn) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              openWeb();
            },
            child: Text('Run WEB'),
          ),
          SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () {
             customIdentityProvider();
            },
            child: Text('Run Custom Identity Provider'),
          ),
        ],
      );
    } else if(widget.appStarted && loggedIn){
      return Center(child: Column(
        children: [
          Text('USER PROFILE ID: $userId',style: TextStyle(fontSize: 24),),
          SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () {
              Onegini.getApplicationDetails();
            },
            child: Text('get application details'),
          ),
          SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () {
              Onegini.getClientResource();
            },
            child: Text('get client resource'),
          ),
          SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () {
              Onegini.getImplicitUserDetails();
            },
            child: Text('get implicit user details'),
          ),
          SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () {
              logOut();
            },
            child: Text('logOut'),
          ),
          SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () {
              deregister();
            },
            child: Text('Deregister'),
          ),
        ],
      ));
    }else{
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      );
    }
  }
}
