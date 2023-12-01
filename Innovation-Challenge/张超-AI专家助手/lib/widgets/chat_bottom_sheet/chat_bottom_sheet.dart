import 'package:flutter/material.dart';

Future<T?> showChatBottomSheet<T>({
  required BuildContext context,
  String? title,
  Color? barrierColor,
  Color? backgroundColor,
  List<ChatBottomSheetItem>? items,
  TextStyle titleStyle = const TextStyle(
      color: Color.fromRGBO(102, 102, 102, 1),
      fontWeight: FontWeight.w600,
      fontSize: 14),
  TextStyle normalItemStyle = const TextStyle(
      color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
  TextStyle destructiveItemStyle = const TextStyle(
      color: Colors.red, fontWeight: FontWeight.w600, fontSize: 16),
}) {
  barrierColor ??= Theme.of(context).bottomSheetTheme.modalBackgroundColor;
  return showModalBottomSheet(
    context: context,
    barrierColor: barrierColor,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(12),
      topRight: Radius.circular(12),
    )),
    builder: (context) {
      return ChatBottomSheet(
        title: title,
        items: items,
        titleStyle: titleStyle,
        destructiveItemStyle: destructiveItemStyle,
        normalItemStyle: normalItemStyle,
        backgroundColor: backgroundColor,
        barrierColor: barrierColor,
      );
    },
  );
}

class ChatBottomSheet extends StatefulWidget {
  const ChatBottomSheet({
    super.key,
    this.title,
    this.items,
    this.destructiveItemStyle,
    this.barrierColor,
    this.backgroundColor,
    this.titleStyle,
    this.normalItemStyle,
  });
  final String? title;
  final List<ChatBottomSheetItem>? items;
  final TextStyle? titleStyle;
  final TextStyle? normalItemStyle;
  final TextStyle? destructiveItemStyle;
  final Color? barrierColor;
  final Color? backgroundColor;

  @override
  State<ChatBottomSheet> createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends State<ChatBottomSheet> {
  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    list.add(const Divider(height: 12, color: Colors.transparent));
    if (widget.title != null) {
      list.add(
        Container(
          padding: const EdgeInsets.only(top: 0, bottom: 12),
          child: Text(
            widget.title!,
            style: widget.titleStyle,
          ),
        ),
      );
    }

    if (widget.items != null) {
      widget.items?.forEach((element) {
        Widget item = Text(
          element.label,
          style: element.type == ChatBottomSheetItemType.destructive
              ? widget.destructiveItemStyle
              : widget.normalItemStyle,
        );

        item = Center(child: item);

        item = Container(
          margin: const EdgeInsets.only(left: 12, right: 12),
          height: 48,
          decoration: BoxDecoration(
            color: element.backgroundColor ??
                const Color.fromRGBO(246, 246, 246, 1),
            borderRadius: const BorderRadius.all(Radius.circular(40)),
          ),
          child: item,
        );

        item = InkWell(
          onTap: () async {
            return await element.onTap?.call();
          },
          child: item,
        );

        list.add(item);
        list.add(const Divider(height: 12, color: Colors.transparent));
      });
    }

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: list,
    );

    content = SafeArea(child: content);

    return content;
  }
}

enum ChatBottomSheetItemType { normal, destructive }

class ChatBottomSheetItem<T> {
  final String label;
  final Future<T> Function()? onTap;
  final TextStyle? labelStyle;
  final ChatBottomSheetItemType type;
  final Color? backgroundColor;

  factory ChatBottomSheetItem.normal(
    String label, {
    Future<T> Function()? onTap,
    TextStyle? labelStyle,
    Color? backgroundColor,
  }) {
    return ChatBottomSheetItem(
      label: label,
      onTap: onTap,
      labelStyle: labelStyle,
      type: ChatBottomSheetItemType.normal,
      backgroundColor: backgroundColor,
    );
  }
  factory ChatBottomSheetItem.destructive(
    String label, {
    Future<T> Function()? onTap,
    TextStyle? labelStyle,
    Color? backgroundColor,
  }) {
    return ChatBottomSheetItem<T>(
      label: label,
      onTap: onTap,
      labelStyle: labelStyle,
      type: ChatBottomSheetItemType.destructive,
      backgroundColor: backgroundColor,
    );
  }

  const ChatBottomSheetItem({
    required this.label,
    required this.type,
    this.onTap,
    this.labelStyle,
    this.backgroundColor,
  });
}
