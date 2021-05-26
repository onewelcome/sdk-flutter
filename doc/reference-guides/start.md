# Start


The first thing that needs to be done when the app starts is to initizialize the Onegini Flutter Plugin. This will perform a few checks and report an error in case of trouble.


    var removedUserProfiles = await Onegini.instance
            .startApplication(OneginiListener(),
                twoStepCustomIdentityProviderIds: ["2-way-otp-api"],
                connectionTimeout: 5,
                readTimeout: 25)
            .catchError((error) {
            if (error is PlatformException) {
                Fluttertoast.showToast(
                    msg: error.message,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black38,
                    textColor: Colors.white,
                    fontSize: 16.0);
          }
    });
