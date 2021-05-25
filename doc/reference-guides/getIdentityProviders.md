# Get Identity Providers

- [Introduction](#introduction)
- [`Onegini.instance.userClient.getIdentityProviders`](#Onegini.instance.userClient.getIdentityProviders)

## Introduction

**OneginiIdentityProvider** interface allows you to take control over of user registration possibilities offered by the **Token Server**. The interface is used to specify which identity provider should be used during user registration. Identity providers can be created in the **Token Server** -> **Configuration** -> **Identity Providers**.

## `Onegini.instance.userClient.getIdentityProviders`

- Used to get an array of all existing identity providers.

```dart
var providers = await Onegini.instance.userClient
    .getIdentityProviders(context)
```

The success callback contains an array of `OneginiListResponse` with these properties:

| Property | Example                 | Description                                    |
| :------- | :---------------------- | :--------------------------------------------- |
| `id`     | 78365-78634-387bc-cb674 | A unique id of the identity provider           |
| `name`   | LDAP                    | A human-readable name of the identity provider |

The error callback contains an object with these properties:

| Property  | Example         | Description                      |
| :-------- | :-------------- | :------------------------------- |
| `code`    | 10000           | The error code                   |
| `message` | "General error" | Human-readable error description |
