

/// 认证状态　
class AuthenticationState {}

/// - uninitialized - 身份验证未初始化
class AuthenticationUninitialized extends AuthenticationState {}

/// - authenticated - 认证成功
class AuthenticationAuthenticated extends AuthenticationState {}

/// - unauthenticated - 未认证
class AuthenticationUnauthenticated extends AuthenticationState {}