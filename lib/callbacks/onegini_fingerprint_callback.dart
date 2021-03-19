import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:onegini/constants/constants.dart';

import '../onegini.dart';

class OneginiFingerprintCallback{


  Future<void> fallbackToPin() async {
    try {
      await Onegini.instance.channel
          .invokeMethod(Constants.fingerprintFallbackToPin);
    } on PlatformException catch (error) {
      throw error;
    }  }


  Future<void> denyAuthenticationRequest() async {
    try {
      await Onegini.instance.channel
          .invokeMethod(Constants.denyFingerprintAuthenticationRequest);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<void> acceptAuthenticationRequest(BuildContext context,{String? pin}) async {
    Onegini.instance.setEventContext(context);
    try {
      await Onegini.instance.channel
          .invokeMethod(Constants.acceptFingerprintAuthenticationRequest);
    } on PlatformException catch (error) {
      throw error;
    }
  }
}