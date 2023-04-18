import 'dart:async';

import 'package:flutter/services.dart';
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini/onegini_event_listener.dart';
import 'package:onegini/resources_methods.dart';
import 'package:onegini/user_client.dart';
import 'package:onegini/pigeon.dart';

/// The main class used to call methods.
class Onegini {
  // UserClientApi is the flutter to native api created by the Pigeon package, see /pigeons/README.md
  /// User client methods.
  final UserClientApi api = UserClientApi();

  late final UserClient userClient;

  // Stream over which OW events will be send
  final StreamController<OWEvent> owEventStreamController = StreamController<OWEvent>.broadcast();

  // Close the stream when the instance gets stopped
  static final Finalizer<StreamController<OWEvent>> _finalizer =
      Finalizer((owEventStreamController) => owEventStreamController.close());

  Onegini._internal() {
    userClient = UserClient(api);
  }

  static final Onegini instance = Onegini._internal();

  factory Onegini() {
    _finalizer.attach(instance, instance.owEventStreamController, detach: instance);
    return instance;
  }

  /// Communication channel between flutter and native side.
  final MethodChannel channel = const MethodChannel('onegini');

  /// Resource methods.
  ResourcesMethods resourcesMethods = ResourcesMethods();

  /// Initialize SDK and establish communication on [eventListener].
  Future<void> startApplication({
    String? securityControllerClassName,
    String? configModelClassName,
    List<OWCustomIdentityProvider>? customIdentityProviderConfigs,
    int? connectionTimeout,
    int? readTimeout,
  }) async {
    NativeCallFlutterApi.setup(OneginiEventListener(owEventStreamController));
    await api.startApplication(
        securityControllerClassName,
        configModelClassName,
        customIdentityProviderConfigs,
        connectionTimeout,
        readTimeout);
  }
}
