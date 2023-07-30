import 'package:apple_music_clone/model/album.dart';
import 'package:apple_music_clone/model/category.dart';
import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/repository/album_service.dart';
import 'package:apple_music_clone/repository/api_helper.dart';
import 'package:apple_music_clone/repository/category_service.dart';
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
  late CategoryService _categoryService;

  BrowseBloc(): super(const BrowseState()) {
    _albumService = AlbumService(_apiHelper);
     _playlistService = PlaylistService(_apiHelper);
     _categoryService = CategoryService(_apiHelper);

    on<GetLatestAlbums>(_mapGetLatestAlbumsEventToState);
    on<GetFeaturedPlaylists>(_mapGetFeaturedPlaylistsEventToState);
    on<GetCategoriesPlaylists>(_mapGetCategoriesPlaylistsEventToState);
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

  void _mapGetCategoriesPlaylistsEventToState(GetCategoriesPlaylists event, Emitter<BrowseState> emit) async {
    emit(state.copyWith(status: BrowseStatus.loading));

    try {
      final List<Category> globalCategories = await _categoryService.getBrowseCategories();
      final List<Future<List<Playlist>>> globalPlaylistsFuture = [for (Category category in globalCategories) _playlistService.getCategoryPlaylists(category.id)];
      final List<List<Playlist>> globalPlaylists = await Future.wait(globalPlaylistsFuture);

      final List<Category> localCategories = await _categoryService.getBrowseCategories(country: localRegion);
      final List<Future<List<Playlist>>> localPlaylistsFuture = [for (Category category in localCategories) _playlistService.getCategoryPlaylists(category.id)];
      final List<List<Playlist>> localPlaylists = await Future.wait(localPlaylistsFuture);

      emit(state.copyWith(
          status: BrowseStatus.success,
          categoriesGlobalPlaylists: globalPlaylists,
          categoriesLocalPlaylists: localPlaylists
      ));
    } catch (e) {
      emit(state.copyWith(status: BrowseStatus.error, errorMsg: '$e'));
    }
  }
}
