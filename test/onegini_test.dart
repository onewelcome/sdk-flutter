import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onegini/constants/constants.dart';
import 'package:onegini/model/onegini_identity_provider.dart';
import 'package:onegini/onegini.dart';

import 'MockBuildContext.dart';

void main() {
  MockBuildContext _mockContext;
  String removedUserProfiles = "AOX42S";
  String userId = "ASX24SG";
  List<OneginiIdentityProvider> identityProviders = List.generate(3,
      (index) => OneginiIdentityProvider(id: "$index", name: "provider$index"));
  List<OneginiIdentityProvider> authenticators = List.generate(3,
          (index) => OneginiIdentityProvider(id: "$index", name: "authenticator $index"));
  String fingerprintData = "AFFLWEJFELFf32r3SFJ#OIJF@R#MFLEMWLFMEWL#FMJ#@O@";
  const MethodChannel channel = MethodChannel('onegini');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    _mockContext = MockBuildContext();
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case Constants.startAppMethod:
          return removedUserProfiles;
          break;
        case Constants.getPlatformVersion:
          return "0.2.1";
          break;
        case Constants.registrationMethod:
          return userId;
          break;
        case Constants.logOutMethod:
          return true;
          break;
        case Constants.getSendPinMethod:
          return userId;
          break;
        case Constants.deregisterUserMethod:
          return true;
          break;
        case Constants.getIdentityProvidersMethod:
          return providerToJson(identityProviders);
          break;
        case Constants.getRegisteredAuthenticators:
          return authenticators;
          break;
        case Constants.registrationWithIdentityProviderMethod:
          return userId;
          break;
        case Constants.authenticateWithRegisteredAuthentication:
          return userId;
          break;
        case Constants.pinAuthentication:
          return userId;
          break;
        case Constants.registerFingerprintAuthenticator:
          return fingerprintData;
          break;
        case Constants.cancelRegistrationMethod:
          break;
        case Constants.cancelPinAuth:
          break;
        case Constants.changePin:
          break;
        case Constants.otpQrCodeResponse:
          break;
        case Constants.acceptOTPAuth:
          break;
        case Constants.denyOTPAuth:
          break;
        case Constants.isUserNotRegisteredFingerprint:
          return true;
          break;
        default:
          break;
      }
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });


  test('Registration method', () async {
    expect(await Onegini.instance.registrationMethods.registration(_mockContext, "read"), userId);
  });

  test("LogOut Method",() async {
    expect(await Onegini.instance.authenticationMethods.logOut(),true);
  });
  test("Send Pin Method",() async {
    expect(await Onegini.instance.sendPin("42155", true),userId);
  });
  test("Deregister User Method",() async {
    expect(await Onegini.instance.registrationMethods.deregisterUser(),true);
  });
  test("Registration With IdentityProvider Method",() async {
    expect(await Onegini.instance.registrationMethods.registrationWithIdentityProvider("testId", "read"),userId);
  });
  test("Authenticate With Registered Authentication Method",() async {
    expect(await Onegini.instance.authenticationMethods.authenticationWithRegisteredAuthenticators("testId"),userId);
  });
  test("Pin Authentication Method",() async {
    expect(await Onegini.instance.authenticationMethods.pinAuthentication(_mockContext),userId);
  });
}
