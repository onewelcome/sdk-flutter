# Flutter (beta)

## Getting started

in pubspec.yaml add this:

dependencies:

  onegini:

      git:

        url: git@gitlab.com:develocraft/onegini-flutter-sdk-wrapper.git

`flutter clean`

`flutter pub get`

The first time running you have to fetch flutter packages.
Onegini class - main class for comunication between flutter and Native platforms.
The user is able to run the example of SDK in the 'Example' section of the library.

## SDK Configuration

1. Get access to https://repo.onegini.com/artifactory/onegini-sdk
2. Use https://github.com/Onegini/onegini-sdk-configurator on your application (instructions can be found there)

## Onegini Documentation
1. Android https://docs.onegini.com/msp/stable/android-sdk/.com/msp/stable/ios-sdk/
2. iOS https://docs.onegini.com/msp/stable/ios-sdk/

## App Configuration

#### Android: 

1. Modify `android/app/build.gradle`:

    1.1. Add to `android` section:

    
    lintOptions {
        abortOnError false
    }
    

    1.2 Add to `android` -> `defaultConfig` section:
    
    
    minSdkVersion 21
    multiDexEnabled true
    

2. Add to `android/app/proguard-rules.pro`:
    
    -keep class com.onegini.mobile.SecurityController { *; }
    

3. Add to `android/build.gradle`[allprojects.repositories]:

    
    dependencies {
        classpath 'com.android.tools.build:gradle:4.0.1'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }

    

    
    mavenCentral()
            maven {
            /*
            Before the release please change the url below to: https://repo.onegini.com/artifactory/onegini-sdk
            Please change it back to https://repo.onegini.com/artifactory/public after the release
            */
            url "https://repo.onegini.com/artifactory/onegini-sdk"
            credentials {
                username "YOUR_USERNAME"
                password "YOUR_PASSWORD"
            }
	}


    
4. Modify `android/app/src/main/AndroidManifest.xml`. Add `<intent-filter>` to your .MainActivity for listening browser redirects. !!! scheme="oneginiexample" should be changed to your(will be provided by onegini-sdk-configurator) schema:
    
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />

        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>

        <data android:scheme="oneginiexample"/>
    </intent-filter>



#### iOS: 

1. The Onegini SDK is uploaded to the Onegini Artifactory repository. In order to let CocoaPods use an Artifactory repository you need to install a specific plugin.
    ```
    gem install cocoapods-art
    ```
2. The Onegini SDK repository is not a public repository. You must provide credentials in order to access the repo. Create a file named .netrc in your Home folder (~/) and add the following contents to it:
    ```
    machine repo.onegini.com
    login <username>
    password <password>
    ```
    Replace the <username> and <password> with the credentials that you use to login to support.onegini.com.

3. The Onegini CocoaPods repository must be added to your local machine using the following command:
    ```
    pod repo-art add onegini https://repo.onegini.com/artifactory/api/pods/cocoapods-public
    ```

4. In order to update the Repository you must manually perform an update:
    ```
    pod repo-art add onegini https://repo.onegini.com/artifactory/api/pods/cocoapods-public
    ```

5. Add next to `ios/Podfile`(before app target):
    ```
    plugin 'cocoapods-art', :sources => [
    'onegini'
    ]
    ```

6. Run `pod install`    

7. Add `SecurityController.h` and `SecurityController.m` as described [HERE](https://docs.onegini.com/msp/stable/ios-sdk/reference/security-controls.html) to native's part of code.


## Linking Native Code

### IOS >= 12.0

`cd ios && pod install`

#### Example

Download manually SDK. Find `example` folder. Other steps are the same as for package integration, instead, you don't need to modify `pubspec.yaml`.


# Functional scope
## Done on the Android/iOS:
### Milestone 1:
    - Start
    - Security Controls and Configuration of the SDK
    - User registration
       - Browser
    - User deregistration
### Milestone 2:
    -  Secure resource access -  `user-id-decorated`, `devices`, `application-details`.
### Milestone 3:
    - User authentication with PIN
    - Logout
### Milestone 4:
    - User registration
        - Custom identity provider


## Supported Methods

### Access to plugin Methods
    - `Onegini`class - the main facade of the plugin. This class exposes the other Onegini client objects (UserClient and DeviceClient) that you can access from flutter code.
    - every method will generate exceptions if something will go wrong.
    
1. Future<bool> startApplication() async - start configuration via SDK configurator. Has to be called as the first plugin method in the app.

2. Future<ApplicationDetails> getApplicationDetails() async - return security resources for `application-details`.

3. Future<String> getImplicitUserDetails() async - return security resources for `user-id-decorated`.

4. Future<ClientResource> getClientResource() async - return security resources for `devices`.

5. Future<String> registration(BuildContext context) async - return `profileId` of `ONGUserProfil` object after success registration.

6. Future<List<Provider>> getIdentityProviders - return available list of identity providers.

7. Future<String> registrationWithIdentityProvider(String identityProviderId) async - register user with selected identity provider.

8. Future<void> singleSingOn() async - single sign In by app2web [only Android]

9. Future<bool> logOut() async - logout

10. Future<bool> deregisterUser() async - deregister user

11. Future<String> sendPin(String pinCode) async - send entered pin. Now is added Pin screen to the plugin, so it's connected to this screen. For the custom Pin screen, the approach has to changed.
