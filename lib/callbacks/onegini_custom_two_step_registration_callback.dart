
import 'package:flutter/services.dart';
import 'package:onegini/constants/constants.dart';

import '../onegini.dart';

class OneginiCustomTwoStepRegistrationCallback{

  Future<void> returnSuccess(String data) async {

    try {
      await Onegini.instance.channel
          .invokeMethod(Constants.customTwoStepRegistrationReturnSuccess, <String, String?>{
        'data': data,
      });
    } on PlatformException catch (error) {
      throw error;
    }

  }

  Future<void> returnError(String error) async {
    try {
      await Onegini.instance.channel
          .invokeMethod(Constants.customTwoStepRegistrationReturnError, <String, String?>{
        'error': error,
      });
    } on PlatformException catch (error) {
      throw error;
    }
  }

}