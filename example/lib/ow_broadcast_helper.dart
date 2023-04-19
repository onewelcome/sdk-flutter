import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini/onegini.dart';
import 'package:onegini_example/subscription_handlers/browser_registration_subscriptions.dart';
import 'package:onegini_example/subscription_handlers/create_pin_subscriptions.dart';
import 'package:onegini_example/subscription_handlers/custom_registration_subscriptions.dart';
import 'package:onegini_example/subscription_handlers/fingerprint_subscriptions.dart';
import 'package:onegini_example/subscription_handlers/pin_authentication_subscriptions.dart';

class OWBroadcastHelper {
  static Stream<T> createStream<T>() {
    var broadCastController = Onegini.instance.owEventStreamController;

    return broadCastController.stream.where((event) => event is T).cast<T>();
  }

  static List<StreamSubscription<OWEvent>> initRegistrationSubscriptions(BuildContext context) {
    var browserRegistrationSubs = initBrowserRegistrationSubscriptions();
    var createPinSubs = initCreatePinSubscriptions(context);
    var customRegistrationSubs = initCustomRegistrationSubscriptions(context);

    return browserRegistrationSubs + createPinSubs + customRegistrationSubs;
  }

  static List<StreamSubscription<OWEvent>> initAuthenticationSubscriptions(BuildContext context) {
    var pinAuthSubs = initPinAuthenticationSubscriptions(context);
    var fingerprintSubs = initFingerprintSubscriptions(context);

    return pinAuthSubs + fingerprintSubs;
  }

  static void stopListening(List<StreamSubscription<OWEvent>> subscriptions) {
    subscriptions.forEach((element) { element.cancel(); });
  }
}
