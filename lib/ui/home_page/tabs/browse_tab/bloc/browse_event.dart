part of 'browse_bloc.dart';


class BrowseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetUserSubscription extends BrowseEvent {}
class GetLatestAlbumsArtists extends BrowseEvent {}
class GetFeaturedPlaylists extends BrowseEvent {}
class GetCategoriesPlaylists extends BrowseEvent {}
