import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:onegini/constants/constants.dart';

import '../onegini.dart';

///  A callback of fingerprint authentication.
///
///  Use this callback when user want authenticate by fingerprint
class OneginiFingerprintCallback{


  ///Changes the authentication method from fingerprint to PIN
  Future<void> fallbackToPin() async {
    try {
      await Onegini.instance.channel
          .invokeMethod(Constants.fingerprintFallbackToPin);
    } on PlatformException catch (error) {
      throw error;
    }  }

  ///Cancels authentication request.
  ///
  ///Used when a user has canceled a authentication by fingerprint.
  Future<void> denyAuthenticationRequest() async {
    try {
      await Onegini.instance.channel
          .invokeMethod(Constants.denyFingerprintAuthenticationRequest);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  ///Accept fingerprint request
  ///
  ///Use this method when you want start scanning fingerprint.
  Future<void> acceptAuthenticationRequest(BuildContext context) async {
    Onegini.instance.setEventContext(context);
    try {
      await Onegini.instance.channel
          .invokeMethod(Constants.acceptFingerprintAuthenticationRequest);
    } on PlatformException catch (error) {
      throw error;
    }
  }
}