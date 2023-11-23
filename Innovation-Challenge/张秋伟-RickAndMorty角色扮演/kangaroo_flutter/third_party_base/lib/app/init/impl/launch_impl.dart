
import 'package:url_launcher/url_launcher.dart' as launch;
import 'package:base_lib/base_lib.dart';

class LaunchImpl implements ILaunch{

  @override
  Future<bool> launchUrl(Uri url) => launch.launchUrl(url);

  @override
  Future<bool> canLaunchUrl(Uri url)=> launch.canLaunchUrl(url);

}