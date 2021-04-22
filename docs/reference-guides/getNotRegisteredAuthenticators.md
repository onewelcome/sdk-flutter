
# Get Not Registered Authenticators


Returns a list of authenticators available to the user, but not yet registered.


    var authenticators = await Onegini.instance.userClient
            .getNotRegisteredAuthenticators(context);
    if (authenticators.isNotEmpty) {
        print('Not registered authenticators');
    }
