
# Mobile Authentication With OTP


Starts mobile authentication on web by OTP.


    Future<String> mobileAuthWithOtp(String data) async {
      try {
        var isSuccess = await Onegini.instance.channel
            .invokeMethod(Constants.handleMobileAuthWithOtp, <String, dynamic>{
          'data': data,
        });
        return isSuccess;
      } on PlatformException catch (error) {
        throw error;
      }
    }
