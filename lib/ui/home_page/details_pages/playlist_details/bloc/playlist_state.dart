part of 'playlist_bloc.dart';


enum PlaylistStatus { initial, success, error, loading }

extension PlaylistStatusX on PlaylistStatus {
  bool get isInitial => this == PlaylistStatus.initial;
  bool get isSuccess => this == PlaylistStatus.success;
  bool get isError => this == PlaylistStatus.error;
  bool get isLoading => this == PlaylistStatus.loading;
}

class PlaylistState extends Equatable {
  const PlaylistState({
    this.playlistStatus = PlaylistStatus.initial,
    this.userSubscription = 0,
    this.playlistDetails,
    this.errorMsg = '',
  });

  final PlaylistStatus playlistStatus;
  final int userSubscription;
  final Playlist? playlistDetails;
  final String errorMsg;

  @override
  List<Object?> get props => [
    playlistStatus,
    userSubscription,
    playlistDetails,
    errorMsg
  ];

  PlaylistState copyWith(
      { PlaylistStatus? playlistStatus,
        int? userSubscription,
        Playlist? playlistDetails,
        String? errorMsg}) {
    return PlaylistState(
        playlistStatus: playlistStatus ?? this.playlistStatus,
        userSubscription: userSubscription ?? this.userSubscription,
        playlistDetails: playlistDetails ?? this.playlistDetails,
        errorMsg: errorMsg ?? this.errorMsg);
  }

}
