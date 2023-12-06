import 'package:flutter/cupertino.dart';

typedef TypeWriteInlineSpanBuilder = List<InlineSpan> Function(
    BuildContext context, int position, String text);

List<InlineSpan> _defaultTypeWriteInlineSpanBuilder(
  BuildContext context,
  int position,
  String text,
) {
  return [TextSpan(text: text)];
}

class TypewriterAnimatedText extends StatefulWidget {
  final String cursor;
  final TypeWriteInlineSpanBuilder? inlineSpanBuilder;
  final String text;
  final VoidCallback? textChanged;
  const TypewriterAnimatedText({
    super.key,
    this.cursor = "_",
    required this.text,
    this.textChanged,
    this.inlineSpanBuilder,
  });

  @override
  State<TypewriterAnimatedText> createState() => TypewriterAnimatedTextState();
}

class TypewriterAnimatedTextState extends State<TypewriterAnimatedText>
    with TickerProviderStateMixin {
  var _current = "".characters;
  var _pos = 0;

  late final _inlineSpanBuilder =
      widget.inlineSpanBuilder ?? _defaultTypeWriteInlineSpanBuilder;

  String get text => _current.take(_pos).toString();

  late final cursorController = AnimationController(
    vsync: this,
    value: 0.0,
    lowerBound: 0.0,
    upperBound: 1.0,
    duration: const Duration(milliseconds: 1000),
  );
  late final controller = AnimationController(vsync: this);

  @override
  void initState() {
    super.initState();

    cursorController.repeat();

    _current = widget.text.characters;
    _pos = _current.length;

    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      widget.textChanged?.call();
    });
  }

  void _updateText() {
    if (_pos < widget.text.length) {
      _current = widget.text.characters;
      if (!controller.isAnimating) {
        final duration = Duration(milliseconds: (_current.length - _pos) * 30);
        controller.duration = duration;
        controller.forward(from: 0.0).then((value) {
          _pos = _current.length;
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant TypewriterAnimatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.textChanged != null) {
      controller.addListener(widget.textChanged!);
    }
    _updateText();
  }

  @override
  void dispose() {
    cursorController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 开始取字符串
    return AnimatedBuilder(
      animation: CurvedAnimation(curve: Curves.linear, parent: controller),
      builder: (context, child) {
        // 开始取字符串
        final count = (controller.value * (_current.length - _pos)).round();
        // debugPrint("count: $count value: ${controller.value}");
        return Text.rich(
          TextSpan(
            children: [
              ..._inlineSpanBuilder(
                  context, count + _pos, _current.take(_pos + count).string),
              if (child != null) WidgetSpan(child: child),
            ],
          ),
          style: DefaultTextStyle.of(context).style,
        );
      },
      child: AnimatedBuilder(
        animation: cursorController,
        builder: (context, _) {
          return Text(
            " ${widget.cursor}",
            style: TextStyle(
              color: CupertinoColors.secondaryLabel
                  .resolveFrom(context)
                  .withOpacity(
                    cursorController.value > 0.5 ? 1 : 0,
                  ),
            ),
          );
        },
      ),
    );
  }
}
