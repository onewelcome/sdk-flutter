import 'package:flutter/material.dart';
import 'package:onegini/pigeon.dart';

import '../onegini.dart';

/// A callback for mobile authentication with OTP
class OneginiOtpAcceptDenyCallback {
  final api = UserClientApi();

  /// Cancels OTP authentication.
  Future<void> denyAuthenticationRequest() async {
    await api.otpDenyAuthenticationRequest();
  }

  /// Accepts OTP authentication.
  Future<void> acceptAuthenticationRequest(BuildContext? context) async {
    Onegini.instance.setEventContext(context);

    await api.otpAcceptAuthenticationRequest();
  }
}
