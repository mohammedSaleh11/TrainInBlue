import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// One onboarding page: full-bleed hero image with rounded bottom corners,
/// followed by a centered headline and supporting copy. The text area
/// scrolls so large accessibility text never overflows.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.imageAsset,
    required this.headline,
    required this.copy,
  });

  final String imageAsset;
  final String headline;
  final String copy;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: ClipRRect(
            borderRadius: BorderRadiusDirectional.only(
              bottomStart: Radius.circular(36.r),
              bottomEnd: Radius.circular(36.r),
            ),
            child: Image.asset(
              imageAsset,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(24.w, 28.h, 24.w, 8.h),
            child: Column(
              children: <Widget>[
                Text(
                  headline,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium,
                ),
                SizedBox(height: 14.h),
                Text(
                  copy,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
