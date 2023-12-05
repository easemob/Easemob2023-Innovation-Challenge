
//App认证事件，一般来说有三种，启动认证，登录认证，退出认证
class AuthenticationEvent {}
//App启动事件
class AppStart extends AuthenticationEvent{}
//App登录事件
class LogIn extends AuthenticationEvent{
  String? token;
  ///token 可能在header中处理
  LogIn({this.token});

  @override
  String toString() =>"LoggedIn { token: $token }";
}
//App退出事件
class LogOut extends AuthenticationEvent{}
