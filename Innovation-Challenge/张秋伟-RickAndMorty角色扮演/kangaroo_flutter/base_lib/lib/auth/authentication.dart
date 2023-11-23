

import 'authentication_event.dart';
import 'i_user_authentication.dart';

abstract class IAuthentication{
  void sendEvent(AuthenticationEvent event);
  void init(IUserAuthentication iUserAuthentication);
}

class Authentication extends IAuthentication{
  late IAuthentication _iAuthentication;

  Authentication._();

  static final Authentication _instance = Authentication._();

  static Authentication get instance {
    return _instance;
  }

  set iAuthentication(IAuthentication value) {
    _iAuthentication = value;
  }

  @override
  void init(IUserAuthentication iUserAuthentication) => _iAuthentication.init(iUserAuthentication);

  @override
  void sendEvent(AuthenticationEvent event) => _iAuthentication.sendEvent(event);
}
