import 'package:apple_music_clone/model/album.dart';
import 'package:apple_music_clone/repository/album_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'browse_event.dart';
part 'browse_state.dart';


class BrowseBloc extends Bloc<BrowseEvent, BrowseState> {
  final AlbumService albumService; // Your AlbumService
  // final ArtistService artistService; // Your ArtistService

  BrowseBloc({
    required this.albumService,
    // required this.artistService
  })
      : super(BrowseLoading());

  @override
  Stream<BrowseState> mapEventToState(BrowseEvent event) async* {
    if (event is FetchAlbumsEvent) {
      yield BrowseLoading();
      try {
        final List<Album> albums = await albumService.getAlbumsWithId();
        yield BrowseLoaded(
            albums: albums,
            // artists: []
        );
      } catch (e) {
        yield BrowseError('Failed to fetch albums');
      }
    } else if (event is FetchArtistsEvent) {
      yield BrowseLoading();
      // try {
        // final List<Artist> artists = await artistService.fetchArtists();
      //   yield BrowseLoaded(albums: [], artists: artists);
      // } catch (e) {
      //   yield BrowseError('Failed to fetch artists');
      // }
    }
  }
}
