part of 'category_bloc.dart';


enum CategoryStatus { initial, success, error, loading }

extension CategoryStatusX on CategoryStatus {
  bool get isInitial => this == CategoryStatus.initial;
  bool get isSuccess => this == CategoryStatus.success;
  bool get isError => this == CategoryStatus.error;
  bool get isLoading => this == CategoryStatus.loading;
}

class CategoryState extends Equatable {
  const CategoryState({
    this.categoryStatus = CategoryStatus.initial,
    this.tracks = const [],
    this.artists = const [],
    this.errorMsg = '',
  });

  final CategoryStatus categoryStatus;
  final List<Track> tracks;
  final List<Artist> artists;
  final String errorMsg;

  @override
  List<Object?> get props => [
    categoryStatus,
    tracks,
    artists,
    errorMsg
  ];

  CategoryState copyWith(
      { CategoryStatus? categoryStatus,
        List<Track>? tracks,
        List<Artist>? artists,
        String? errorMsg}) {
    return CategoryState(
        categoryStatus: categoryStatus ?? this.categoryStatus,
        tracks: tracks ?? this.tracks,
        artists: artists ?? this.artists,
        errorMsg: errorMsg ?? this.errorMsg);
  }

}
