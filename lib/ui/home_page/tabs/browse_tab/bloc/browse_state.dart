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
    List<Album>? latestAlbums,
    this.errorMsg = '',
  }): latestAlbums = latestAlbums ?? const [];

  final BrowseStatus status;
  final List<Album> latestAlbums;
  final String errorMsg;

  @override
  List<Object?> get props => [status, latestAlbums, errorMsg];

  BrowseState copyWith({
    List<Album>? latestAlbums,
    BrowseStatus? status,
    String? errorMsg
  }) {
    return BrowseState(
      latestAlbums: latestAlbums ?? this.latestAlbums,
      status: status ?? this.status,
      errorMsg: errorMsg ?? this.errorMsg
    );
  }
}
