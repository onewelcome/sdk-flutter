import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/constants/constants.dart';

import '../onegini.dart';

///A callback for mobile authentication by OTP
class OneginiOtpAcceptDenyCallback {


  ///Cancels authentication
  Future<void> denyAuthenticationRequest() async {
    try {
      await Onegini.instance.channel
          .invokeMethod(Constants.denyOtpAuthenticationRequest);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  ///Accepts authentication
  Future<void> acceptAuthenticationRequest(BuildContext context) async {
    Onegini.instance.setEventContext(context);
    try {
      await Onegini.instance.channel
          .invokeMethod(Constants.acceptOtpAuthenticationRequest);
    } on PlatformException catch (error) {
      throw error;
    }
  }
}