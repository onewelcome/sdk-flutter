import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/onegini.dart';
import 'package:onegini/onegini.gen.dart';
import 'package:onegini_example/components/display_toast.dart';
import 'package:onegini_example/screens/auth_screen.dart';

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
      await Onegini.instance.startApplication(
          securityControllerClassName:
              "com.onegini.mobile.onegini_example.SecurityController",
          configModelClassName:
              "com.onegini.mobile.onegini_example.OneginiConfigModel",
          customIdentityProviderConfigs: [
            OWCustomIdentityProvider(
                providerId: "2-way-otp-api", isTwoStep: true),
            OWCustomIdentityProvider(
                providerId: "qr_registration", isTwoStep: false),
            OWCustomIdentityProvider(
                providerId: "stateless-test", isTwoStep: false),
            OWCustomIdentityProvider(providerId: "New2step", isTwoStep: true),
          ],
          connectionTimeout: 5,
          readTimeout: 25,
          additionalResourceUrls: []);
    } on PlatformException catch (error) {
      showFlutterToast(error.message);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator();
  }
}
