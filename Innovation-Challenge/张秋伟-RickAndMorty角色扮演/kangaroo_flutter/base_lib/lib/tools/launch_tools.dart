abstract class ILaunch{
  Future<bool> canLaunchUrl(Uri url);
  Future<bool> launchUrl(Uri url);
}

class LaunchTools {

  static late ILaunch _iLaunch;

  static void init(ILaunch iLaunch){
    _iLaunch = iLaunch;
  }
  static Future<bool> canLaunchUrl(Uri url) => _iLaunch.canLaunchUrl(url);
  static Future<bool> launchUrl(Uri url)=>_iLaunch.launchUrl(url);
}
