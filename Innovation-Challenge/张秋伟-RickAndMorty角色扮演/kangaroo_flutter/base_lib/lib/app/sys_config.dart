
/// 基础配置 系统基础配置
class SysConfig {

  ///APP存储目录
  static const String appStoreKey = 'APP_STORE';
  ///APP系统相关存储
  static const String appSysStoreKey = 'APP_SYS_STORE';
  ///安全表示
  static const String safe = '_SAFE';
  ///过期标识
  static const String exp = '_exp';
  ///系统环境
  static const String sysEnv = "SYS_ENV";
  ///环境名称
  static const String envName = "ENV_NAME";
  ///网络持久化存储
  static const String sysPersistent = "sys_persistent_";
  ///网络持久化存储
  static const String sysNetToken = 'sys_net_token';
  ///lib系统日志标识
  static const String libTag = '__lib';
  ///lib关于UI日志标识
  static const String libUiTag = '${libTag}__ui';
  ///lib关于生命周期日志标识
  static const String libLifeCycleTag = '${libTag}__Lifecycle';
  ///lib关于环境日志标识
  static const String libEnvironmentTag = '${libTag}__Environment';
  ///lib关于应用标识
  static const String libApplicationTag = '${libTag}__Application';
  ///lib关于网络标识
  static const String libNetTag = '${libTag}__Net';
  ///代理开启标识
  static const String PROXY_ENABLE = "PROXY_ENABLE";
  ///端口标识
  static const String PROXY_IP_PROT = "PROXY_IP_PROT";
  ///连接超时时间
  static const String connectTimeout = "CONNECT_TIME_OUT";
  ///接收超时时间
  static const String receiveTimeOut = "RECEIVE_TIME_OUT";

}

