
# Change Pin


Starts change pin flow.


    Onegini.instance.userClient
        .changePin(context)
        .catchError((error) {
        if (error is PlatformException) {
            print("Pin change failed");
        }
    });
