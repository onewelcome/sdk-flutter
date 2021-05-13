
# Get App To Web Single Sign On


Single sign on the user web page.


    var oneginiAppToWebSingleSignOn = await Onegini.instance.userClient
            .getAppToWebSingleSignOn(
                "https://login-mobile.test.onegini.com/personal/dashboard")
            .catchError((error) {
            print("Single sign on failed: " + error.message);
        });

    if (oneginiAppToWebSingleSignOn) {
       print("Single sign on!");
    }
