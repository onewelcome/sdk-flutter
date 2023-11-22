package com.onegini.mobile.onegini_example;

import android.os.Build;
import com.onegini.mobile.onegini_example.R;
import com.onegini.mobile.sdk.android.model.OneginiClientConfigModel;

public class OneginiConfigModel implements OneginiClientConfigModel {

  /* Config model generated by SDK Configurator version: v5.1.0 */

  private final String appIdentifier = "FlutterExampleApp";
  private final String appPlatform = "android";
  private final String redirectionUri = "oneginiexample://loginsuccess";
  private final String appVersion = "1.0.2";
  private final String baseURL = "https://mobile-security-proxy.test.onegini.com";
  private final String resourceBaseURL = "https://mobile-security-proxy.test.onegini.com/resources/";
  private final String keystoreHash = "90cf65bea23977e84dcddfb38b8cecb5469d8ca43aa6b01575864ef2ca6eaa48";
  private final int maxPinFailures = 3;
  private final String serverPublicKey = "17DDB4086A1D3FA37950CBDDC6F1173A0C5902A3B71DAD261290CEFEE13CC9CA";

  private final String serverType = "access";

  private final String serverVersion = "78d06f2";

  public String getAppIdentifier() {
    return appIdentifier;
  }

  public String getAppPlatform() {
    return appPlatform;
  }

  public String getRedirectUri() {
    return redirectionUri;
  }

  public String getAppVersion() {
    return appVersion;
  }

  public String getBaseUrl() {
    return baseURL;
  }

  public String getResourceBaseUrl() {
    return resourceBaseURL;
  }

  public int getCertificatePinningKeyStore() {
    return R.raw.keystore;
  }

  public String getKeyStoreHash() {
    return keystoreHash;
  }

  public String getDeviceName() {
    return Build.BRAND + " " + Build.MODEL;
  }

  public String getServerPublicKey() {
    return serverPublicKey;
  }

  public String getServerType() {
    return serverType;
  }

  public String getServerVersion() {
    return serverVersion;
  }

  /**
   * @Deprecated Since Android SDK 8.0.0 this attribute is not required.
   */
  public boolean shouldGetIdToken() {
    return false;
  }

  /**
   * Get the max PIN failures. This attribute is just used for visual representation towards the end-user.
   *
   * @Deprecated Since Android SDK 6.01.00 this attribute is fetched from the Device config.
   *
   * @return The max PIN failures
   */
  public int getMaxPinFailures() {
    return maxPinFailures;
  }

  @Override
  public String toString() {
    return "ConfigModel{" +
            "  appIdentifier='" + appIdentifier + "'" +
            ", appPlatform='" + appPlatform + "'" +
            ", redirectionUri='" + redirectionUri + "'" +
            ", appVersion='" + appVersion + "'" +
            ", baseURL='" + baseURL + "'" +
            ", maxPinFailures='" + maxPinFailures + "'" +
            ", resourceBaseURL='" + resourceBaseURL + "'" +
            ", keyStoreHash='" + getKeyStoreHash() + "'" +
            ", serverPublicKey='" + serverPublicKey + "'" +
            "}";
  }
}
