import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:onegini/constants/constants.dart';

import '../onegini.dart';

/// A callback of fingerprint authentication.
///
/// Use this callback when user want authenticate by fingerprint.
class OneginiFingerprintCallback {
  /// Changes the authentication method from fingerprint to PIN.
  Future<void> fallbackToPin() async {
    await Onegini.instance.channel
        .invokeMethod(Constants.fingerprintFallbackToPin);
  }

  /// Cancels authentication request.
  ///
  /// Used when a user has canceled a authentication by fingerprint.
  Future<void> denyAuthenticationRequest() async {
    await Onegini.instance.channel
        .invokeMethod(Constants.denyFingerprintAuthenticationRequest);
  }

  /// Accept fingerprint request.
  ///
  /// Use this method when you want start scanning fingerprint.
  Future<void> acceptAuthenticationRequest(BuildContext? context) async {
    Onegini.instance.setEventContext(context);
    await Onegini.instance.channel
        .invokeMethod(Constants.acceptFingerprintAuthenticationRequest);
  }
}
