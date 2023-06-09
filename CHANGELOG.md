## 3.0.3, June 9, 2023
* [iOS] Fixed a bug where `ClosePinAuthenticationEvent` wouldn't be emitted, when user cancelled biometric authenticator registration.

## 3.0.2, May 31, 2023
* [iOS] Fix a crash on iOS on failing resource requests.

## 3.0.1, May 30, 2023
* Changed access modifier of a native api in order to hide it from the sdk user.

## 3.0.0, May 3, 2023
You can find the full changelog [here](https://developer.onewelcome.com/flutter/plugin/v2-x) and an overview containing the upgrade instructions [here](https://developer.onewelcome.com/flutter/plugin/v2-0).

[iOS] Wrapper SDK now uses the latest OneWelcome iOS native SDK 12.2.2

* Events are now propagated using Streams and have been renamed to more accurately describe their purpose.
* Removed the following events
  - eventOther
  - openPinAuthenticator
  - eventError
* startApplication now no longer requires a OneginiListener parameter.
* All BuildContext requirements from functions have been removed.
* Resource requests now allow absolute paths.
* Allow for Resource Requests to other resource servers than the one in the tokenserver config file, this is only possible if the server has a correct certificate.
* Updated several parameters and return types of functions.
* Functions are now fully typesafe and nullsafe due to the use of [Pigeon](https://pub.dev/packages/pigeon) internally. 
* Updates several functions to no longer return a boolean status but instead resolve/reject.
  - setPreferredAuthenticator
  - deregisterBiometricAuthenticator
  - logout
  - authenticateDevice
  - validatePinWithPolicy
  - authenticateUserImplicitly
  - deregisterUser
* submitSuccessAction and submitErrorAction for custom registration no longer require an identity provider id.
* getAppToWebSingleSignOn now returns the actual error code instead of a general error when failing.
* OneginiPinRegistrationCallback.acceptAuthenticationRequest No longer takes a map as a second argument.
* Renamed several resourceRequest functions and added a generic requestResource which takes a type as extra argument.
* Reworked error codes and added constants for all errors(wrapper and native) in lib/errors/error_codes.dart
* Reworked mobileAuthWithOtp.
* Reworked authentication
  - Removed getRegisteredAuthenticators
  - Removed getAllAuthenticators
  - Removed registerAuthenticator
  - Added deregisterBiometricAuthenticator
  - Added registerBiometricAuthenticator
  - Added getBiometricAuthenticator
  - Added getPreferredAuthenticator
  - Changed setPreferredAuthenticator
  - Changed authenticateUser
* Allow sdk <4.0.0

## 2.0.1, March 2, 2023
Updated the README

## 2.0.0, March 2, 2023
You can find the full changelog [here](https://developer.onewelcome.com/flutter/plugin/v2-x) and an overview containing the upgrade instructions [here](https://developer.onewelcome.com/flutter/plugin/v2-0).

### Improvement
[Android] Wrapper SDK now uses the latest Android Native SDK 11.9.0

[iOS] Wrapper SDK now uses the latest iOS native SDK 12.1.0

[iOS & Android] The Error Structure has been reworked and extended. This rework introduces:

- More consistency between iOS and Android errors using our Flutter Plugin.
- More specific error codes to give more details on what the error caused.
- Consistent usage of the details property of PlatformExceptions containing an overview and potentially additional information regarding the error.
- Change of error codes

[iOS & Android] Full support for Registration with Custom IdP.

[iOS & Android] Renamed fetchUserProfiles to getUserProfiles to better reflect the functionality from the function.

[iOS & Android] Support for multiple registered users on one device.

[iOS & Android] Reworked deregisterUser function and updated the documentation.

[iOS & Android] Added getAccessToken getAuthenticatedUserProfile and getRedirectUrl methods.


### Bug Fixes
[iOS] deregisterUser now successfully deregisters the profile based on the given Id instead of the first registered user on the device.
[iOS] authenticateUser will now properly return an error when an unregistered or unknown authenticatorId is given instead of starting pin authentication.

## 1.2.0, January 17, 2023
* Update the Android SDK version version to 11.8.1. See [the release notes](https://developer.onewelcome.com/android/android-sdk/11-x) and [upgrade notes](https://developer.onewelcome.com/android/android-sdk/v11-8.1) for more information.
* [Breaking] Bump the compile- and target-SDK of the plugin to version 32 as a consequence of the new Android SDK version.
## 1.1.1, October 10, 2022

* Update podfile for example app to build on m1.
* Created a new WrapperError which is thrown as a platformException when the native SDK returns a value that the wrapper did not expect which would previously cause a typeError.
* Example app no longer requires signing config files for debug.
* Updated `registerAuthenticator` to return Future<void> instead of Future<String>
* Updated example app android and dependency versions.
* Fixed a bug where `handleRegisteredProcessUrl` would never resolve.
* Updated `getResourceAnonymous` `getResource` `getResourceImplicit` `getUnauthenticatedResource` to return a Future<String?> instead of Future<String>
* Added unit tests for UserClient and ResourceMethods to test return types.
* Removed a few files from git which were in gitignore, but were already in version control.

## 1.1.0, April 20, 2022

* Updated the iOS SDK to version 11.0.2. This is a major change in case of tampering protection mechanism. See [the release notes](https://docs-single-tenant.onegini.com/msp/stable/ios-sdk/upgrade-instructions/11.0.0.html) for more information.
* The `BuildContext? context` param in `authenticateUser` method is now nullable.
* The `BuildContext? context` param in `acceptAuthenticationRequest` method is now nullable.

## 1.0.8, March 11, 2022

* Updated the Android SDK to version 11.7.0. See [the release notes](https://docs.onegini.com/projects/android-sdk/en/stable/release-notes/11.X/#1170)
  and [upgrade instructions](https://docs.onegini.com/projects/android-sdk/en/stable/upgrade-instructions/11.7/) for more information.

## 1.0.7, March 3, 2022

* Fixed `authenticateDevice` method for iOS - please make sure authenticate device method is called before fetching anonymous resources.

## 1.0.6, February 7, 2022

* Updated Android SDK to version 11.6.1

## 1.0.5, December 3, 2021

* Fixed object type of result `authenticateUser` method.

## 1.0.4, November 19, 2021

* Fixes and improvements.

## 1.0.3, October 21, 2021

* Bump Android SDK to 11.4.0.
* Modified `buildContext` to be `nullable` in all of the API calls.

## 1.0.2, August 4, 2021

* Updated OneginiSDK to version 11.3.0  (android platform).

## 1.0.1, June 9, 2021

* Resolved an obfuscation issue (android platform).

## 1.0.0, June 8, 2021

* Release version.

## 1.0.0-dev.2, June 7, 2021

* Added a required param `profileId` to the `deregisterUser` method

## 1.0.0-dev.1, May 13, 2021

* The Onegini Flutter Plugin is a plugin that allows you to utilize the Onegini Mobile SDKs in your Flutter applications.
