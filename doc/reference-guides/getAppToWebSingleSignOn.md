# Get App To Web Single Sign On

- [Get App To Web Single Sign On](#)
- [`Onegini.instance.userClient.getAppToWebSingleSignOn`](#)

## Get App To Web Single Sign On



App to Web Single Sign-On allows you to take a session from your mobile application and extend it to a browser on the same device. This is useful for giving a seamless experience to your users when they transition from the mobile application to the website where more functionality likely exists. This functionality can only be used when using **the Onegini CIM identity provider** as it is a unique feature of **the Onegini Consumer Identity Manager**. This can be configured in the **Onegini Token Server Admin**.

**The Onegini SDK** allow you to specify a target URI where authentication is required. This URI must be configured in **the Action Token** configuration of **the Onegini Consumer Identity Manager**. It will then verify that your mobile application's session is valid and establish a session with the **IDP** before redirecting the user to the target URI with them automatically logged in.

## `Onegini.instance.userClient.getAppToWebSingleSignOn`



- Takes the following arguments:

| Property | Description                                                |
| :------- | :--------------------------------------------------------- |
| `url`    | String url for which the Single Sign-On token is requested |

- The success callback contains a `OneginiSingleSignOn` object with these properties:

| Property      | Description                                                  |
| :------------ | :----------------------------------------------------------- |
| `redirectUri` | This is a URL that is meant to be used by the browser to establish a session |
| `token`       | The token param from the `redirectUri` provided as a convenience |

**Example:**

```dart
var oneginiAppToWebSingleSignOn = await Onegini.instance.userClient
        .getAppToWebSingleSignOn(
            "https://login-mobile.test.onegini.com/personal/dashboard")
        .catchError((error) {
        print("Single sign on failed: " + error.message);
    });

if (oneginiAppToWebSingleSignOn) {
   print("Single sign on!");
}
```

 The error callback contains an object with these properties:

| Property  | Example         | Description                      |
| :-------- | :-------------- | :------------------------------- |
| `code`    | 10000           | The error code                   |
| `message` | "General error" | Human-readable error description |

