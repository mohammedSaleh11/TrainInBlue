import 'package:flutter/material.dart';

import 'exercise_image.dart';

/// Shared-element photo for exercise card → detail. Interpolates clip radii
/// during flight so corners don't snap at the end of the morph.
class ExerciseImageHero extends StatelessWidget {
  const ExerciseImageHero({
    super.key,
    required this.exerciseId,
    required this.name,
    required this.category,
    required this.borderRadius,
  });

  final String exerciseId;
  final String name;
  final String category;
  final BorderRadius borderRadius;

  static String tagFor(String exerciseId) => 'exercise-image-$exerciseId';

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tagFor(exerciseId),
      createRectTween: (Rect? begin, Rect? end) {
        return RectTween(begin: begin, end: end);
      },
      flightShuttleBuilder: _flightShuttle,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Material(
          type: MaterialType.transparency,
          child: ExerciseImage(
            name: name,
            category: category,
            expand: true,
          ),
        ),
      ),
    );
  }

  static Widget _flightShuttle(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final BorderRadius fromRadius = _radiusOf(fromHeroContext);
    final BorderRadius toRadius = _radiusOf(toHeroContext);
    final Hero toHero = toHeroContext.widget as Hero;
    final Widget photo = _unwrappedChild(toHero.child);

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double t = Curves.easeInOutCubic.transform(animation.value);
        return ClipRRect(
          borderRadius: BorderRadius.lerp(fromRadius, toRadius, t)!,
          child: child,
        );
      },
      child: photo,
    );
  }

  static Widget _unwrappedChild(Widget child) {
    if (child is ClipRRect) {
      return child.child ?? child;
    }
    return child;
  }

  static BorderRadius _radiusOf(BuildContext heroContext) {
    final Widget child = (heroContext.widget as Hero).child;
    if (child is ClipRRect) {
      final BorderRadiusGeometry geometry = child.borderRadius;
      if (geometry is BorderRadius) {
        return geometry;
      }
      return geometry.resolve(Directionality.maybeOf(heroContext));
    }
    return BorderRadius.zero;
  }
}
