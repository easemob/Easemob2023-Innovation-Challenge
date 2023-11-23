abstract class IPackageInfo{
  Future<PackageModel> getPackageModel();
}

class PackageModel{
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;
  final String uniqueId;

  PackageModel(this.appName, this.packageName, this.version, this.buildNumber, this.uniqueId);
}

class PackageInfoManager{

  static late IPackageInfo packageInfo;

  static void init(IPackageInfo iPackageInfo){
    packageInfo = iPackageInfo;
  }
}