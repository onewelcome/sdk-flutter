# Change PIN

- [Changing PIN](#Changing PIN)



## Changing PIN

The Onegini Flutter plugin exposes a function (`Onegini.instance.userClient.changePin`) to allow the currently logged in user to change their PIN. 

**Example code to change PIN of currently logged in user:**

    Onegini.instance.userClient
        .changePin(context)
        .catchError((error) {
            print("Pin change failed");
        });

The user is first required to provide their current PIN, before being allowed to create the new PIN. Both events will be called on class which will extend `OneginiEventListener` and was passed to the plugin with the `Onegini.instance.startApplication()` method.

In order to send a pin from a widget use `OneginiPinAuthenticationCallback()` and `OneginiPinRegistrationCallback()`.

**Example code to handle openPinScreenAuth event :**

```dart
 @override
  void openPinScreenAuth(BuildContext buildContext) {
     **[Your code here]**
     OneginiPinAuthenticationCallback()
         .acceptAuthenticationRequest(buildContext, pin: **[USER PIN]**)
  }

```

**Example code to handle openPinRequestScreen event :**

```dart
@override
  void openPinRequestScreen(BuildContext buildContext) {
   **[Your code here]**
   OneginiPinRegistrationCallback()
       .acceptAuthenticationRequest(buildContext, pin: **[USER PIN]**)
  }

```



Note that the PIN entered by the user should **not** be stored on the device or elsewhere in any shape or form. The Onegini Flutter plugin takes care of this for you in a secure manner.
