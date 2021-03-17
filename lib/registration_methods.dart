import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants/constants.dart';
import 'model/onegini_identity_provider.dart';
import 'onegini.dart';

class RegistrationMethods {
  Future<String> registration(BuildContext context, String scopes) async {
    Onegini.instance.setEventContext(context);
    try {
      var userId = await Onegini.instance.channel.invokeMethod(
          Constants.registrationMethod, <String, String>{'scopes': scopes});
      return userId;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<List<OneginiIdentityProvider>> getIdentityProviders(
      BuildContext context) async {
    Onegini.instance.setEventContext(context);
    try {
      var providers = await Onegini.instance.channel
          .invokeMethod(Constants.getIdentityProvidersMethod);
      return providerFromJson(providers);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<String> registrationWithIdentityProvider(
      String identityProviderId, String scopes) async {
    try {
      var userId = await Onegini.instance.channel.invokeMethod(
          Constants.registrationWithIdentityProviderMethod, <String, String>{
        'identityProviderId': identityProviderId,
        'scopes': scopes
      });
      return userId;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<bool> deregisterUser() async {
    try {
      var isSuccess = await Onegini.instance.channel
          .invokeMethod(Constants.deregisterUserMethod);
      return isSuccess;
    } on PlatformException catch (error) {
      throw error;
    }
  }

  Future<void> cancelRegistration() async {
    try {
      await Onegini.instance.channel
          .invokeMethod(Constants.cancelRegistrationMethod);
    } on PlatformException catch (error) {
      throw error;
    }
  }
}
