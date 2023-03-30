import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/constants/constants.dart';
import 'package:onegini/onegini_event_listener.dart';
import 'package:onegini/resources_methods.dart';
import 'package:onegini/user_client.dart';
import 'package:onegini/pigeon.dart';

import 'model/onegini_removed_user_profile.dart';

/// The main class used to call methods.
class Onegini {
  final UserClientApi api = UserClientApi();
  late final UserClient userClient;

  Onegini._internal() {
    userClient = UserClient(api);
  }

  static final Onegini instance = Onegini._internal();

  factory Onegini() => instance;

  /// Communication channel between flutter and native side.
  final MethodChannel channel = const MethodChannel('onegini');

  /// Reference to the event listener.
  OneginiEventListener? _eventListener;

  /// Resource methods.
  ResourcesMethods resourcesMethods = ResourcesMethods();

  // UserClientApi is the flutter to native api created by the Pigeon package, see /pigeons/README.md
  /// User client methods.

  /// Use this method when you want change [BuildContext] in your [OneginiEventListener]
  setEventContext(BuildContext? context) {
    _eventListener?.context = context;
  }

  /// Initialize SDK and establish communication on [eventListener].
  Future<void> startApplication(
    OneginiEventListener eventListener, {
    String? securityControllerClassName,
    String? configModelClassName,
    List<OWCustomIdentityProvider>? customIdentityProviderConfigs,
    int? connectionTimeout,
    int? readTimeout,
  }) async {
    _eventListener = eventListener;
    NativeCallFlutterApi.setup(_eventListener);
    await api.startApplication(
        securityControllerClassName,
        configModelClassName,
        customIdentityProviderConfigs,
        connectionTimeout,
        readTimeout);
  }
}
