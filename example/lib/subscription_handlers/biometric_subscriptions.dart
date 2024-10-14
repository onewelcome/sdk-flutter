import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onegini/events/biometric_event.dart';
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini_example/ow_broadcast_helper.dart';
import 'package:onegini/callbacks/onegini_biometric_callback.dart';

// Event Subscriptions related to biometric prompt
List<StreamSubscription<OWEvent>> initBiometricSubscriptions(
    BuildContext context) {

  var openSub = _getOpenBiometricSub(context);
  var closeSub = _getCloseBiometricSub(context);
  return [openSub, closeSub];
}

StreamSubscription<OWEvent> _getOpenBiometricSub(BuildContext context) {
  return OWBroadcastHelper.createStream<StartBiometricAuthEvent>().listen((event) {
    OneginiBiometricCallback().showBiometricPrompt("Biometric Authentication", "Authenticate user", "Use PIN");
  });
}

StreamSubscription<OWEvent> _getCloseBiometricSub(BuildContext context) {
  return OWBroadcastHelper.createStream<FinishBiometricAuthEvent>().listen((event) {
  });
}