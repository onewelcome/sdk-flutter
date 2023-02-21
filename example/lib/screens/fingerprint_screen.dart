// @dart = 2.10
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/callbacks/onegini_fingerprint_callback.dart';
import '../components/display_toast.dart';

class FingerprintScreen extends StatefulWidget {
  @override
  _FingerprintScreenState createState() => _FingerprintScreenState();
}

class _FingerprintScreenState extends State<FingerprintScreen> {
  @override
  void initState() {
    super.initState();
    activateFingerprint();
  }

  activateFingerprint() async {
    await OneginiFingerprintCallback()
        .acceptAuthenticationRequest(context)
        .catchError((error) {
      if (error is PlatformException) {
        showFlutterToast(error.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await OneginiFingerprintCallback().denyAuthenticationRequest();
        return true;
      },
      child: Scaffold(
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
        body: Container(
          child: Center(
            child: Icon(
              Icons.fingerprint,
              size: 200,
            ),
          ),
        ),
      ),
    );
  }
}
