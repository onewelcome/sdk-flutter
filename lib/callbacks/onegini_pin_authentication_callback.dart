import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/constants/constants.dart';

import '../onegini.dart';

/// Callback for pin AUTHENTICATION.
///
/// {@category Callbacks}
class OneginiPinAuthenticationCallback {
  /// Cancels authentication
  Future<void> denyAuthenticationRequest() async {
    try {
      await Onegini.instance.channel
          .invokeMethod(Constants.denyPinAuthenticationRequest);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  /// Accepts authentication and sent [pin] to the OneginiSdk.
  Future<void> acceptAuthenticationRequest(BuildContext context,
      {String? pin}) async {
    Onegini.instance.setEventContext(context);
    try {
      await Onegini.instance.channel.invokeMethod(
          Constants.acceptPinAuthenticationRequest, <String, String?>{
        'pin': pin,
      });
    } on PlatformException catch (error) {
      throw error;
    }
  }
}
