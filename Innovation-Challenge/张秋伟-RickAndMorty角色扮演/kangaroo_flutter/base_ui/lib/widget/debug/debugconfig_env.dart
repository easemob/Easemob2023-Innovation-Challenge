import 'dart:io';

import 'package:base_lib/base_lib.dart';
import 'package:base_ui/app/ui_localizations.dart';
import 'package:base_ui/style/common_style.dart';
import 'package:base_ui/widget/debug/debug_float_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DebugConfigEnv extends StatefulWidget {
  const DebugConfigEnv({Key? key}) : super(key: key);

  @override
  State<DebugConfigEnv> createState() => _DebugConfigEnvState();
}

class _DebugConfigEnvState extends State<DebugConfigEnv> {
  double _positionLeft = 10;
  double _positionTop = 500;
  static OverlayEntry? itemEntry;
  static OverlayEntry? overlayEntry;
  static bool openControl = false;
  static bool openInterceptor = false;
  TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    UiString strings = UiLocalizations.getUiString(context);
    List<Environment> envs = AppEnvironment.envs.keys.toList();
    _textEditingController.text = StoreManager.store.getString(SysConfig.PROXY_IP_PROT)??"";
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            LibIconFonts.libIconBug,
            color: Colors.red,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            strings.libDebugModeIntroduce!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(strings.libDebugProxy!),
              ),
              Expanded(flex: 1,child: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                    hintText: "***.***.***.***:****"
                ),),),
              // SizedBox(
              //   width: 200,
              //   child:  TextField(decoration: InputDecoration(
              //     labelText: SpSotre.instance.getString(SysConfig.PROXY_IP_PROT),
              //       hintText: "***.***.***.***:****"
              //   ),),
              // ),
              SizedBox(
                height: 30,
                child: Switch(
                  value: StoreManager.store.getBool(SysConfig.PROXY_ENABLE)??false,
                  activeColor: Colors.red,
                  onChanged: (bool value) {
                    StoreManager.store.setBool(SysConfig.PROXY_ENABLE,value);
                    StoreManager.store.setString(SysConfig.PROXY_IP_PROT,_textEditingController.text);
                    SystemNavigator.pop(animated: true).then((value) async{
                      await Future.delayed(const Duration(milliseconds: 500));
                      exit(0);
                    });
                  },
                ),
              )
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(strings.libDebugConsole!),
              SizedBox(
                height: 30,
                child: Switch(
                  value: openControl,
                  activeColor: Colors.red,
                  onChanged: (bool value) {
                    setState(() {
                      openControl = value;
                    });
                    if (openControl) {
                      _showLogOverlay(context);
                    } else {
                      _hideLogOverlay();
                    }
                  },
                ),
              )
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(strings.libDebugInterception!),
              SizedBox(
                height: 30,
                child: Switch(
                  value: openInterceptor,
                  activeColor: Colors.red,
                  onChanged: (bool value) {
                    setState(() {
                      openInterceptor = value;
                    });
                    if (openInterceptor) {
                      _showInterceptorOverlay(context);
                    } else {
                      _hideInterceptorOverlay();
                    }
                  },
                ),
              )
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemBuilder: (_, index) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    AppEnvironment.env = envs[index];
                    // Navigator.pop(context)
                    SystemNavigator.pop(animated: true).then((value) async{
                      await Future.delayed(const Duration(milliseconds: 500));
                      exit(0);
                    });
                },
                  child: Container(
                    color: AppEnvironment.env == envs[index]
                        ? Colors.red.withAlpha(90)
                        : Colors.white,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(AppEnvironment
                            .envs[envs[index]]![SysConfig.envName]
                            .toString()),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: envs.length,
            ),
          )
        ],
      ),
    );
  }

  void _hideLogOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
      openControl = false;

      setState(() {
      });
    }
  }

  void _createLogOverlay() {
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          left: _positionLeft,
          top: _positionTop,
          child: GestureDetector(
            onTap: () {
              // _hideLogOverlay();
            },
            onPanUpdate: (details) {
              // _positionLeft += details.delta.dx;
              _positionTop += details.delta.dy;
              overlayEntry!.markNeedsBuild();
            },
            // child: ClipRRect(
            //   borderRadius: BorderRadius.circular(20),
            //   child: Container(
            //     padding: const EdgeInsets.all(20),
            //     width: MediaQuery.of(context).size.width - 20,
            //     height: 100,
            //     color: Colors.black.withOpacity(0.3),
            //     child: Material(
            //       color: Colors.transparent,
            //       child: Text(logStr,
            //           style: const TextStyle(
            //               fontSize: 20,
            //               fontWeight: FontWeight.bold,
            //               color: Colors.white)),
            //     ),
            //   ),
            // ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width - 20,
              child: DebugFloatWidget(onClear: _hideLogOverlay)
            ),
          ));
    });
  }

  void _showLogOverlay(BuildContext context) {
    if (overlayEntry == null) {
      _createLogOverlay();
      Overlay.of(context)!.insert(overlayEntry!);
    }
  }

  void _showInterceptorOverlay(BuildContext context) {
    // if(itemEntry == null){
    //   itemEntry = OverlayEntry(builder: (BuildContext context) => InterceptorDraggable());
    //   Overlay.of(context)?.insert(itemEntry!);
    // }
  }

  void _hideInterceptorOverlay() {
    // itemEntry?.remove();
    // itemEntry = null;
    // setState(() {
    //   openInterceptor = false;
    // });
  }

}
