import 'package:flutter/material.dart';
import 'package:onegini/pigeon.dart';

import '../onegini.dart';

/// A callback for pin REGISTRATION.
class OneginiPinRegistrationCallback {
  final api = UserClientApi();

  /// Cancels pin registration request.
  Future<void> denyAuthenticationRequest() async {
    await api.pinDenyRegistrationRequest();
  }

  /// Accepts pin registration and sent [pin] to the OneginiSdk.
  @Deprecated("message")
  Future<void> acceptAuthenticationRequest(
      BuildContext? context, String pin) async {
    Onegini.instance.setEventContext(context);

    await api.pinAcceptRegistrationRequest(pin);
  }
}
