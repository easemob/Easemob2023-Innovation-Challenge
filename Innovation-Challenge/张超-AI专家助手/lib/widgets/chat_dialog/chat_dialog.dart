import 'package:flutter/material.dart';

class ChatDialog extends StatefulWidget {
  factory ChatDialog.input({
    String? title,
    required List<String> hiddenList,
    String? subTitle,
    List<ChatDialogItem>? items,
  }) {
    return ChatDialog._(
      titleLabel: title,
      subTitleLabel: subTitle,
      hiddenList: hiddenList,
      items: items,
    );
  }

  factory ChatDialog.normal({
    String? title,
    String? subTitle,
    List<ChatDialogItem>? items,
  }) {
    return ChatDialog._(
      titleLabel: title,
      subTitleLabel: subTitle,
      items: items,
    );
  }

  const ChatDialog._({
    this.titleLabel,
    this.subTitleLabel,
    this.hiddenList,
    this.items,
  });

  final String? titleLabel;
  final String? subTitleLabel;
  final List<String>? hiddenList;
  final List<ChatDialogItem>? items;

  @override
  State<StatefulWidget> createState() => _ChatDialogState();
}

class _ChatDialogState extends State<ChatDialog> {
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    widget.hiddenList?.forEach((element) {
      _controllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.7;
    return Dialog(
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: SizedBox(
        width: width,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    assert(
      widget.items != null ||
          widget.hiddenList != null ||
          widget.subTitleLabel != null ||
          widget.titleLabel != null,
      'You need to set at least one parameter.',
    );

    List<Widget> list = [];
    if (widget.titleLabel != null) {
      list.add(const Divider(height: 8, color: Colors.transparent));
      list.add(
        Text(
          widget.titleLabel ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      );
    }

    if (widget.subTitleLabel != null) {
      list.add(const Divider(height: 8, color: Colors.transparent));
      list.add(
        Text(
          widget.subTitleLabel ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color.fromRGBO(108, 113, 146, 1)),
        ),
      );
    }

    if (widget.hiddenList != null) {
      for (var i = 0; i < widget.hiddenList!.length; i++) {
        list.add(const Divider(height: 18, color: Colors.transparent));
        TextEditingController controller = _controllers[i];
        Widget content = TextField(
          controller: controller,
          cursorHeight: 12,
          decoration: InputDecoration(
            isCollapsed: true,
            contentPadding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
            hintText: widget.hiddenList![i],
            hintStyle:
                const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
            border: InputBorder.none,
            suffix: InkWell(
              onTap: controller.clear,
              child:
                  const Icon(Icons.close_rounded, color: Colors.grey, size: 12),
            ),
          ),
        );

        content = Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: const Color.fromRGBO(250, 250, 250, 1),
          ),
          child: content,
        );
        list.add(content);
      }
    }

    if (widget.items != null) {
      list.add(const Divider(height: 10, color: Colors.transparent));
      if (widget.items!.length > 2) {
        for (var i = 0; i < widget.items!.length; i++) {
          list.add(const Divider(height: 8, color: Colors.transparent));
          ChatDialogItem item = widget.items![i];
          list.add(item);
        }
      } else {
        list.add(const Divider(height: 8, color: Colors.transparent));
        List<Widget> rowItems = [];
        for (var i = 0; i < widget.items!.length; i++) {
          ChatDialogItem item = widget.items![i];
          if (item.type == ChatDialogItemType.confirm &&
              widget.hiddenList != null &&
              widget.hiddenList!.isNotEmpty) {
            item = item.copyWith(() {
              List<String> list = [];
              for (var element in _controllers) {
                list.add(element.text);
              }
              return list;
            });
          }
          rowItems.add(Expanded(child: item));
          rowItems.add(const SizedBox(width: 20));
          if (i == widget.items!.length - 1) {
            rowItems.removeLast();
          }
        }
        Widget content = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: rowItems,
        );
        list.add(content);
      }
    }

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: list,
    );

    content = Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: content,
    );

    content = ListView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [content],
    );
    content = Scrollbar(
      child: content,
    );
    return content;
  }

  @override
  void dispose() {
    for (var element in _controllers) {
      element.dispose();
    }
    super.dispose();
  }
}

enum ChatDialogItemType {
  confirm,
  cancel,
}

// ignore: must_be_immutable
class ChatDialogItem extends StatelessWidget {
  factory ChatDialogItem.confirm({
    Key? key,
    String? label,
    void Function(List<String>? labels)? onTap,
  }) {
    return ChatDialogItem(
      key: key,
      type: ChatDialogItemType.confirm,
      label: label ?? 'Confirm',
      onTap: onTap,
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      backgroundColor: const Color.fromRGBO(17, 78, 255, 1),
    );
  }

  factory ChatDialogItem.cancel({
    Key? key,
    String? label,
    VoidCallback? onTap,
  }) {
    return ChatDialogItem(
      key: key,
      type: ChatDialogItemType.cancel,
      label: label ?? 'Cancel',
      onTap: (p0) {
        onTap?.call();
      },
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
    );
  }

  ChatDialogItem({
    super.key,
    required this.type,
    required this.label,
    this.onTap,
    this.labelStyle,
    this.backgroundColor,
  });

  final String label;
  final void Function(List<String>?)? onTap;
  final TextStyle? labelStyle;
  final Color? backgroundColor;
  final ChatDialogItemType type;

  List<String>? Function()? _getValues;

  ChatDialogItem copyWith(List<String>? Function() action) {
    ChatDialogItem item = ChatDialogItem(
      type: type,
      label: label,
      onTap: onTap,
      labelStyle: labelStyle,
      backgroundColor: backgroundColor,
    );
    item._getValues = action;
    return item;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call(_getValues?.call());
      },
      child: Container(
        width: 100,
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            label,
            style: labelStyle,
          ),
        ),
      ),
    );
  }
}
