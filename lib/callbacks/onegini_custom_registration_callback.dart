import 'package:flutter/services.dart';
import 'package:onegini/constants/constants.dart';

import '../onegini.dart';

class OneginiCustomRegistrationCallback {
    Future<void> submitSuccessAction(String identityProviderId, String? token) async {
        await Onegini.instance.channel.invokeMethod(
            Constants.submitCustomRegistrationAction,
            <String, dynamic>{
                'identityProviderId': identityProviderId,
                'token': token
            }
        );
    }

    Future<void> submitErrorAction(String identityProviderId, String error) async {
        await Onegini.instance.channel.invokeMethod(
            Constants.cancelCustomRegistrationAction,
            <String, String>{
                'identityProviderId': identityProviderId,
                'error': error,
            }
        );
    }
}
