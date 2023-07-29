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
    List<Album>? latestGlobalAlbums,
    List<Album>? latestLocalAlbums,
    this.errorMsg = '',
  }): latestGlobalAlbums = latestGlobalAlbums ?? const [],
  latestLocalAlbums = latestLocalAlbums ?? const [];

  final BrowseStatus status;
  final List<Album> latestGlobalAlbums;
  final List<Album> latestLocalAlbums;
  final String errorMsg;

  @override
  List<Object?> get props => [status, latestGlobalAlbums, latestLocalAlbums, errorMsg];

  BrowseState copyWith({
    List<Album>? latestGlobalAlbums,
    List<Album>? latestLocalAlbums,
    BrowseStatus? status,
    String? errorMsg
  }) {
    return BrowseState(
      latestGlobalAlbums: latestGlobalAlbums ?? this.latestGlobalAlbums,
      latestLocalAlbums: latestLocalAlbums ?? this.latestLocalAlbums,
      status: status ?? this.status,
      errorMsg: errorMsg ?? this.errorMsg
    );
  }
}
