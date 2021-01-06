import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/model/onegini_event.dart';
import 'package:onegini/onegini_event_listener.dart';
import 'package:onegini_example/screens/pin_screen.dart';



class OneginiListener extends OneginiEventListener {
  @override
  void eventClosePin(BuildContext buildContext) {
    Navigator.of(buildContext).canPop();
  }



  @override
  void openPinConfirmation(BuildContext buildContext) {
    Navigator.of(buildContext)
      ..pop()
      ..push(
        MaterialPageRoute(
            builder: (context) => PinScreen(
                  confirmation: true,
                )),
      );
  }

  @override
  void openPinScreen(BuildContext buildContext) {
    Navigator.push(
      buildContext,
      MaterialPageRoute(builder: (context) => PinScreen()),
    );
  }

  @override
  void eventOther(BuildContext buildContext, OneginiEvent event) {

  }

  @override
  void eventError(BuildContext buildContext,PlatformException error) {
    print(error.message);
  }

}
