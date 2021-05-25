# Mobile Authentication With OTP

- [`Onegini.instance.userClient.mobileAuthWithOtp`](Onegini.instance.userClient.mobileAuthWithOtp#)

Starts mobile authentication on web by OTP.

## `Onegini.instance.userClient.mobileAuthWithOtp`


- Takes the following arguments:

| Property | Description                     |
| :------- | :------------------------------ |
| `data`   | base64 encoded OTP from QR code |

```dart
var isSuccess = await Onegini.instance.userClient
    .mobileAuthWithOtp(data)
    .catchError((error) {
        print("OTP Mobile authentication request failed: " + error.message);
    });

if (isSuccess != null && isSuccess.isNotEmpty) {
    print("OTP Mobile authentication request success!");
}
```

[^Do not forget]: In order to confirm or deny the authentication request use `acceptAuthenticationRequest` or ``denyAuthenticationRequest` in `OneginiOtpAcceptDenyCallback` class. See [Mobile authentication with OTP](../topic-guides/9-1-mobile-authentication-with-otp)

The success callback contains bool value:

| Property    | Example | Description                  |
| :---------- | :------ | :--------------------------- |
| `isSuccess` | true    | User authenticated correctly |

The error callback contains an object with the following properties.

| Property  | Example         | Description                      |
| :-------- | :-------------- | :------------------------------- |
| `code`    | 10000           | The error code                   |
| `message` | "General error" | Human readable error description |

