
import 'package:flutter/services.dart';
import 'package:onegini/constants/constants.dart';

import '../onegini.dart';


/// A callback of custom two step registration identity provider
class OneginiCustomTwoStepRegistrationCallback{

  /// Returns success result with [data] which are needed for a successful result
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


  /// Returns the error text. Typically used when a user has canceled a registration action.
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