import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onegini/events/fingerprint_event.dart';
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini/events/pin_event.dart';
import 'package:onegini_example/components/display_toast.dart';
import 'package:onegini_example/ow_broadcast_helper.dart';
import 'package:onegini_example/screens/fingerprint_screen.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:onegini_example/screens/pin_request_screen.dart';

// Event Subscriptions related to the creation of Pin
class FingerprintSubscriptions {
  static List<StreamSubscription<OWEvent>> getSubscriptions(BuildContext context) {
    var fingerprintOverlay = OverlayEntry(builder: (context) {
      return Container(
          color: Colors.black12.withOpacity(0.5),
          child: Center(
            child: CircularProgressIndicator(),
          ));
    });

    var openSub = _getOpenFingerprintSub(context);
    var closeSub = _getCloseFingerprintSub(context);
    var showScanningSub =  _getShowScanningFingerprintSub(context, fingerprintOverlay);
    var receivedSub = _getReceivedFingerprintSub(fingerprintOverlay);

    return [openSub, closeSub, showScanningSub, receivedSub];
  }

  static StreamSubscription<OWEvent> _getOpenFingerprintSub(BuildContext context) {
    return OWBroadcastHelper.createStream<OpenFingerprintEvent>().listen((event) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FingerprintScreen()),
      );
    });
  }

  static StreamSubscription<OWEvent> _getCloseFingerprintSub(BuildContext context) {
    return OWBroadcastHelper.createStream<CloseFingerprintEvent>().listen((event) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  static StreamSubscription<OWEvent> _getShowScanningFingerprintSub(BuildContext context, OverlayEntry fingerprintOverlay) {
    return OWBroadcastHelper.createStream<ShowScanningFingerprintEvent>().listen((event) {
      Overlay.of(context).insert(fingerprintOverlay);
    });
  }

  static StreamSubscription<OWEvent> _getReceivedFingerprintSub(OverlayEntry fingerprintOverlay) {
    return OWBroadcastHelper.createStream<PinNotAllowedEvent>().listen((event) {
      fingerprintOverlay.remove();
    });
  }
}