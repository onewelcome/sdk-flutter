package com.onegini.mobile.onegini_example;

import android.os.Build;
import com.onegini.mobile.sdk.android.model.OneginiClientConfigModel;

public class OneginiConfigModel implements OneginiClientConfigModel {

  /* Config model generated by SDK Configurator version: v5.3.0 */

  private final String appIdentifier = "FlutterExampleApp";
  private final String appPlatform = "android";
  private final String redirectionUri = "oneginiexample://loginsuccess";
  private final String appVersion = "1.0.2";
  private final String baseURL = "https://mobile-security-proxy.test.onegini.com";
  private final String resourceBaseURL = "https://mobile-security-proxy.test.onegini.com/resources/";
  private final String keystoreHash = "ebea379eb6b02801a359c40d4a39e86dd75637cc296bceb40eafbb2a79a73d0d";
  private final int maxPinFailures = 3;
  private final String serverPublicKey = "17DDB4086A1D3FA37950CBDDC6F1173A0C5902A3B71DAD261290CEFEE13CC9CA";
  private final String serverType = "access";
  private final String serverVersion = "62fbd4e";

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
            ", serverType='" + serverType + "'" +
            ", serverVersion='" + serverVersion + "'" +
            "}";
  }
}
