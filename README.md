# Flutter 

## Getting started

in pubspec.yaml add this:

dependencies:

    onegini: 3.0.0

`flutter clean`

`flutter pub get`

The first time running you have to fetch flutter packages.
Onegini class - main class for comunication between flutter and Native platforms.

## SDK Configuration

1. Get access to https://repo.onewelcome.com/artifactory/onegini-sdk
2. Use https://github.com/onewelcome/sdk-configurator on your application (instructions can be found there)

## Onegini Documentation
1. Android https://developer.onewelcome.com/android/sdk
2. iOS https://developer.onewelcome.com/ios/sdk

## App Configuration

#### Android: 

1. Modify `android/app/build.gradle`:

    1.1. Add to `android` section:

    
    lintOptions {
        abortOnError false
    }
    

    1.2 Add to `android` -> `defaultConfig` section:
    
    
    minSdkVersion 23
    compileSdkVersion 33
    multiDexEnabled true
    

2. Add to `android/app/proguard-rules.pro`:
    
    -keep class com.onegini.mobile.SecurityController { *; }
    

3. Add to `android/build.gradle`[allprojects.repositories]:
    ext.kotlin_version = '1.8.0'
    
    dependencies {
        classpath 'com.android.tools.build:gradle:7.2.2'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }

    mavenCentral()
            maven {
            /*
            Before the release please change the url below to: https://repo.onewelcome.com/artifactory/onegini-sdk
            Please change it back to https://repo.onewelcome.com/artifactory/public after the release
            */
            url "https://repo.onewelcome.com/artifactory/onegini-sdk"
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



#### iOS (>= 12.0): 

1. The Onegini SDK is uploaded to the Onegini Artifactory repository. In order to let CocoaPods use an Artifactory repository you need to install a specific plugin.
    ```
    gem install cocoapods-art
    ```
2. The Onegini SDK repository is not a public repository. You must provide credentials in order to access the repo. Create a file named .netrc in your Home folder (~/) and add the following contents to it:
    ```
    machine repo.onewelcome.com
    login <username>
    password <password>
    ```
    Replace the <username> and <password> with the credentials that you use to login to support.onegini.com.

3. The Onegini CocoaPods repository must be added to your local machine using the following command:
    ```
    pod repo-art add onegini https://repo.onewelcome.com/artifactory/api/pods/cocoapods-public
    ```

4. In order to update the Repository you must manually perform an update:
    ```
    pod repo-art add onegini https://repo.onewelcome.com/artifactory/api/pods/cocoapods-public
    ```

5. In the `pod` file has to be added at the beginning this part `ios/Podfile`:
    ```
    
    source 'https://github.com/artsy/Specs.git'
    source 'https://github.com/CocoaPods/Specs.git'
    platform :ios, '12.0'

    plugin 'cocoapods-art', :sources => [
        'onegini'
    ]
    ```

    ```
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            flutter_additional_ios_build_settings(target)
            target.build_configurations.each do |config|
                config.build_settings['ENABLE_BITCODE'] = 'NO'
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
            end
        end
    end
    ```

6. Run `pod install`    

7. Add `SecurityController.h` and `SecurityController.m` as described [HERE](https://developer.onewelcome.com/ios/sdk/security-controls) to native's part of code.
