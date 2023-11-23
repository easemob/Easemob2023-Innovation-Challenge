import 'package:base_ui/app/ui_localizations.dart';
import 'package:base_ui/style/common_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:base_lib/base_lib.dart';

enum EmptyStatus {
  fail, //失败视图
  loading, //加载视图
  nodata, //没有数据视图
  none //没有状态
}

@immutable
class LibEmptyView extends StatefulWidget{
  final Widget? child;
  final EmptyStatus layoutType;
  final VoidCallback refresh;
  final Widget? networkImage;
  final Widget? networkText;
  final Widget? emptyImage;
  final Widget? emptyText;

  const LibEmptyView({Key? key, this.child,required this.refresh,required this.layoutType,this.networkImage,this.networkText, this.emptyImage,this.emptyText}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LibEmptyViewState();

}

class _LibEmptyViewState extends State<LibEmptyView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LibEmpty? iEmpty;
    bool visable = false;
    switch(widget.layoutType){
      case EmptyStatus.none:
        visable = true;
        break;
      case EmptyStatus.fail:
        if(widget.networkImage!=null||widget.networkText!=null){
          iEmpty = DefaultNetError(text: widget.networkText,img: widget.networkImage);
        }else{
          iEmpty = LibEmptyManager.instance.netWorkError;
        }
        break;
      case EmptyStatus.nodata:
        if(widget.emptyImage!=null||widget.emptyText!=null){
          iEmpty = DefaultEmpty(text: widget.emptyText,img: widget.emptyImage);
        }else{
          iEmpty = LibEmptyManager.instance.emptyPage;
        }
        break;
      case EmptyStatus.loading:
        iEmpty = LibEmptyManager.instance.loadingPage;
        break;
      default:
        if(widget.emptyImage!=null||widget.emptyText!=null){
          iEmpty = DefaultEmpty(text: widget.emptyText,img: widget.emptyImage);
        }else{
          iEmpty = LibEmptyManager.instance.emptyPage;
        }
    }
    iEmpty?.iEmptyRefresh = (){
      pressedReload();
    };

    return Stack(
      children: [
        Offstage(
          offstage: !visable,
          child: widget.child,
        ),
        Offstage(
          offstage: visable,
          child: Container(
            width: double.infinity,
            color: LibEmptyManager.instance.libEmptyConfig.backGround,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _listEmpty(iEmpty),
            ),
          ),),
      ],
    );
  }

  void pressedReload() async{
    bool isConnectNetWork = await ConnectManager.connect.isConnected();
    if(isConnectNetWork){
      widget.refresh.call();
    }else{
      TipToast.showToast(LibLocalizations.getLibString().libNetWorkNoConnect!,tipType: TipType.error);
    }
  }

  List<Widget> _listEmpty(LibEmpty? iEmpty) {
    List<Widget> tempEmpty = [];
    if(iEmpty!=null){
      Widget image = iEmpty.img;
      Widget text = iEmpty.text;
      Widget? refresh = iEmpty.getRefresh();
      tempEmpty.add(image);
      tempEmpty.add(text);
      if(refresh!=null){
        tempEmpty.add(refresh);
      }
    }
    return tempEmpty;
  }

}





abstract class LibEmpty{
  final Widget text;
  final Widget img;

  VoidCallback? iEmptyRefresh;

  LibEmpty(this.text, this.img);

  Widget? getRefresh() => null;



}


class DefaultEmpty extends LibEmpty{
  DefaultEmpty({Widget? text,Widget? img}):super(text??Text(
    LibEmptyManager.instance.libEmptyConfig.libEmptyPageNoData,
    style: TextStyle(fontSize: LibEmptyManager.instance.libEmptyConfig.textSize, color: LibEmptyManager.instance.libEmptyConfig.textColor),
  ),img??Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Icon(LibEmptyManager.instance.libEmptyConfig.imageNoData,color: LibEmptyManager.instance.libEmptyConfig.imgColor,size: LibEmptyManager.instance.libEmptyConfig.imageSize,),
  ));

}

class DefaultLoading extends LibEmpty{
  DefaultLoading({Widget? text,Widget? img}):super(text??Text(
    LibEmptyManager.instance.libEmptyConfig.libEmptyPageLoding,
    style: TextStyle(fontSize: LibEmptyManager.instance.libEmptyConfig.textSize, color: LibEmptyManager.instance.libEmptyConfig.textColor),
  ),img??Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Icon(LibEmptyManager.instance.libEmptyConfig.imageNoData,color: LibEmptyManager.instance.libEmptyConfig.imgColor,size: LibEmptyManager.instance.libEmptyConfig.imageSize,),
  ));

}

class DefaultNetError extends LibEmpty{
  DefaultNetError({Widget? text,Widget? img}):super(text??Text(
    LibEmptyManager.instance.libEmptyConfig.libEmptyPageNetError,
    style: TextStyle(fontSize: LibEmptyManager.instance.libEmptyConfig.textSize, color: LibEmptyManager.instance.libEmptyConfig.textColor),
  ),img??Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Icon(LibEmptyManager.instance.libEmptyConfig.imageNetWork,color: LibEmptyManager.instance.libEmptyConfig.imgColor,size: LibEmptyManager.instance.libEmptyConfig.imageSize,),
  ));


  @override
  Widget? getRefresh() => Padding(
    padding: const EdgeInsets.only(top: 20),
    child: Padding(
      padding: const EdgeInsets.only(left: 20,right: 20),
      child: ElevatedButton(onPressed: () {
        iEmptyRefresh?.call();
      },
        style:  ButtonStyle(
          backgroundColor: MaterialStateProperty.all(LibEmptyManager.instance.libEmptyConfig.btnColor),
          shape: MaterialStateProperty.all(const StadiumBorder()),
        )
        , child: Text(LibEmptyManager.instance.libEmptyConfig.libRefresh,style: TextStyle(fontSize: LibEmptyManager.instance.libEmptyConfig.libRefreshSize,color: LibEmptyManager.instance.libEmptyConfig.btnTextColor)),),
    ),
  );
}

class LibEmptyManager{

  late LibEmpty emptyPage;
  late LibEmpty loadingPage;
  late LibEmpty netWorkError;

  late LibEmptyConfig libEmptyConfig;

  LibEmptyManager._();

  static final LibEmptyManager _instance = LibEmptyManager._();

  static LibEmptyManager get instance {
    return _instance;
  }

  init({LibEmptyConfig? libEmptyConfig,LibEmpty? emptyPage,LibEmpty? loadingPage,LibEmpty? netWorkError}){
    this.libEmptyConfig = libEmptyConfig??LibEmptyConfigBuilder().build();
    this.emptyPage = emptyPage??DefaultEmpty();
    this.loadingPage = loadingPage??DefaultLoading();
    this.netWorkError = netWorkError??DefaultNetError();
  }
}



class LibEmptyConfig{
  final String _libEmptyPageNetError;
  final String _libEmptyPageNoData;
  final String _libEmptyPageLoding;
  final String _libRefresh;
  final double _libRefreshSize;
  final double _imageSize;
  final IconData _imageNoData;
  final IconData _imageNetWork;
  final IconData _imageLoading;
  final double _textSize;
  final Color _textColor;
  final Color _imgColor;
  final Color _btnColor;
  final Color _btnTextColor;
  final Color _backGround;

  String get libEmptyPageNetError => _libEmptyPageNetError;

  String get libEmptyPageNoData => _libEmptyPageNoData;

  String get libEmptyPageLoding => _libEmptyPageLoding;

  String get libRefresh => _libRefresh;

  double get libRefreshSize => _libRefreshSize;

  double get imageSize => _imageSize;

  IconData get imageNoData => _imageNoData;

  IconData get imageNetWork => _imageNetWork;

  IconData get imageLoading => _imageLoading;

  double get textSize => _textSize;


  Color get textColor => _textColor;


  Color get btnColor => _btnColor;


  Color get btnTextColor => _btnTextColor;


  Color get backGround => _backGround;

  LibEmptyConfig(LibEmptyConfigBuilder builder): _libEmptyPageNetError = builder._libEmptyPageNetError,
        _libEmptyPageNoData = builder._libEmptyPageNoData,
        _libEmptyPageLoding = builder._libEmptyPageLoding,
        _libRefresh = builder._libRefresh,
        _libRefreshSize = builder._libRefreshSize,
        _imageNoData = builder._imageNoData,
        _imageNetWork = builder._imageNetWork,
        _imageLoading = builder._imageLoading,
        _textSize = builder._textSize,
        _textColor = builder._textColor,
        _imgColor = builder._imgColor,
        _btnColor = builder._btnColor,
        _btnTextColor = builder._btnTextColor,
        _backGround = builder._backGround,
        _imageSize = builder._imageSize;

  Color get imgColor => _imgColor;
}


class LibEmptyConfigBuilder {
  String _libEmptyPageNetError = UiLocalizations.getUiString(LibRouteNavigatorObserver.instance.navigator!.context).libEmptyPageNetError!;
  String _libEmptyPageNoData = UiLocalizations.getUiString(LibRouteNavigatorObserver.instance.navigator!.context).libEmptyPageNoData!;
  String _libEmptyPageLoding = UiLocalizations.getUiString(LibRouteNavigatorObserver.instance.navigator!.context).libEmptyPageLoding!;
  String _libRefresh = UiLocalizations.getUiString(LibRouteNavigatorObserver.instance.navigator!.context).libRefresh!;
  double _libRefreshSize = 15;
  double _imageSize = 130;
  IconData _imageNoData = LibIconFonts.libIconFileEmpty;
  IconData _imageNetWork = LibIconFonts.libIconEarth;
  IconData _imageLoading = LibIconFonts.libIconSpinner10;
  double _textSize = 16;
  Color _textColor = Colors.grey;
  Color _imgColor = Colors.grey;
  Color _btnColor = Colors.blue;
  Color _btnTextColor = Colors.white;
  Color _backGround = Colors.white;


  set libEmptyPageNetError(String value) {
    _libEmptyPageNetError = value;
  }

  set libEmptyPageNoData(String value) {
    _libEmptyPageNoData = value;
  }

  set libEmptyPageLoding(String value) {
    _libEmptyPageLoding = value;
  }

  set libRefresh(String value) {
    _libRefresh = value;
  }

  set libRefreshSize(double value) {
    _libRefreshSize = value;
  }

  set imageSize(double value) {
    _imageSize = value;
  }

  set imageNoData(IconData value) {
    _imageNoData = value;
  }

  set imageNetWork(IconData value) {
    _imageNetWork = value;
  }

  set imageLoading(IconData value) {
    _imageLoading = value;
  }

  set textSize(double value) {
    _textSize = value;
  }

  set textColor(Color value) {
    _textColor = value;
  }


  set btnColor(Color value) {
    _btnColor = value;
  }

  set backGround(Color value) {
    _backGround = value;
  }

  LibEmptyConfig build() => LibEmptyConfig(this);

  set imgColor(Color value) {
    _imgColor = value;
  }

  set btnTextColor(Color value) {
    _btnTextColor = value;
  }
}
