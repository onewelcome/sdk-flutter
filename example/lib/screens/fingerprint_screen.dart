import 'package:flutter/material.dart';
import 'package:onegini/onegini.dart';


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
      await Onegini.activateFingerprintSensor(context);
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
      body: Container(
        child: Center(child: Icon(Icons.fingerprint,size: 200,),),
      ),
    );
  }
}
