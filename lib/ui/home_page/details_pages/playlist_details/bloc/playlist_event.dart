part of 'playlist_bloc.dart';


class PlaylistEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetUserSubscription extends PlaylistEvent {}
class GetPlaylistDetails extends PlaylistEvent {
  final String playlistId;

  GetPlaylistDetails(this.playlistId);

  @override
  List<Object?> get props => [playlistId];
}
