import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/app_keys.dart';
import '../../../Core/constants/app_strings.dart';
import '../../../Core/constants/colors.dart';
import 'detail_panel.dart';

/// Foreground countdown for one set of a duration exercise.
class DurationTimerCard extends StatefulWidget {
  const DurationTimerCard({super.key, required this.durationSeconds});

  final int durationSeconds;

  @override
  State<DurationTimerCard> createState() => _DurationTimerCardState();
}

class _DurationTimerCardState extends State<DurationTimerCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.durationSeconds),
    )..addStatusListener((AnimationStatus status) => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isFinished => _controller.isCompleted;

  void _toggle() {
    setState(() {
      _controller.isAnimating ? _controller.stop() : _controller.forward();
    });
  }

  void _restart() {
    setState(() {
      _controller
        ..reset()
        ..forward();
    });
  }

  String _clock(double progress) {
    final int remaining = (widget.durationSeconds * (1 - progress)).ceil();
    final int minutes = remaining ~/ 60;
    final int seconds = remaining % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String get _toggleLabel {
    if (_controller.isAnimating) {
      return AppStrings.timerPause;
    }
    return _controller.value > 0
        ? AppStrings.timerResume
        : AppStrings.timerStart;
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return DetailPanel(
      title: AppStrings.setTimerTitle,
      icon: Icons.timer_outlined,
      child: Column(
        children: <Widget>[
          AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, _) {
              final Color ringColor = _isFinished
                  ? AppColorPalette.successGreen
                  : AppColorPalette.primaryBlue;
              return SizedBox(
                width: 168.r,
                height: 168.r,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      width: 168.r,
                      height: 168.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ringColor.withValues(alpha: 0.08),
                      ),
                    ),
                    SizedBox(
                      width: 150.r,
                      height: 150.r,
                      child: CircularProgressIndicator(
                        value: 1 - _controller.value,
                        strokeWidth: 11.r,
                        strokeCap: StrokeCap.round,
                        backgroundColor: AppColorPalette.surfaceTintBlue,
                        color: ringColor,
                      ),
                    ),
                    Text(
                      _clock(_controller.value),
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 16.h),
          if (_isFinished)
            Container(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 12.w,
                vertical: 6.h,
              ),
              decoration: BoxDecoration(
                color: AppColorPalette.successSurface,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                AppStrings.timerDone,
                style: textTheme.labelMedium?.copyWith(
                  color: AppColorPalette.successInk,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          SizedBox(height: 12.h),
          Row(
            children: <Widget>[
              Expanded(
                child: FilledButton.icon(
                  key: AppKeys.timerToggleButton,
                  onPressed: _isFinished ? null : _toggle,
                  icon: Icon(
                    _controller.isAnimating
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                  ),
                  label: Text(_toggleLabel),
                ),
              ),
              SizedBox(width: 10.w),
              OutlinedButton.icon(
                key: AppKeys.timerRestartButton,
                onPressed: _controller.value > 0 ? _restart : null,
                icon: const Icon(Icons.replay_rounded),
                label: const Text(AppStrings.timerRestart),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
