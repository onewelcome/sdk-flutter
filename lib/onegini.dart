import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/constants/constants.dart';
import 'package:onegini/onegini_event_listener.dart';
import 'package:onegini/resources_methods.dart';
import 'package:onegini/user_client.dart';

import 'model/onegini_removed_user_profile.dart';

/// The main class used to call methods.
class Onegini {
  Onegini._privateConstructor();

  /// Reference to the Onegini instance.
  static final Onegini _instance = Onegini._privateConstructor();

  /// Public access to the Onegini instance.
  static Onegini get instance => _instance;

  /// Communication channel between flutter and native side.
  final MethodChannel channel = const MethodChannel('onegini');

  /// Reference to the event listener.
  OneginiEventListener? _eventListener;

  /// Resource methods.
  ResourcesMethods resourcesMethods = ResourcesMethods();

  /// User client methods.
  UserClient userClient = UserClient();

  /// Use this method when you want change [BuildContext] in your [OneginiEventListener]
  setEventContext(BuildContext? context) {
    _eventListener?.context = context;
  }

  /// Initialize SDK and establish communication on [eventListener].
  Future<List<RemovedUserProfile>> startApplication(
    OneginiEventListener eventListener, {
    String? securityControllerClassName,
    String? configModelClassName,
    List<String>? twoStepCustomIdentityProviderIds,
    int? connectionTimeout,
    int? readTimeout,
  }) async {
    _eventListener = eventListener;
    try {
      String removedUserProfiles = await channel
          .invokeMethod(Constants.startAppMethod, <String, dynamic>{
        'securityControllerClassName': securityControllerClassName,
        'configModelClassName': configModelClassName,
        'twoStepCustomIdentityProviderIds': twoStepCustomIdentityProviderIds,
        'connectionTimeout': connectionTimeout,
        'readTimeout': readTimeout
      });
      eventListener.listen();
      return removedUserProfileListFromJson(removedUserProfiles);
    } on PlatformException catch (error) {
      throw error;
    }
  }
}
