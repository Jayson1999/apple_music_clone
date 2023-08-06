part of 'album_bloc.dart';


class AlbumEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetUserSubscription extends AlbumEvent {}
class GetAlbumDetails extends AlbumEvent {
  final String albumId;

  GetAlbumDetails(this.albumId);

  @override
  List<Object?> get props => [albumId];
}
