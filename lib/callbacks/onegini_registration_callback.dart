import 'package:flutter/services.dart';
import 'package:onegini/constants/constants.dart';

import '../onegini.dart';

class OneginiRegistrationCallback {
  Future<void> cancelRegistration() async {
    try {
      await Onegini.instance.channel
          .invokeMethod(Constants.cancelRegistrationMethod);
    } on PlatformException catch (error) {
      throw error;
    }
  }
}