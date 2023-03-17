abstract class pinEvent {
  pinAction action;
}

class pinCreateEvent extends pinEvent {}

class pinAuthenticationEvent extends pinEvent {}

class pinAuthenticationCloseEvent extends pinAuthenticationEvent {}

class pinAuthenticationOpenEvent extends pinAuthenticationEvent {}

// enum pinFlow {

// }

enum pinAction {
  openRegistration,
  closeRegistration,
  openAuthentication,
  closeAuthentication,
}

extension pinActionExtension on pinAction {
  String get value {
    switch (this) {
      case pinAction.openRegistration:
        return "open";
      case pinAction.closeRegistration:
        return "close";
      case pinAction.openAuthentication:
        return "openAuth";
      case pinAction.closeAuthentication:
        return "closeAuth";
    }
  }
}
