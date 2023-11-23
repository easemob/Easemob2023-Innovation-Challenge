

enum StorageType {
  typeLog,
  typeCache,
  typeTemp,
  typeFile,
  typeAudio,
  typeImage,
  typeVideo,
  typeThumbImage,
  typeThumbVideo,
}

extension StorageTypeExtension on StorageType{
  String get storageDirectoryName{
    switch(this){
      case StorageType.typeLog:
        return Storage.log;
      case StorageType.typeCache:
        return Storage.cache;
      case StorageType.typeTemp:
        return Storage.temp;
      case StorageType.typeFile:
        return Storage.file;
      case StorageType.typeAudio:
        return Storage.audio;
      case StorageType.typeImage:
        return Storage.image;
      case StorageType.typeVideo:
        return Storage.video;
      case StorageType.typeThumbImage:
        return Storage.thumb;
      case StorageType.typeThumbVideo:
        return Storage.thumb;
    }
  }
}

class Storage{
  static const String audio = "audio/";
  static const String data = "data/";
  static const String file = "file/";
  static const String log = "log/";
  static const String cache = "cache/";
  static const String temp = "temp/";
  static const String image = "image/";
  static const String thumb = "thumb/";
  static const String video = "video/";
}