import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onegini/events/fingerprint_event.dart';
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini_example/ow_broadcast_helper.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:onegini_example/screens/fingerprint_screen.dart';

// Event Subscriptions related to the creation of Pin
List<StreamSubscription<OWEvent>> initFingerprintSubscriptions(
    BuildContext context) {
  var fingerprintOverlay = OverlayEntry(builder: (context) {
    return Container(
        color: Colors.black12.withOpacity(0.5),
        child: Center(
          child: CircularProgressIndicator(),
        ));
  });

  var openSub = _getOpenFingerprintSub(context);
  var closeSub = _getCloseFingerprintSub(context, fingerprintOverlay);
  var showScanningSub =
      _getShowScanningFingerprintSub(context, fingerprintOverlay);
  var receivedSub = _getReceivedFingerprintSub(fingerprintOverlay);

  return [openSub, closeSub, showScanningSub, receivedSub];
}

StreamSubscription<OWEvent> _getOpenFingerprintSub(BuildContext context) {
  return OWBroadcastHelper.createStream<OpenFingerprintEvent>().listen((event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FingerprintScreen()),
    );
  });
}

StreamSubscription<OWEvent> _getCloseFingerprintSub(
    BuildContext context, OverlayEntry fingerprintOverlay) {
  return OWBroadcastHelper.createStream<CloseFingerprintEvent>()
      .listen((event) {
    fingerprintOverlay.remove();
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  });
}

StreamSubscription<OWEvent> _getShowScanningFingerprintSub(
    BuildContext context, OverlayEntry fingerprintOverlay) {
  return OWBroadcastHelper.createStream<ShowScanningFingerprintEvent>()
      .listen((event) {
    Overlay.of(context).insert(fingerprintOverlay);
  });
}

StreamSubscription<OWEvent> _getReceivedFingerprintSub(
    OverlayEntry fingerprintOverlay) {
  return OWBroadcastHelper.createStream<NextFingerprintAuthenticationAttempt>()
      .listen((event) {
    fingerprintOverlay.remove();
  });
}
