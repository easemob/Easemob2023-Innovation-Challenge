import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'sound_wave_painter.dart';

class IndicatorProgress {
  final double progress; // 0.0 至 1.0
  final int begin;
  final int end;

  const IndicatorProgress({
    required this.progress,
    required this.begin,
    required this.end,
  });
}

class Indicator extends StatefulWidget {
  final Color color;
  final bool thinking;
  final bool playing;
  final IndicatorProgress? bufferProgress;
  final IndicatorProgress? playProgress;

  const Indicator({
    super.key,
    required this.color,
    this.thinking = false,
    this.playing = false,
    this.playProgress,
    this.bufferProgress,
  });

  @override
  State<Indicator> createState() => IndicatorState();
}

class IndicatorState extends State<Indicator> with TickerProviderStateMixin {
  late final _workingController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
    reverseDuration: const Duration(milliseconds: 1500),
  );
  late final Animation<double> _workingAnimation;

  late final _thinkingController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3600),
  );
  late final Animation<double> _thinkingAnimation;

  late final _bufferProgressController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
    lowerBound: 0.0,
    upperBound: 1.0,
  );
  late final _playProgressController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  late final _random = math.Random();

  var _tipCount = 0;

  @override
  void initState() {
    super.initState();

    _workingAnimation = Tween<double>(begin: 0.9, end: 0.8).animate(
      CurvedAnimation(parent: _workingController, curve: Curves.linear),
    );
    _thinkingAnimation = Tween<double>(begin: 0.0, end: math.pi * 2).animate(
        CurvedAnimation(
            parent: _thinkingController, curve: Curves.fastOutSlowIn));

    _bufferProgressController.animateTo(
      (widget.bufferProgress?.progress ?? 0.0).clamp(0, 1.0),
    );

    if (widget.playing) {
      _workingController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant Indicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.thinking) {
      if (!oldWidget.thinking) {
        _tipCount = 4 + _random.nextInt(4);
      }
      if (!_thinkingController.isAnimating) {
        _thinkingController.repeat();
      }
    } else {
      _thinkingController.stop();
      _tipCount = 0;
    }

    _bufferProgressController.animateTo(
      widget.bufferProgress?.progress ?? 0.0,
      duration: const Duration(milliseconds: 500),
    );

    _playProgressController.animateTo(
      widget.playProgress?.progress ?? 0.0,
      duration: const Duration(milliseconds: 500),
    );

    if (widget.playing) {
      if (!oldWidget.playing) {
        _workingController.repeat(reverse: true);
      }
    } else {
      _workingController.stop();
    }
  }

  @override
  void dispose() {
    _thinkingController.dispose();
    _workingController.dispose();
    _bufferProgressController.dispose();
    _playProgressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _workingAnimation,
      builder: (context, _) => _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Stack(
            children: [
              AnimatedPositioned(
                right: widget.thinking ? 20 : 0,
                width: constraints.maxWidth * (widget.thinking ? 0.7 : 1.0),
                height: constraints.maxHeight,
                duration: const Duration(milliseconds: 180),
                child: _buildWave(context),
              ),
              if (widget.thinking)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 180),
                  bottom: 100,
                  left: 20,
                  width: constraints.maxWidth * 0.3,
                  height: constraints.maxWidth * (widget.thinking ? 0.3 : 0.0),
                  child: _buildWave(context),
                )
            ],
          ),
        );
      },
    );
  }

  Widget _buildWave(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _thinkingAnimation,
        _bufferProgressController,
        _playProgressController,
      ]),
      builder: (context, _) => CustomPaint(
        painter: SoundWavePainter(
          startAngle: _thinkingAnimation.value,
          tipCount: _tipCount,
          tipControlRatio: 1.5,
          radiusRatio: _workingAnimation.value,
          fillColor: widget.color,
          downloadProgress: _bufferProgressController.value,
          palyProgress: _playProgressController.value,
        ),
      ),
    );
  }
}
