abstract class PinEvent {
  PinAction action;
  PinEvent(this.action);
}

class PinCreateEvent extends PinEvent {
  PinCreateEvent(PinAction action) : super(action);
}

class PinAuthenticationEvent extends PinEvent {
  PinAuthenticationEvent(PinAction action) : super(action);
}

class PinAuthenticationCloseEvent extends PinAuthenticationEvent {
  PinAuthenticationCloseEvent() : super(PinAction.closeAuthentication);
}

class PinAuthenticationOpenEvent extends PinAuthenticationEvent {
  String profileId;
  PinAuthenticationOpenEvent(this.profileId)
      : super(PinAction.openAuthentication);
}

enum PinAction {
  openRegistration,
  closeRegistration,
  openAuthentication,
  closeAuthentication,
}

extension pinActionExtension on PinAction {
  String get value {
    switch (this) {
      case PinAction.openRegistration:
        return "open";
      case PinAction.closeRegistration:
        return "close";
      case PinAction.openAuthentication:
        return "openAuth";
      case PinAction.closeAuthentication:
        return "closeAuth";
    }
  }
}
