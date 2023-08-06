part of 'artist_bloc.dart';


enum ArtistStatus { initial, success, error, loading }

extension ArtistStatusX on ArtistStatus {
  bool get isInitial => this == ArtistStatus.initial;
  bool get isSuccess => this == ArtistStatus.success;
  bool get isError => this == ArtistStatus.error;
  bool get isLoading => this == ArtistStatus.loading;
}

class ArtistState extends Equatable {
  const ArtistState({
    this.artistStatus = ArtistStatus.initial,
    this.albums = const[],
    this.topTracks = const [],
    this.relatedArtists = const [],
    this.errorMsg = '',
  });

  final ArtistStatus artistStatus;
  final List<Album> albums;
  final List<Track> topTracks;
  final List<Artist> relatedArtists;
  final String errorMsg;

  @override
  List<Object?> get props => [
    artistStatus,
    albums,
    topTracks,
    relatedArtists,
    errorMsg
  ];

  ArtistState copyWith(
      { ArtistStatus? artistStatus,
        List<Album>? albums,
        List<Track>? topTracks,
        List<Artist>? relatedArtists,
        String? errorMsg}) {
    return ArtistState(
        artistStatus: artistStatus ?? this.artistStatus,
        albums: albums ?? this.albums,
        topTracks: topTracks ?? this.topTracks,
        relatedArtists: relatedArtists ?? this.relatedArtists,
        errorMsg: errorMsg ?? this.errorMsg);
  }

}
