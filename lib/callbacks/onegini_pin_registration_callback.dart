import 'package:flutter/material.dart';
import 'package:onegini/constants/constants.dart';

import '../onegini.dart';

/// A callback for pin REGISTRATION.
class OneginiPinRegistrationCallback {
  /// Cancels pin registration request.
  Future<void> denyAuthenticationRequest() async {
    await Onegini.instance.channel
        .invokeMethod(Constants.denyPinRegistrationRequest);
  }

  /// Accepts pin registration and sent [pin] to the OneginiSdk.
  /// Method also passes [isCustomAuthenticator] as `true` or `null`.
  Future<void> acceptAuthenticationRequest(BuildContext? context,
      {String? pin, bool isCustomAuthenticator = false}) async {
    Onegini.instance.setEventContext(context);
    await Onegini.instance.channel
        .invokeMethod(Constants.acceptPinRegistrationRequest, <String, String?>{
      'pin': pin,
      'isCustomAuth': isCustomAuthenticator ? "true" : null,
    });
  }
}
