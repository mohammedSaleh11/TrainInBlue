import 'package:flutter/material.dart';

/// One-shot fade + upward-slide entrance, played when the widget first joins
/// the tree. Give list items increasing [delay]s for a staggered reveal.
///
/// The delay is baked into the animation curve (no timers), so tests and
/// rebuilds stay deterministic.
class StaggeredEntrance extends StatefulWidget {
  const StaggeredEntrance({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration delay;

  /// Stagger step for the item at [index], capped so long lists never make
  /// late items wait noticeably.
  static Duration delayForIndex(int index) {
    const int stepMs = 45;
    const int maxSteps = 6;
    return Duration(
      milliseconds: stepMs * (index > maxSteps ? maxSteps : index),
    );
  }

  @override
  State<StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<StaggeredEntrance>
    with SingleTickerProviderStateMixin {
  static const int _revealMs = 320;

  late final AnimationController _controller;
  late final CurvedAnimation _progress;

  @override
  void initState() {
    super.initState();
    final int totalMs = widget.delay.inMilliseconds + _revealMs;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalMs),
    );
    _progress = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        widget.delay.inMilliseconds / totalMs,
        1,
        curve: Curves.easeOutCubic,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _progress.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _progress,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(_progress),
        child: widget.child,
      ),
    );
  }
}
