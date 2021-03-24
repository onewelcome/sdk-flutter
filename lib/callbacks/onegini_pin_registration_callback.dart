import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/constants/constants.dart';

import '../onegini.dart';


class OneginiPinRegistrationCallback{


  Future<void> denyAuthenticationRequest() async {
    try {
      await Onegini.instance.channel
          .invokeMethod(Constants.denyPinRegistrationRequest);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<void> acceptAuthenticationRequest(BuildContext context,{String? pin, bool isCustomAuthenticator = false}) async {
    Onegini.instance.setEventContext(context);
    try {
      await Onegini.instance.channel
          .invokeMethod(Constants.acceptPinRegistrationRequest, <String, String?>{
        'pin': pin, 'isCustomAuth': isCustomAuthenticator ? "true" : null,
      });
    } on PlatformException catch (error) {
      throw error;
    }
  }

}