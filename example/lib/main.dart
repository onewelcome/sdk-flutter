import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/onegini.dart';
import 'package:onegini/onegini.gen.dart';
import 'package:onegini_example/components/display_toast.dart';
import 'package:onegini_example/screens/login_screen.dart';

import 'firebase_options.dart';

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
              "com.onegini.mobile.flutterExample.SecurityController",
          configModelClassName:
              "com.onegini.mobile.flutterExample.OneginiConfigModel",
          customIdentityProviderConfigs: [
            OWCustomIdentityProvider(
                providerId: "2-way-otp-api", isTwoStep: true),
            OWCustomIdentityProvider(
                providerId: "qr_registration", isTwoStep: false)
          ],
          connectionTimeout: 5,
          readTimeout: 25,
          additionalResourceUrls: []);
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      FirebaseMessaging.onBackgroundMessage((message) async {
        print('Got a message whilst in the background!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print(
              'Message also contained a notification: ${message.notification}');
        }
      });
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
        final jsonContent = jsonDecode(message.data['content']);
        Onegini.instance.userClient.acceptMobileAuthWithPushRequest(
            OWMobileAuthWithPushRequest(
                transactionId: jsonContent['og_transaction_id'],
                userProfileId: jsonContent['og_profile_id'],
                message: jsonContent['og_message']));
        if (message.notification != null) {
          print(
              'Message also contained a notification: ${message.notification}');
        }
      });
    } on PlatformException catch (error) {
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
