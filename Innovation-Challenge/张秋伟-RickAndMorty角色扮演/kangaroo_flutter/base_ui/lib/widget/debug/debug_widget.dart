import 'package:base_ui/style/common_style.dart';
import 'package:flutter/material.dart';
import 'debugconfig_env.dart';
import 'package:base_lib/base_lib.dart';

class LibDebugBtn{
  static TransitionBuilder init({
    TransitionBuilder? builder,
  }) {
    return (BuildContext context, Widget? child) {
      if(Application.config.debugState){
        child = DebugBtn(child!);
      }
      if (builder != null) {
        return builder(context, child!);
      } else {
        return child!;
      }
    };
  }
}

@immutable
class DebugBtn extends StatefulWidget{

  final Widget child;

  const DebugBtn(this.child, {super.key});

  @override
  State<StatefulWidget> createState() => _DebugBtnState();

}

class _DebugBtnState extends State<DebugBtn>{

  late OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    _overlayEntry = OverlayEntry(builder: (BuildContext context) => const DebugDraggable());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Overlay(
        initialEntries: [
          OverlayEntry(builder: (context){
            return widget.child;
          }),
          _overlayEntry,
        ],
      ),
    );
  }

}

@immutable
class DebugDraggable extends StatefulWidget{
  const DebugDraggable({super.key});

  @override
  State<StatefulWidget> createState() =>_DebugDraggableState();
}

class _DebugDraggableState extends State<DebugDraggable>{
  double left = 100;
  double top = 100;
  double btnHSize = 50;
  double btnWSize = 50;
  late double screenWidth;
  late double screenHeight;
  bool _isBottomSheetOpen = false;

  bool _initAre = false;

  initAre(){
    if(!_initAre){
      _initAre = !_initAre;
      left = screenWidth - btnWSize -10;
      top = screenHeight - btnHSize -10;
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    initAre();
    ///计算偏移量限制
    if (left < 1) {
      left = 1;
    }
    if (left > screenWidth - btnWSize) {
      left = screenWidth - btnWSize;
    }

    if (top < 1) {
      top = 1;
    }
    if (top > screenHeight - btnHSize) {
      top = screenHeight - btnHSize;
    }
    return GestureDetector(
      onTap: (){
        if (!_isBottomSheetOpen) { // 如果底部菜单未打开
          _isBottomSheetOpen = true; // 设置打开标志
          showModalBottomSheet(
              context: LibRouteNavigatorObserver.instance.navigator!.context,
              // isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              builder: (context) => const DebugConfigEnv()).whenComplete(() {
            _isBottomSheetOpen = false; // 设置关闭标志
          });
        }

      },
      onPanUpdate: _dragUpdate,
      child:Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(left: left, top: top),
        child: Container(
          width: btnWSize,
          height: btnHSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xa1dcdcdc),
          ),
          child: Center(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LibIconFonts.libIconMeter,color: Colors.white,),
                  Expanded(child: Text(
                    '${AppEnvironment.envs[AppEnvironment.env]![SysConfig.envName]}',
                    style: const TextStyle(color: Colors.white,fontSize: 12),
                  )),]
            ),
          ),),
      ),
    );
  }

  void _dragUpdate(DragUpdateDetails detail) {
    Offset offset = detail.delta;
    left = left + offset.dx;
    top = top + offset.dy;
    setState(() {

    });
  }
}


class DebugWidget extends StatelessWidget {

  const DebugWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            // isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            builder: (context) => const DebugConfigEnv());
        // _showLogOverlay(context);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(LibIconFonts.libIconBug),
          Container(
              margin: const EdgeInsets.only(left: 3),
              child: Text(
                'debug-${AppEnvironment.envs[AppEnvironment.env]![SysConfig.envName]}',
                style: const TextStyle(color: Colors.white),
              )),
        ],
      ),
    );
  }
}
