# Mobile authentication

- [Introduction](#Introduction)
- [Setup and requirements](#Setup and requirements)
- [Enrollment](#Enrollment)



## Introduction

The Onegini Mobile Security Platform offers a mobile authentication mechanism in a user friendly and secure way. You can for instance take advantage of mobile authentication to add second factor authentication to your product, that can be used to improve the security of selected actions like logging into your website or accepting a transaction payment.

The mobile authentication feature is an extensive feature that has a number of different possibilities. E.g. there are different ways that mobile authentication is triggered / received on a mobile device:

- With an One-Time-Password (OTP); The user provides an OTP in order to confirm a mobile authentication transaction. Since the OTP is long it is likely that the OTP is transformed into a QR code and the user scans this code with his mobile device.

## Setup and requirements

Before mobile authentication can be used, you should configure the Token Server to support this functionality. Please follow the [Mobile authentication configuration](https://docs.onegini.com/msp/stable/token-server/topics/mobile-apps/mobile-authentication/mobile-authentication.html) guide to set it up.

When the Token Server is configured, you can enroll and handle mobile authentication requests using the Onegini SDK.

## Enrollment

The mobile authentication enrollment starts by `Onegini.instanse.enrollUserForMobileAuth()`



**Example code user of start enroll:**

```dart
var success = await Onegini.instance.userClient.enrollUserForMobileAuth()
```



Successive invocations of enrollment for mobile authentication will re-enroll the device only if the mobile authentication override is enabled in The Token Server configuration. See the [Token Server mobile authentication configuration](https://docs.onegini.com/msp/stable/token-server/topics/mobile-apps/mobile-authentication/mobile-authentication.html) for more information on the server side configuration of mobile authentication.
