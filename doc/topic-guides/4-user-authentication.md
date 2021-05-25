# User authentication

- [Introduction](#Introduction)
- [Registering a user](#Registering a user)
- [Authenticate a registered user](#Authenticate a registered user)

## Introduction

The Flutter Plugin allows for user authentication with either a registered authenticator or with a pin. Both cases are based on the same method, however a different value for `registeredAuthenticatorId` is required.

## Registering a user

The OAuth 2.0 protocol begins with registration. The `Onegini.instance.userClient.registerUser` function can be used to register a user. This function can take an array of scopes that authentication is requested for as argument.

When registering a user, the Flutter Plugin redirects the user to the authentication endpoint on the Token Server via the browser. Once the client credentials have been validated, and an authorization grant has been issued, the user will be redirected to the app. Based on this authorization grant, the client will request an access token for the specified set of scopes. If the grant includes a refresh token, the user will need to create a PIN.

**Example code to register a user:**

```dart
 var registrationResponse = await Onegini.instance.userClient.registerUser(
        context,
        identityProviderId,
        ["read"],
      );
```

The `Onegini.instance.userClient.registerUser` function make `openPinRequestScreen` event call in your `OneginiEventListener` implementation for which we need to implement the UI.

**Example code to handle openPinRequestScreen event :**

```dart
@override
  void openPinRequestScreen(BuildContext buildContext) {
   **[Your code here]**
  }

```



## Authenticate a registered user

Once a user has been registered, it can be logged in using the `Onegini.instance.userClient.authenticateUser(BuildContext context, String? registeredAuthenticatorId)` method. This method takes the id of a registered authenticator and uses it to authenticate the user. The **id** param can also be `null` in which case the default authenticator (**PIN**) will be used. 

**Example code to log in a user:**

    var userId = await Onegini.instance.userClient
        .authenticateUser(context, registeredAuthenticatorId)
        .catchError((error) {
            print("Authentication failed: " + error.message);
        });
    
    if (userId != null) {
        print("Authentication success!");
    }

The result of successful authentication is the string value of `userId`.

The `Onegini.instance.userClient.authenticateUser` function make `openPinScreenAuth` event call in your `OneginiEventListener` implementation for which we need to implement the UI.

**Example code to handle openPinScreenAuth event :**

```
 @override
  void openPinScreenAuth(BuildContext buildContext) {
     **[Your code here]**
  }

```

If the authentication fails, the refresh token is removed from the device.
