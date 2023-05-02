// Dev note: When editing these error codes, make sure to update them in the native wrapper code aswel.

/// Errors from the flutter sdk, some of these errors can only occur on a single platform.
enum WrapperErrorCodes {
  genericError(code: 8000),
  notAuthenticatedUser(code: 8040),
  notAuthenticatedImplicit(code: 8041),
  notFoundUserProfile(code: 8042),
  notFoundAuthenticator(code: 8043),
  notFoundIdentityProvider(code: 8044),

  /// Android only
  notFoundSecurityController(code: 8045),

  httpRequestErrorInternal(code: 8046),
  httpRequestErrorCode(code: 8047),

  /// iOS only
  httpRequestErrorNoResponse(code: 8048),

  /// Android only
  onewelcomeSdkNotInitialized(code: 8049),

  invalidUrl(code: 8050),
  notInProgressCustomRegistration(code: 8051),
  notInProgressAuthentication(code: 8052),
  notInProgressOtpAuthentication(code: 8053),
  notInProgressPinCreation(code: 8054),
  notInProgressFingerprintAuthentication(code: 8055),

  /// iOS only. Android will throw actionAlreadyInProgress
  alreadyInProgressMobileAuth(code: 8056),

  actionNotAllowedCustomRegistrationCancel(code: 8057),
  actionNotAllowedBrowserRegistrationCancel(code: 8058),

  /// Android only
  configError(code: 8059),

  biometricAuthenticationNotAvailable(code: 8060);

  final int code;

  const WrapperErrorCodes({required this.code});
}

/// Error from the native sdk's, some of these errors can only occur on a single platform.
enum PlatformErrorCodes {
  networkConnectivityProblem(code: 9000),
  serverNotReachable(code: 9001),
  deviceDeregistered(code: 9002),
  userDeregistered(code: 9003),
  outdatedApp(code: 9004),
  outdatedOs(code: 9005),
  actionCanceled(code: 9006),
  actionAlreadyInProgress(code: 9007),
  deviceRegistrationError(code: 9008),

  /// iOS only
  authenticationErrorInvalidPin(code: 9009),

  userNotAuthenticated(code: 9010),
  pinBlacklisted(code: 9011),
  pinIsASequence(code: 9012),
  pinUsesSimilarDigits(code: 9013),
  wrongPinLength(code: 9014),
  invalidAuthenticator(code: 9015),
  deviceAlreadyEnrolled(code: 9016),
  enrollmentNotAvailable(code: 9017),
  userAlreadyEnrolled(code: 9018),
  userDisenrolled(code: 9020),
  mobileAuthenticationNotEnrolled(code: 9021),
  authenticatorDeregistered(code: 9022),

  /// Android only
  mobileAuthenticationDisenrolled(code: 9023),

  dataStorageNotAvailable(code: 9024),

  /// iOS only
  genericErrorUnrecoverableDataState(code: 9025),

  /// iOS only
  userNotAuthenticatedImplicitly(code: 9026),

  customAuthenticatorFailure(code: 9027),

  /// iOS only
  alreadyHandled(code: 9029),

  authenticationErrorBiometricAuthenticatorFailure(code: 9030),

  /// Android only
  invalidDatetime(code: 9031),

  generalError(code: 10000),
  configurationError(code: 10001),
  invalidState(code: 10002),
  localDeregistration(code: 10003),
  authenticatorAlreadyRegistered(code: 10004),

  /// Android only
  fidoAuthenticationDisabledDeprecated(code: 10005),

  authenticatorNotSupported(code: 10006),
  authenticatorNotRegistered(code: 10007),
  authenticatorPinDeregistrationNotPossible(code: 10008),
  localLogout(code: 10009),

  /// iOS only
  fetchInvalidMethod(code: 10010),

  deviceNotAuthenticated(code: 10012),
  mobileAuthenticationRequestNotFound(code: 10013),
  invalidRequest(code: 10015),

  /// Android only
  fidoServerNotReachableDeprecated(code: 10016),

  customAuthenticationDisabled(code: 10017),
  notHandleable(code: 10018),

  /// iOS only
  fetchInvalidHeaders(code: 10019),

  /// Android only
  invalidIdentityProvider(code: 10020),

  customRegistrationExpired(code: 10021),
  customRegistrationFailure(code: 10022),
  singleSignOnDisabled(code: 10023),
  appIntegrityFailure(code: 10024);

  final int code;

  const PlatformErrorCodes({required this.code});
}
