import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'theme_event.dart';
part 'theme_state.dart';


class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<GetCurrentTheme>(_mapGetCurrentThemeEventToState);
  }

  void _mapGetCurrentThemeEventToState(GetCurrentTheme event, Emitter<ThemeState> emit) async {
    emit(state.copyWith(status: ThemeStatus.loading));

    final SharedPreferences preferences = await SharedPreferences.getInstance();
    int themeIndex = preferences.getInt('theme') ?? 2;
    emit(state.copyWith(
        status: ThemeStatus.success, themeMode: ThemeMode.values[themeIndex]
    ));
  }
}
