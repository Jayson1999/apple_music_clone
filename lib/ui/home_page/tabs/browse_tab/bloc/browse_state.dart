part of 'browse_bloc.dart';


enum BrowseStatus { initial, success, error, loading }

extension BrowseStatusX on BrowseStatus {
  bool get isInitial => this == BrowseStatus.initial;
  bool get isSuccess => this == BrowseStatus.success;
  bool get isError => this == BrowseStatus.error;
  bool get isLoading => this == BrowseStatus.loading;
}

class BrowseState extends Equatable {
  const BrowseState({
    this.status = BrowseStatus.initial,
    this.latestGlobalAlbums = const [],
    this.latestLocalAlbums = const [],
    this.featuredGlobalPlaylists = const [],
    this.featuredLocalPlaylists = const [],
    this.errorMsg = '',
  });

  final BrowseStatus status;
  final List<Album> latestGlobalAlbums;
  final List<Album> latestLocalAlbums;
  final List<Playlist> featuredGlobalPlaylists;
  final List<Playlist> featuredLocalPlaylists;
  final String errorMsg;

  @override
  List<Object?> get props => [
        status,
        latestGlobalAlbums,
        latestLocalAlbums,
        featuredGlobalPlaylists,
        featuredLocalPlaylists,
        errorMsg
      ];

  BrowseState copyWith(
      {List<Album>? latestGlobalAlbums,
      List<Album>? latestLocalAlbums,
      List<Playlist>? featuredGlobalPlaylists,
      List<Playlist>? featuredLocalPlaylists,
      BrowseStatus? status,
      String? errorMsg}) {
    return BrowseState(
        latestGlobalAlbums: latestGlobalAlbums ?? this.latestGlobalAlbums,
        latestLocalAlbums: latestLocalAlbums ?? this.latestLocalAlbums,
        featuredGlobalPlaylists: featuredGlobalPlaylists ?? this.featuredGlobalPlaylists,
        featuredLocalPlaylists: featuredLocalPlaylists ?? this.featuredLocalPlaylists,
        status: status ?? this.status,
        errorMsg: errorMsg ?? this.errorMsg);
  }
}
