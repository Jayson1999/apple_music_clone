part of 'browse_bloc.dart';


abstract class BrowseEvent extends Equatable {
  const BrowseEvent();

  @override
  List<Object?> get props => [];
}

class FetchAlbumsEvent extends BrowseEvent {
  // Event to trigger fetching albums from the AlbumService
}

class FetchArtistsEvent extends BrowseEvent {
  // Event to trigger fetching artists from the ArtistService
}
