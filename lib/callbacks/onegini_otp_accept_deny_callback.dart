import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/constants/constants.dart';

import '../onegini.dart';

/// A callback for mobile authentication with OTP
class OneginiOtpAcceptDenyCallback {
  /// Cancels OTP authentication.
  Future<void> denyAuthenticationRequest() async {
    await Onegini.instance.channel
        .invokeMethod(Constants.denyOtpAuthenticationRequest);
  }

  /// Accepts OTP authentication.
  Future<void> acceptAuthenticationRequest(BuildContext? context) async {
    Onegini.instance.setEventContext(context);
    await Onegini.instance.channel
        .invokeMethod(Constants.acceptOtpAuthenticationRequest);
  }
}
