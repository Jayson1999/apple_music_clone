import 'package:apple_music_clone/model/album.dart';
import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/model/category.dart';
import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/repository/album_service.dart';
import 'package:apple_music_clone/repository/api_helper.dart';
import 'package:apple_music_clone/repository/artist_service.dart';
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
  late ArtistService _artistService;

  BrowseBloc(): super(const BrowseState()) {
    _albumService = AlbumService(_apiHelper);
     _playlistService = PlaylistService(_apiHelper);
     _categoryService = CategoryService(_apiHelper);
     _artistService = ArtistService(_apiHelper);

    on<GetLatestAlbumsArtists>(_mapGetLatestAlbumsArtistsEventToState);
    on<GetFeaturedPlaylists>(_mapGetFeaturedPlaylistsEventToState);
    on<GetCategoriesPlaylists>(_mapGetCategoriesPlaylistsEventToState);
  }

  void _mapGetLatestAlbumsArtistsEventToState(GetLatestAlbumsArtists event, Emitter<BrowseState> emit) async {
    emit(state.copyWith(status: BrowseStatus.loading));

    try {
        final List<Album> globalAlbums = await _albumService.getNewReleasesAlbum();
        final List<Artist> globalArtists = await _artistService.getArtistsFromAlbums(globalAlbums);
        
        final List<Album> localAlbums = await _albumService.getNewReleasesAlbum(region: localRegion);
        final List<Artist> localArtists = await _artistService.getArtistsFromAlbums(localAlbums);
        
        emit(state.copyWith(
            status: BrowseStatus.success,
            latestGlobalAlbums: globalAlbums,
            latestLocalAlbums: localAlbums,
            artistsGlobal: globalArtists,
            artistsLocal: localArtists
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
      final List<List<Playlist>> globalPlaylists = await _playlistService.getPlaylistsFromCategories(globalCategories);

      final List<Category> localCategories = await _categoryService.getBrowseCategories(country: localRegion);
      final List<List<Playlist>> localPlaylists = await _playlistService.getPlaylistsFromCategories(localCategories);

      emit(state.copyWith(
          status: BrowseStatus.success,
          categoriesGlobalPlaylists: globalPlaylists,
          categoriesLocalPlaylists: localPlaylists,
          categoriesGlobal: globalCategories,
          categoriesLocal: localCategories
      ));
    } catch (e) {
      emit(state.copyWith(status: BrowseStatus.error, errorMsg: '$e'));
    }
  }

}
