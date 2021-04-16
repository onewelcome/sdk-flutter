
# Authenticate User


Starts authentication flow.
If [registeredAuthenticatorId] is null, starts authentication by default authenticator.
Usually it is Pin authenticator.


    var userId = await Onegini.instance.userClient
        .authenticateUser(context, registeredAuthenticatorId)
        .catchError((error) {
            print("Authentication failed: " + error.message);
        });

    if (userId != null) {
        print("Authentication success!");
    }
