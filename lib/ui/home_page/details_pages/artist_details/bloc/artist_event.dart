part of 'artist_bloc.dart';


class ArtistEvent extends Equatable {
  final String artistId;

  const ArtistEvent(this.artistId);

  @override
  List<Object?> get props => [artistId];
}

class GetAlbums extends ArtistEvent {
  const GetAlbums(super.artistId);
}
class GetTopTracks extends ArtistEvent {
  const GetTopTracks(super.artistId);
}
class GetRelatedArtists extends ArtistEvent {
  const GetRelatedArtists(super.artistId);
}
