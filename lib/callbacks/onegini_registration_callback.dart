import 'package:flutter/services.dart';
import 'package:onegini/constants/constants.dart';

import '../onegini.dart';

///Callback for registration
class OneginiRegistrationCallback {

  ///Cancels registration action
  Future<void> cancelRegistration() async {
    try {
      await Onegini.instance.channel
          .invokeMethod(Constants.cancelRegistrationMethod);
    } on PlatformException catch (error) {
      throw error;
    }
  }
}