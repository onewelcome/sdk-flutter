
# Register Authenticator


Registers authenticator from [getNotRegisteredAuthenticators] list.


    await Onegini.instance.userClient
            .registerAuthenticator(context, authenticatorId)
            .catchError((error)
