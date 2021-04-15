
# Get App To Web Single Sign On


Single sign on the user web page.


    Future<String> getAppToWebSingleSignOn(String url) async {
      try {
        var oneginiAppToWebSingleSignOn = await Onegini.instance.channel
            .invokeMethod(Constants.getAppToWebSingleSignOn, <String, String>{
          'url': url,
        });
        print(oneginiAppToWebSingleSignOn);
        return oneginiAppToWebSingleSignOn;
      } on PlatformException catch (error) {
        throw error;
      }
    }
