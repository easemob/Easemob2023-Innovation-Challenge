import 'package:flutter/material.dart';

class SoundBar extends StatefulWidget {
  final double height;
  final List<int> soundData;

  const SoundBar({
    super.key,
    required this.height,
    required this.soundData,
  });

  @override
  State<SoundBar> createState() => _SoundBarState();
}

class _SoundBarState extends State<SoundBar>
    with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
  );

  late final Animation<double> animation;

  var soundData = [0.0, 0.0, 0.0, 0.0];

  @override
  void initState() {
    super.initState();

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
    //
    // 动态更新widget中的值到state中
    _updateSoundData();

    controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant SoundBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateSoundData();
  }

  void _updateSoundData() {
    if (widget.soundData.isEmpty) {
      return;
    }

    final temp = [...List.generate(soundData.length, (index) => 0)];

    if (widget.soundData.length > soundData.length) {
      for (var i = 0; i < soundData.length; i++) {
        temp[i] = widget.soundData[widget.soundData.length - i - 1];
      }
    } else {
      temp[0] = widget.soundData.last;
    }

    soundData = temp.map((e) => e / 50).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return CustomPaint(
          painter: _SoundBarPainter(
            count: soundData.length,
            soundData: soundData
                .map((e) => e * animation.value)
                .toList(growable: false),
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _SoundBarPainter extends CustomPainter {
  final int count;
  final List<double> soundData;

  _SoundBarPainter({required this.count, required this.soundData})
      : assert(count > 0 && soundData.length == count);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    final w = size.height / 2;
    final offset = (size.width - w * count) / 2;
    for (var i = 0; i < count; i++) {
      final center = Offset(w * i + w / 2 + offset, size.height / 2);
      final rect = Rect.fromCenter(
          center: center, width: w, height: w * (1.0 + soundData[i]));
      final rr = RRect.fromRectAndRadius(rect, Radius.circular(w / 2));
      canvas.drawRRect(rr, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
