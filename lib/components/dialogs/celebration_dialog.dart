import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Core/constants/app_assets.dart';
import '../../Core/constants/app_strings.dart';

/// Lightweight celebration shown once when the final exercise is completed.
Future<void> showCelebrationDialog(
  BuildContext context, {
  required int totalExercises,
}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      final TextTheme textTheme = Theme.of(dialogContext).textTheme;
      return Dialog(
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              AppAssets.celebration,
              height: 200.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24.w, 22.h, 24.w, 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    AppStrings.celebrationTitle,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    AppStrings.celebrationMessage(totalExercises),
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge,
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text(AppStrings.keepTraining),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
