import 'package:flutter/services.dart';
import 'package:onegini/constants/constants.dart';

import '../onegini.dart';

/// A callback for registration.
class OneginiRegistrationCallback {
  /// Cancels registration action.
  Future<void> cancelBrowserRegistration() async {
    await Onegini.instance.channel
        .invokeMethod(Constants.cancelRegistrationMethod);
  }
}
