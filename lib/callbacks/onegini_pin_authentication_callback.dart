import 'package:flutter/material.dart';
import 'package:onegini/pigeon.dart';

import '../onegini.dart';

/// A callback for pin AUTHENTICATION.
class OneginiPinAuthenticationCallback {
  final api = UserClientApi();

  /// Cancels pin authentication.
  Future<void> denyAuthenticationRequest() async {
    await api.pinDenyAuthenticationRequest();
  }

  /// Accepts pin authentication and sent [pin] to the OneginiSdk.
  Future<void> acceptAuthenticationRequest(BuildContext? context,
      {String? pin}) async {
    Onegini.instance.setEventContext(context);

    await api.pinAcceptAuthenticationRequest(pin);
  }
}
