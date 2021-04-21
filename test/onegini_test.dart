import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onegini/constants/constants.dart';
import 'package:onegini/model/onegini_list_response.dart';


import 'MockBuildContext.dart';

void main() {
  MockBuildContext _mockContext = MockBuildContext();
  String removedUserProfiles = "AOX42S";
  String userId = "ASX24SG";
  List<OneginiListResponse> identityProviders = List.generate(3,
      (index) => OneginiListResponse(id: "$index", name: "provider$index"));
  List<OneginiListResponse> authenticators = List.generate(3,
          (index) => OneginiListResponse(id: "$index", name: "authenticator $index"));
  String fingerprintData = "AFFLWEJFELFf32r3SFJ#OIJF@R#MFLEMWLFMEWL#FMJ#@O@";
  const MethodChannel channel = MethodChannel('onegini');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case Constants.startAppMethod:
          return removedUserProfiles;
        case Constants.registerUser:
          return userId;

        case Constants.deregisterUserMethod:
          return true;
          
        case Constants.getIdentityProvidersMethod:
          return responseToJson(identityProviders);
          
        case Constants.getRegisteredAuthenticators:
          return authenticators;

        case Constants.cancelRegistrationMethod:

        case Constants.changePin:
          

        case Constants.acceptOtpAuthenticationRequest:
          
        case Constants.denyOtpAuthenticationRequest:
          
        default:
          
      }
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });


  // test('Registration method', () async {
  //   expect(await Onegini.instance.registrationMethods.registration(_mockContext, "read"), userId);
  // });

}
