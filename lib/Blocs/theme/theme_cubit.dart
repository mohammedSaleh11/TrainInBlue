import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_theme/app_theme.dart';

/// Owns the active [ThemeData] so the app can restyle without restarting.
class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(AppTheme.light);
}
