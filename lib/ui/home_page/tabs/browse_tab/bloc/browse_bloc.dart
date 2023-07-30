import 'package:apple_music_clone/model/album.dart';
import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/repository/album_service.dart';
import 'package:apple_music_clone/repository/api_helper.dart';
import 'package:apple_music_clone/repository/playlist_service.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'browse_event.dart';
part 'browse_state.dart';


class BrowseBloc extends Bloc<BrowseEvent, BrowseState> {
  final APIHelper _apiHelper = APIHelper();
  late AlbumService _albumService;
  late PlaylistService _playlistService;

  BrowseBloc(): super(const BrowseState()) {
    _albumService = AlbumService(_apiHelper);
     _playlistService = PlaylistService(_apiHelper);

    on<GetLatestAlbums>(_mapGetLatestAlbumsEventToState);
    on<GetFeaturedPlaylists>(_mapGetFeaturedPlaylistsEventToState);
  }

  void _mapGetLatestAlbumsEventToState(GetLatestAlbums event, Emitter<BrowseState> emit) async {
    emit(state.copyWith(status: BrowseStatus.loading));

    try {
        final List<Album> globalAlbums = await _albumService.getNewReleasesAlbum();
        final List<Album> localAlbums = await _albumService.getNewReleasesAlbum(region: localRegion);
        emit(state.copyWith(
            status: BrowseStatus.success,
            latestGlobalAlbums: globalAlbums,
            latestLocalAlbums: localAlbums
        ));
      } catch (e) {
        emit(state.copyWith(status: BrowseStatus.error, errorMsg: '$e'));
      }
  }

  void _mapGetFeaturedPlaylistsEventToState(GetFeaturedPlaylists event, Emitter<BrowseState> emit) async {
    emit(state.copyWith(status: BrowseStatus.loading));

    try {
      final List<Playlist> globalPlaylists = await _playlistService.getFeaturedPlaylists();
      final List<Playlist> localPlaylists = await _playlistService.getFeaturedPlaylists(country: localRegion);
      emit(state.copyWith(
          status: BrowseStatus.success,
          featuredGlobalPlaylists: globalPlaylists,
          featuredLocalPlaylists: localPlaylists
      ));
    } catch (e) {
      emit(state.copyWith(status: BrowseStatus.error, errorMsg: '$e'));
    }
  }
}
