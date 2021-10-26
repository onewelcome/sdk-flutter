import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/constants/constants.dart';

import '../onegini.dart';

/// A callback for mobile authentication with OTP
class OneginiOtpAcceptDenyCallback {
  /// Cancels OTP authentication.
  Future<void> denyAuthenticationRequest() async {
    try {
      await Onegini.instance.channel
          .invokeMethod(Constants.denyOtpAuthenticationRequest);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  /// Accepts OTP authentication.
  Future<void> acceptAuthenticationRequest(BuildContext? context) async {
    Onegini.instance.setEventContext(context);
    try {
      await Onegini.instance.channel
          .invokeMethod(Constants.acceptOtpAuthenticationRequest);
    } on PlatformException catch (error) {
      throw error;
    }
  }
}
