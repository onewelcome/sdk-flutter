
# Mobile Authentication With OTP


Starts mobile authentication on web by OTP.


    var isSuccess = await Onegini.instance.userClient
        .mobileAuthWithOtp(data)
        .catchError((error) {
            print("OTP Mobile authentication request failed: " + error.message);
        });

    if (isSuccess != null && isSuccess.isNotEmpty) {
        print("OTP Mobile authentication request success!");
    }
