import 'dart:math';

import 'package:flutter/material.dart';

enum Role { user, assistant, system }

class MemoryItem {
  final Role role;

  String? voicePath;

  String get content => _content;
  String _content;

  // 如果这个Item上传到服务器了， 那么这个remoteId就是服务器返回的id
  String? remoteId;

  MemoryItem(this.role, this._content);

  void _append(String content) {
    _content += content;
  }

  String get prefix => role == Role.user
      ? "我："
      : role == Role.assistant
          ? "AI："
          : "System：";

  @override
  String toString() {
    return prefix + content;
  }
}

class Memory extends ChangeNotifier {
  final List<MemoryItem> _items = [];

  String get content => _content;
  String _content = "";

  String get changedText => _changedText;
  String _changedText = "";

  final _indexInfo = <int>[];

  void append(String content, {Role? role}) {
    _changedText = "";

    if (role == null || (_items.isNotEmpty && _items.last.role == role)) {
      assert(_items.isNotEmpty);
      _items.last._append(content);
      _changedText += content;
      _indexInfo[_indexInfo.length - 1] += content.length;
    } else {
      final item = MemoryItem(role, content);
      _changedText += item.prefix + content;
      _items.add(item);
      _indexInfo.add(_content.length + _changedText.length);
    }

    _content += _changedText;

    notifyListeners();
  }

  MemoryItem get last => _items.last;

  MemoryItem get userLast =>
      _items.lastWhere((element) => element.role == Role.user);
  MemoryItem get assistantLast =>
      _items.lastWhere((element) => element.role == Role.assistant);

  List<MemoryItem> findMemoryItemByContentIndex(int index) {
    final n = _indexInfo.where((element) => element <= index).length;
    return _items.sublist(0, min(n + 1, _items.length));
  }
}
