import 'dart:async';

import 'package:flutter/material.dart';

class _EntryHolder {
  final OverlayEntry entry;
  _EntryHolder(this.entry);

  void remove() {
    if (entry.mounted) {
      entry.remove();
    }
  }
}

mixin TempIgnoreTouchEventHandler<T extends StatefulWidget> on State<T> {
  VoidCallback tempIgnoreTouchEvent(
      {int maxSeconds = 2, bool autoEnable = true}) {
    // 添加一个透明的overlay层，拦截所有的点击事件
    final entry = OverlayEntry(
      builder: (context) {
        return _TempCover(maxSeconds);
      },
    );

    Overlay.of(context).insert(entry);

    final holder = _EntryHolder(entry);
    if (autoEnable) {
      Timer(Duration(seconds: maxSeconds), holder.remove);
    }

    return holder.remove;
  }
}

class _TempCover extends StatefulWidget {
  final int maxSeconds;

  const _TempCover(this.maxSeconds);

  @override
  State<_TempCover> createState() => __TempCoverState();
}

class __TempCoverState extends State<_TempCover> {
  late final Timer _timer;

  var showWarning = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(seconds: widget.maxSeconds), () {
      setState(() {
        showWarning = true;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: Container(
        color: Colors.transparent,
        child: showWarning
            ? Center(
                child: Text("超时未移除遮罩不可点击，请检查代码逻辑",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.red)),
              )
            : null,
      ),
    );
  }
}
