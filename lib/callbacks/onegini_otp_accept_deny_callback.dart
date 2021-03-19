import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/constants/constants.dart';

import '../onegini.dart';


class OneginiOtpAcceptDenyCallback {
  Future<void> denyAuthenticationRequest() async {
    try {
      await Onegini.instance.channel
          .invokeMethod(Constants.denyOtpAuthenticationRequest);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<void> acceptAuthenticationRequest(BuildContext context,{String? pin}) async {
    Onegini.instance.setEventContext(context);
    try {
      await Onegini.instance.channel
          .invokeMethod(Constants.acceptOtpAuthenticationRequest);
    } on PlatformException catch (error) {
      throw error;
    }
  }
}