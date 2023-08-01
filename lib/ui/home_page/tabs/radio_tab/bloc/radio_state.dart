part of 'radio_bloc.dart';


enum RadioStatus { initial, success, error, loading }

extension RadioStatusX on RadioStatus {
  bool get isInitial => this == RadioStatus.initial;
  bool get isSuccess => this == RadioStatus.success;
  bool get isError => this == RadioStatus.error;
  bool get isLoading => this == RadioStatus.loading;
}

class RadioState extends Equatable {
  const RadioState({
    this.status = RadioStatus.initial,
    this.latestGlobalAlbums = const [],
    this.latestLocalAlbums = const [],
    this.featuredGlobalPlaylists = const [],
    this.featuredLocalPlaylists = const [],
    this.artistsGlobal = const [],
    this.artistsLocal = const [],
    this.recommendedTracks = const[],
    this.userSubscription = 0,
    this.errorMsg = '',
  });

  final RadioStatus status;
  final List<Album> latestGlobalAlbums;
  final List<Album> latestLocalAlbums;
  final List<Playlist> featuredGlobalPlaylists;
  final List<Playlist> featuredLocalPlaylists;
  final List<Artist> artistsGlobal;
  final List<Artist> artistsLocal;
  final List<Track> recommendedTracks;
  final int userSubscription;
  final String errorMsg;

  @override
  List<Object?> get props => [
    status,
    latestGlobalAlbums,
    latestLocalAlbums,
    featuredGlobalPlaylists,
    featuredLocalPlaylists,
    artistsGlobal,
    artistsLocal,
    recommendedTracks,
    userSubscription,
    errorMsg
  ];

  RadioState copyWith(
      {List<Album>? latestGlobalAlbums,
        List<Album>? latestLocalAlbums,
        List<Playlist>? featuredGlobalPlaylists,
        List<Playlist>? featuredLocalPlaylists,
        List<Artist>? artistsGlobal,
        List<Artist>? artistsLocal,
        List<Track>? recommendedTracks,
        RadioStatus? status,
        int? userSubscription,
        String? errorMsg}) {
    return RadioState(
        latestGlobalAlbums: latestGlobalAlbums ?? this.latestGlobalAlbums,
        latestLocalAlbums: latestLocalAlbums ?? this.latestLocalAlbums,
        featuredGlobalPlaylists: featuredGlobalPlaylists ?? this.featuredGlobalPlaylists,
        featuredLocalPlaylists: featuredLocalPlaylists ?? this.featuredLocalPlaylists,
        artistsGlobal: artistsGlobal ?? this.artistsGlobal,
        artistsLocal: artistsLocal ?? this.artistsLocal,
        recommendedTracks: recommendedTracks ?? this.recommendedTracks,
        status: status ?? this.status,
        userSubscription: userSubscription ?? this.userSubscription,
        errorMsg: errorMsg ?? this.errorMsg);
  }
}
