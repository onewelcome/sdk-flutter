# Bootstrapping the Onegini Flutter Plugin

The first thing that needs to be done when the app starts is to initizialize the Onegini Cordova Plugin. This will perform a few checks and report an error in case of trouble.

## `Onegini.instance.startApplication`



Takes objects with a `OneginiEventListener`,  `twoStepCustomIdentityProviderIds`, `connectionTimeout`  and `readTimeout`  property:

| Property                           | Default | Description                                            |
| :--------------------------------- | :------ | :----------------------------------------------------- |
| `OneginiEventListener`             | -       | Class where user handle all events from Onegini plugin |
| `twoStepCustomIdentityProviderIds` | []      | List of id`s custom two step identity providers        |
| `connectionTimeout`                | 5       | connection timeout of REST requests                    |
| `readTimeout`                      | 25      | read timeout of REST requests                          |

```js
var removedUserProfiles = await Onegini.instance
        .startApplication(OneginiListener(),
            twoStepCustomIdentityProviderIds: ["2-way-otp-api"],
            connectionTimeout: 5,
            readTimeout: 25)
        .catchError((error) {
      
      }
});
```

The success callback contains list of `RemovedUserProfile` objects with these properties:

| Property    | Example  | Description                               |
| :---------- | :------- | :---------------------------------------- |
| `profileId` | "QWERTY" | A profile ID associated with the user     |
| `isDefault` | false    | Shows if this user is selected by default |

The error callback contains an object with these properties:

| Property      | Example                        | Description                      |
| :------------ | :----------------------------- | :------------------------------- |
| `code`        | 10001                          | The error code                   |
| `description` | "Onegini: Configuration error" | Human readable error description |


