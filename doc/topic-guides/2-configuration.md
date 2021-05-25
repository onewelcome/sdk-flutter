# Configuration

## Configure your project 

The following steps describe how to configure our native Android and iOS SDKs for your Flutter project.

## Android

1\. Modify `android/app/build.gradle`

1\.1. Add to android section:

    lintOptions {
        abortOnError false 
    }

1\.2. Add to android -> defaultConfig section:

    minSdkVersion 21
    multiDexEnabled true

2\. Add to `android/app/proguard-rules.pro`

    -keep class com.onegini.mobile.SecurityController { *; }

3\. Add to `android/build.gradle [allprojects.repositories]`

    allprojects {
        repositories {
            google()
            jcenter()
            maven {
                url "https://repo.onegini.com/artifactory/onegini-sdk"
                credentials {
                    username 'YOUR_USERNAME'
                    password 'YOUR_PASSWORD'
                }
            }
        }
    }

4\. Setup the Onegini config: Generate a [OneginiConfigModel](https://gitlab.com/develocraft/onegini-flutter-sdk-example-app/-/blob/develop/android/app/src/main/kotlin/com/example/onegini_test/OneginiConfig.kt) and `keystore.bks` with [SDK Configurator](https://github.com/Onegini/onegini-sdk-configurator#android).

More information [HERE](https://docs.onegini.com/msp/stable/android-sdk/topics/setting-up-the-project.html#verifying), section: Running the SDK Configurator.

5\. Setup the [SecurityController](https://gitlab.com/develocraft/onegini-flutter-sdk-example-app/-/blob/develop/android/app/src/main/kotlin/com/example/onegini_test/SecurityController.kt) (not required).

In order to change security options you should create your own instance of SecurityController and handle it to OneginiSdk. By default security options brought from com.onegini.mobile.SecurityController. 

More information [HERE](https://docs.onegini.com/msp/stable/android-sdk/reference/security-controls.html#examples), section: SecurityController.

6\. In your `MainActivity` class, in the `onCreate()` method you must add [OneginiConfigModel](https://gitlab.com/develocraft/onegini-flutter-sdk-example-app/-/blob/develop/android/app/src/main/kotlin/com/example/onegini_test/OneginiConfig.kt) and [SecurityController](https://gitlab.com/develocraft/onegini-flutter-sdk-example-app/-/blob/develop/android/app/src/main/kotlin/com/example/onegini_test/SecurityController.kt).

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        OneginiSDK.oneginiClientConfigModel = OneginiConfigModel()
        OneginiSDK.oneginiSecurityController = SecurityController::class.java
    }

7\. Onegini SDK uses [deep links](https://developer.android.com/training/app-links/deep-linking) for communication between WEB pages and your app.

Modify `android/app/src/main/AndroidManifest.xml`. Add `<intent-filter>` to your `MainActivity` (pic.3) for listening browser redirects. `scheme="oneginiexample"` should be changed to your from `OneginiConfigModel` (will be provided by onegini-sdk-configurator)

    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="oneginiexample" />
    </intent-filter>

## IOS

1\. The Onegini SDK is uploaded to the Onegini Artifactory repository. In order to let CocoaPods use an Artifactory repository you need to install a specific plugin.

    gem install cocoapods-art

2\. The Onegini SDK repository is not a public repository. You must provide credentials in order to access the repo. Create a file named `.netrc` in your Home folder (~/) and add the following contents to it:

    machine repo.onegini.com
        login <username>
        password <password>

3\. Replace the and with the credentials that you use to login to <support.onegini.com>.

4\. The Onegini CocoaPods repository must be added to your local machine using the following command:

    pod repo-art add onegini https://repo.onegini.com/artifactory/api/pods/cocoapods-public

5\. In order to update the Repository you must manually perform an update:

    pod repo-art add onegini https://repo.onegini.com/artifactory/api/pods/cocoapods-public

6\. Add next to ios/Podfile (before app target):

    plugin 'cocoapods-art', :sources => [
        'onegini'
    ]

7\. Run `pod install`

8\. Add `SecurityController.h` and `SecurityController.m` as described [HERE](https://docs.onegini.com/msp/stable/ios-sdk/reference/security-controls.html) to native's part of code.

### Linking Native Code
	
For iOS we require an additional step to link native code in the xCode project.

#### IOS >= 12.0

Run this command in your project main folder: `cd ios && pod install`
