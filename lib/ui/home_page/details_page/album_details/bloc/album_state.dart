part of 'album_bloc.dart';


enum AlbumStatus { initial, success, error, loading }

extension AlbumStatusX on AlbumStatus {
  bool get isInitial => this == AlbumStatus.initial;
  bool get isSuccess => this == AlbumStatus.success;
  bool get isError => this == AlbumStatus.error;
  bool get isLoading => this == AlbumStatus.loading;
}

class AlbumState extends Equatable {
  const AlbumState({
    this.albumStatus = AlbumStatus.initial,
    this.userSubscription = 0,
    this.albumDetails,
    this.errorMsg = '',
  });

  final AlbumStatus albumStatus;
  final int userSubscription;
  final Album? albumDetails;
  final String errorMsg;

  @override
  List<Object?> get props => [
    albumStatus,
    userSubscription,
    albumDetails,
    errorMsg
  ];

  AlbumState copyWith(
      { AlbumStatus? albumStatus,
        int? userSubscription,
        Album? albumDetails,
        String? errorMsg}) {
    return AlbumState(
        albumStatus: albumStatus ?? this.albumStatus,
        userSubscription: userSubscription ?? this.userSubscription,
        albumDetails: albumDetails ?? this.albumDetails,
        errorMsg: errorMsg ?? this.errorMsg);
  }

}
