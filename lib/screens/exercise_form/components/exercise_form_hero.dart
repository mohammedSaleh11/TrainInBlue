import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/app_assets.dart';
import '../../../Core/constants/app_strings.dart';
import '../../../Core/constants/colors.dart';
import '../../../widgets/exercise_image.dart';
import '../../exercise_detail/components/detail_hero_parts.dart';

/// Full-bleed form hero: exercise/category photo when available, otherwise
/// the branded form hero image. Title and frosted back sit over the scrim.
class ExerciseFormHero extends StatelessWidget {
  const ExerciseFormHero({
    super.key,
    required this.title,
    required this.name,
    required this.category,
  });

  final String title;
  final String name;
  final String category;

  bool get _hasResolvedImage =>
      name.trim().isNotEmpty || category.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double topInset = MediaQuery.viewPaddingOf(context).top;
    return SizedBox(
      height: 310.h + topInset,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadiusDirectional.only(
          bottomStart: Radius.circular(32.r),
          bottomEnd: Radius.circular(32.r),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            if (_hasResolvedImage)
              ExerciseImage(name: name, category: category, expand: true)
            else
              Image.asset(
                AppAssets.exerciseFormHero,
                fit: BoxFit.cover,
                gaplessPlayback: true,
              ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: <double>[0.0, 0.32, 0.68, 1.0],
                  colors: <Color>[
                    Color(0xA60A1E4A),
                    Color(0x1A0A1E4A),
                    Color(0x800A1E4A),
                    AppColorPalette.heroScrim,
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                12.w,
                topInset + 8.h,
                12.w,
                0,
              ),
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: DetailHeroIconButton(
                  icon: Icons.arrow_back_rounded,
                  tooltip: AppStrings.back,
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(22.w, 0, 22.w, 40.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: textTheme.headlineMedium?.copyWith(
                        color: AppColorPalette.textOnDark,
                        height: 1.12,
                        letterSpacing: -0.3,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      AppStrings.formHeroSubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColorPalette.textOnDark.withValues(
                          alpha: 0.82,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
