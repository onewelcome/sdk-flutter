import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/constants/constants.dart';
import 'package:onegini/onegini_event_listener.dart';
import 'package:onegini/resources_methods.dart';
import 'package:onegini/user_client.dart';

import 'model/onegini_removed_user_profile.dart';

class Onegini {
  Onegini._privateConstructor();

  static final Onegini _instance = Onegini._privateConstructor();

  static Onegini get instance => _instance;

  final MethodChannel channel = const MethodChannel('onegini');
  OneginiEventListener? _eventListener;

  ResourcesMethods resourcesMethods = ResourcesMethods();
  UserClient userClient = UserClient();

  setEventContext(BuildContext context) {
    _eventListener?.context = context;
  }

  Future<List<RemovedUserProfile>> startApplication(
    OneginiEventListener eventListener, {
    List<String>? twoStepCustomIdentityProviderIds,
    int? connectionTimeout,
    int? readTimeout,
  }) async {
    _eventListener = eventListener;
    try {
      String removedUserProfiles = await channel
          .invokeMethod(Constants.startAppMethod, <String, dynamic>{
        'twoStepCustomIdentityProviderIds':
            twoStepCustomIdentityProviderIds?.join(","),
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
