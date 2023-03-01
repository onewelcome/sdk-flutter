import 'package:onegini/constants/constants.dart';

import '../onegini.dart';

class OneginiCustomRegistrationCallback {
    Future<void> submitSuccessAction(String identityProviderId, String? data) async {
        await Onegini.instance.channel.invokeMethod(
            Constants.submitCustomRegistrationAction,
            <String, String?>{
                'identityProviderId': identityProviderId,
                'data': data
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
