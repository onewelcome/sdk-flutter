# Getting started

## Introduction

At the very beginning, you need to make sure that you have access to [Onegini SDK](https://docs.onegini.com/onegini-sdk.html). If you don't have a login and password please [contact us](https://www.onegini.com/en-us/about/contact-us).

## Add the plugin to your project

To start using the plugin, you will need to follow a few simple steps:

- Open [pubspec.yaml](https://dart.dev/tools/pub/pubspec) file in your project 

- Add dependency  `- Onegini: ^x.y.z`.

- Run `flutter pub get` command.

And that's all, the plugin is ready to go. Now you need to configure your native project for Onegini SDK to start work.

## Configure your project

The details about plugin configuration can be found in the [Configuration guide](./2-configuration.md).

## Initialize Onegini Flutter SDK

To start working with the plugin, we need to initialize Onegini SDK by calling `Onegini.instance.startApplication` method. If the initialization was successful, the method will return a list of available user profiles. Otherwise, it will return an error. 

**Example code to initialize SDK:**

    var userProfiles = await Onegini.instance
        .startApplication(OneginiListener(),
            twoStepCustomIdentityProviderIds: ["2-way-otp-api"],
            connectionTimeout: 5,
            readTimeout: 25)
        .catchError((error) {
            print("Initialization failed: " + error.message);
        });
    _appStarted = userProfiles != null;
    if (_appStarted) {
        print("Initialization success!");
    }

## Example

Download manually SDK. Find the `example` folder. Other steps are the same as for package integration, instead, you don't need to modify `pubspec.yaml`.
