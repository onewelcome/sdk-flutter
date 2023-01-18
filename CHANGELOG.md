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
