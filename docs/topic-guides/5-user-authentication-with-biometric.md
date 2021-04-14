# User authentication with system biometric authenticators

## Introduction

The Onegini Flutter plugin allows you to authenticate users with the system biometric authenticators. These authenticators are provided by the device's operating system (iOS - Touch ID and Face ID, Android - fingerprint) if they are available on the device. System biometric authenticators can be used for both: regular and mobile authentication. Users will be able to retry system biometric authentication as many times as the OS allows them to. If the OS system's biometric authenticators API returns an error for any reason (for example in case of too many failed attempts), the Onegini Flutter plugin will revoke system biometric authenticator and will perform a fallback to PIN authentication.

### Requirements

#### FaceID

iOS needs to have configured message displayed on FaceID alert. It's configurable by adding `NSFaceIDUsageDescription` in your `Info.plist` file.

**Example configuration**

	<key>NSFaceIDUsageDescription</key>
	<string>FaceID is used as a authenticator to login to application.</string>

Not specifying this property in your configuration will crash your application when you will try to use Face ID authentication.

### Differences between Android and iOS

It should be noted that there are significant differences between Fingerprint on Android and Touch ID on iOS. As a result, some methods may be available on only one of the operating systems. This will be specified where applicable.

## Enabling system biometric authenticator authentication

In order to enable fingerprint authenticator authentication for a user, the Onegini Flutter plugin provides the `Onegini.instance.userClient.registerAuthenticator` to which you need to pass `authenticatorId`. This function requires the user to authenticate.

    await Onegini.instance.userClient
        .registerAuthenticator(context, authenticatorId)
        .catchError((error) {
            print("Register authenticator failed: " + error.message);
        });

After calling that method you should receive `openFingerprintScreen` or `fingerprintFallbackToPin` events.

Fingerprint authentication may not be available on every device. In this case, or if the authenticator has already been registered, the above method will return an error.

To request a list of available authenticators that have not yet been registered, the plugin exposes the `Onegini.instance.userClient.getNotRegisteredAuthenticators` function. If the device does not meet the fingerprint requirements, the fingerprint authenticator will not be present in the returned array of of authenticators.

## Authenticating a user with fingerprint

Once the fingerprint authenticator has been registered and set as the preferred authenticator, the user is able to authenticate using fingerprint. The method to do so is the same as for PIN, the `Onegini.instance.userClient.authenticateUser(BuildContext context, String? registeredAuthenticatorId)` method, but requires `registeredAuthenticatorId`.

However, if fingerprint authentication is a possibility for the user, extra handler methods must be implemented. This is in addition to the PIN specific methods (which are necessary in case of fallback to PIN).

#### TODO
- [ ] finish description for authenticating with fingerprint



## authentication with fingerprint

### register fingerprint authenticator

In order to enable fingerprint authenticator authentication for a user, the Onegini Flutter plugin provides the Onegini.registerFingerprint. This function requires the user to authenticate. 

### use fingerprint authenticator 

this authenticator will be available in the list of registered authenticators. 

note: When you get ready scan fingerprint use Onegini.activateFingerprintSensor

