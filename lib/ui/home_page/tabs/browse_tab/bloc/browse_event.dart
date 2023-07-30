part of 'browse_bloc.dart';


class BrowseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetLatestAlbums extends BrowseEvent {}
class GetFeaturedPlaylists extends BrowseEvent {}
class GetCategoriesPlaylists extends BrowseEvent {}
