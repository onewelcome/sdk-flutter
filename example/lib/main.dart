// @dart = 2.10
import 'package:flutter/material.dart';
import 'package:onegini/onegini.dart';
import 'package:onegini/pigeon.dart';
import 'package:onegini_example/components/display_toast.dart';
import 'package:onegini_example/screens/login_screen.dart';

import 'onegini_listener.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onegini test app',
      navigatorObservers: [routeObserver],
      home: Scaffold(
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
  @override
  void initState() {
    _startApplication();
    super.initState();
  }

  void _startApplication() async {
    /// init Onegini sdk on native side
    try {
      await Onegini.instance.startApplication(OneginiListener(),
          securityControllerClassName:
              "com.onegini.mobile.onegini_example.SecurityController",
          configModelClassName:
              "com.onegini.mobile.onegini_example.OneginiConfigModel",
          customIdentityProviderConfigs: [
            OWCustomIdentityProvider(
                providerId: "2-way-otp-api", isTwoStep: true)
          ],
          connectionTimeout: 5,
          readTimeout: 25);
    } catch (error) {
      showFlutterToast(error.message);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator();
  }
}
