# User registration

## Introduction

User registration is a fundamental part of the Onegini Mobile Security Platform. As developer you have a couple options to handle this process:

## Register by default browser

To start the user registration using WebView or browser you can `Onegini.instance.userClient.registerUser(BuildContext context, String? identityProviderId, String scopes)` method. Calling this method will launch a browser where you need to register. If registration is successful, the browser will return a link that can be caught. After the registration process is completed, the method will return the string value of userID. This will mean that the user has successfully registered. 

    var userId = await Onegini.instance.userClient
        .registerUser(context, identityProviderId, "read")
        .catchError((error) {
        print("Registration failed: " + error.message);
    })

    if (userId != null) {
        print("Registration success!");
    }


## Choosing an identity provider

To select an identity provider which will be used during the registration process you need to pass its id in the place of the `identityProviderId` param. To choose an identity provider, first you need to get all available providers. Call the method `Onegini.instance.userClient.getRegisteredAuthenticators(context)` to get a list with available providers id. If this parameter isn’t specified or if its value is `null` the default identity provider set on the **Token Server** will be used.

