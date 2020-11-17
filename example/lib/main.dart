import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    _startApplication();
    super.initState();
  }

  void _startApplication() async {


    /// init Onegini sdk on native side
    _appStarted = await Onegini.startApplication().catchError((error) => appError = error
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

  @override
  Widget build(BuildContext context) {
    if (widget.appStarted && !loggedIn) {
      return ElevatedButton(
        onPressed: () {
          openWeb();
        },
        child: Text('Run WEB'),
      );
    } else if(widget.appStarted && loggedIn){
      return Center(child: Text('USER PROFILE ID: $userId',style: TextStyle(fontSize: 24),));
    }else{
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      );
    }
  }
}
