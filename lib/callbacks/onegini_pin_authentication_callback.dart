import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/constants/constants.dart';

import '../onegini.dart';

/// A callback for pin AUTHENTICATION.
class OneginiPinAuthenticationCallback {
  /// Cancels pin authentication.
  Future<void> denyAuthenticationRequest() async {
    await Onegini.instance.channel
        .invokeMethod(Constants.denyPinAuthenticationRequest);
  }

  /// Accepts pin authentication and sent [pin] to the OneginiSdk.
  Future<void> acceptAuthenticationRequest(BuildContext? context,
      {String? pin}) async {
    Onegini.instance.setEventContext(context);
    await Onegini.instance.channel.invokeMethod(
        Constants.acceptPinAuthenticationRequest, <String, String?>{
      'pin': pin,
    });
  }
}
