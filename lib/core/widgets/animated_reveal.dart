import 'dart:async';

import 'package:flutter/material.dart';

class AnimatedReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final Offset beginOffset;
  final double beginScale;

  const AnimatedReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 420),
    this.curve = Curves.easeOutCubic,
    this.beginOffset = const Offset(0, 0.04),
    this.beginScale = 0.98,
  });

  @override
  State<AnimatedReveal> createState() => _AnimatedRevealState();
}

class _AnimatedRevealState extends State<AnimatedReveal> {
  Timer? _timer;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.delay, () {
      if (!mounted) return;
      setState(() => _visible = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: widget.duration,
      curve: widget.curve,
      tween: Tween<double>(begin: 0, end: _visible ? 1 : 0),
      child: widget.child,
      builder: (context, value, child) {
        final dx = widget.beginOffset.dx * (1 - value);
        final dy = widget.beginOffset.dy * (1 - value);
        final scale = widget.beginScale + ((1 - widget.beginScale) * value);

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(dx * 40, dy * 40),
            child: Transform.scale(scale: scale, child: child),
          ),
        );
      },
    );
  }
}
