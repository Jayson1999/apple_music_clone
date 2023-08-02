part of 'search_bloc.dart';


enum SearchStatus { initial, success, error, loading }

extension SearchStatusX on SearchStatus {
  bool get isInitial => this == SearchStatus.initial;
  bool get isSuccess => this == SearchStatus.success;
  bool get isError => this == SearchStatus.error;
  bool get isLoading => this == SearchStatus.loading;
}

class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.latestGlobalAlbums = const [],
    this.latestLocalAlbums = const [],
    this.featuredGlobalPlaylists = const [],
    this.featuredLocalPlaylists = const [],
    this.categoriesGlobalPlaylists = const [],
    this.categoriesLocalPlaylists = const [],
    this.categoriesGlobal = const [],
    this.categoriesLocal = const [],
    this.artistsGlobal = const [],
    this.artistsLocal = const [],
    this.recommendedTracks = const[],
    this.userSubscription = 0,
    this.errorMsg = '',
  });

  final SearchStatus status;
  final List<Album> latestGlobalAlbums;
  final List<Album> latestLocalAlbums;
  final List<Playlist> featuredGlobalPlaylists;
  final List<Playlist> featuredLocalPlaylists;
  final List<List<Playlist>> categoriesGlobalPlaylists;
  final List<List<Playlist>> categoriesLocalPlaylists;
  final List<Category> categoriesGlobal;
  final List<Category> categoriesLocal;
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
    categoriesGlobalPlaylists,
    categoriesLocalPlaylists,
    categoriesGlobal,
    categoriesLocal,
    artistsGlobal,
    artistsLocal,
    recommendedTracks,
    userSubscription,
    errorMsg
  ];

  SearchState copyWith(
      {List<Album>? latestGlobalAlbums,
        List<Album>? latestLocalAlbums,
        List<Playlist>? featuredGlobalPlaylists,
        List<Playlist>? featuredLocalPlaylists,
        List<List<Playlist>>? categoriesGlobalPlaylists,
        List<List<Playlist>>? categoriesLocalPlaylists,
        List<Category>? categoriesGlobal,
        List<Category>? categoriesLocal,
        List<Artist>? artistsGlobal,
        List<Artist>? artistsLocal,
        List<Track>? recommendedTracks,
        SearchStatus? status,
        int? userSubscription,
        String? errorMsg}) {
    return SearchState(
        latestGlobalAlbums: latestGlobalAlbums ?? this.latestGlobalAlbums,
        latestLocalAlbums: latestLocalAlbums ?? this.latestLocalAlbums,
        featuredGlobalPlaylists: featuredGlobalPlaylists ?? this.featuredGlobalPlaylists,
        featuredLocalPlaylists: featuredLocalPlaylists ?? this.featuredLocalPlaylists,
        categoriesGlobalPlaylists: categoriesGlobalPlaylists ?? this.categoriesGlobalPlaylists,
        categoriesLocalPlaylists: categoriesLocalPlaylists ?? this.categoriesLocalPlaylists,
        categoriesGlobal: categoriesGlobal ?? this.categoriesGlobal,
        categoriesLocal: categoriesLocal ?? this.categoriesLocal,
        artistsGlobal: artistsGlobal ?? this.artistsGlobal,
        artistsLocal: artistsLocal ?? this.artistsLocal,
        recommendedTracks: recommendedTracks ?? this.recommendedTracks,
        status: status ?? this.status,
        userSubscription: userSubscription ?? this.userSubscription,
        errorMsg: errorMsg ?? this.errorMsg);
  }
}
