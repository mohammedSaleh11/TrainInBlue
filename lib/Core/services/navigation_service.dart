import 'package:flutter/material.dart';

/// Global navigation helpers built on a single navigator key, so BLoC
/// listeners and deeply nested widgets can navigate without threading a
/// [BuildContext] through every layer.
class NavigationService {
  NavigationService._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static NavigatorState get _navigator => navigatorKey.currentState!;

  static Future<T?> push<T>(Widget page, {BuildContext? context}) {
    final NavigatorState navigator = context != null
        ? Navigator.of(context)
        : _navigator;
    return navigator.push<T>(MaterialPageRoute<T>(builder: (_) => page));
  }

  static Future<T?> pushReplacement<T>(Widget page, {BuildContext? context}) {
    final NavigatorState navigator = context != null
        ? Navigator.of(context)
        : _navigator;
    return navigator.pushReplacement<T, void>(
      MaterialPageRoute<T>(builder: (_) => page),
    );
  }

  /// Pushes [page] and removes every previous route. Used after onboarding so
  /// Back never returns to it.
  static Future<T?> pushAndRemove<T>(Widget page) {
    return _navigator.pushAndRemoveUntil<T>(
      MaterialPageRoute<T>(builder: (_) => page),
      (Route<dynamic> route) => false,
    );
  }

  static void pop<T>([T? result, BuildContext? context]) {
    final NavigatorState navigator = context != null
        ? Navigator.of(context)
        : _navigator;
    navigator.pop<T>(result);
  }
}
