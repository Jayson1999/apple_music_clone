part of 'theme_bloc.dart';


enum ThemeStatus { initial, success, error, loading }

extension ThemeStatusX on ThemeStatus {
  bool get isInitial => this == ThemeStatus.initial;
  bool get isSuccess => this == ThemeStatus.success;
  bool get isError => this == ThemeStatus.error;
  bool get isLoading => this == ThemeStatus.loading;
}

class ThemeState extends Equatable {
  const ThemeState(
      {this.status = ThemeStatus.initial,
        this.themeMode = ThemeMode.system,
        this.errorMsg = ''});

  final ThemeStatus status;
  final ThemeMode themeMode;
  final String errorMsg;

  @override
  List<Object?> get props => [status, themeMode, errorMsg];

  ThemeState copyWith(
      {ThemeStatus? status, ThemeMode? themeMode, String? errorMsg}) {
    return ThemeState(
        status: status ?? this.status,
        themeMode: themeMode ?? this.themeMode,
        errorMsg: errorMsg ?? this.errorMsg);
  }
}