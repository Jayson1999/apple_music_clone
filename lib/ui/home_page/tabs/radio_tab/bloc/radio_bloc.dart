import 'package:apple_music_clone/model/album.dart';
import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/model/track.dart';
import 'package:apple_music_clone/repository/album_service.dart';
import 'package:apple_music_clone/repository/api_helper.dart';
import 'package:apple_music_clone/repository/artist_service.dart';
import 'package:apple_music_clone/repository/playlist_service.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'radio_event.dart';
part 'radio_state.dart';


class RadioBloc extends Bloc<RadioEvent, RadioState> {
  final APIHelper _apiHelper = APIHelper();
  late AlbumService _albumService;
  late PlaylistService _playlistService;
  late ArtistService _artistService;

  RadioBloc(): super(const RadioState()) {
    _albumService = AlbumService(_apiHelper);
    _playlistService = PlaylistService(_apiHelper);
    _artistService = ArtistService(_apiHelper);

    on<GetUserSubscription>(_mapGetUserSubscriptionEventToState);
    on<GetLatestAlbumsArtists>(_mapGetLatestAlbumsArtistsEventToState);
    on<GetFeaturedPlaylists>(_mapGetFeaturedPlaylistsEventToState);
  }

  void _mapGetUserSubscriptionEventToState(GetUserSubscription event, Emitter<RadioState> emit) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    int userSubscription = preferences.getInt('userSubscription') ?? 0;
    emit(state.copyWith(status: RadioStatus.success, userSubscription: userSubscription));
  }

  void _mapGetLatestAlbumsArtistsEventToState(GetLatestAlbumsArtists event, Emitter<RadioState> emit) async {
    emit(state.copyWith(status: RadioStatus.loading));

    try {
      final List<Album> globalAlbums = await _albumService.getNewReleasesAlbum();
      final List<Artist> globalArtists = await _artistService.getArtistsFromAlbums(globalAlbums);
      final List<String> globalAlbumIds = [for (Album album in globalAlbums) album.id];
      final List<Album> globalDetailedAlbums = await _albumService.getAlbumsByIds(globalAlbumIds);
      final List<Track> globalTracks = [for(Album album in globalDetailedAlbums) ...album.tracks];

      final List<Album> localAlbums = await _albumService.getNewReleasesAlbum(region: AppConfig.localRegion);
      final List<Artist> localArtists = await _artistService.getArtistsFromAlbums(localAlbums);
      final List<String> localAlbumIds = [for (Album album in localAlbums) album.id];
      final List<Album> localDetailedAlbums = await _albumService.getAlbumsByIds(localAlbumIds, country: AppConfig.localRegion);
      final List<Track> localTracks = [for(Album album in localDetailedAlbums) ...album.tracks];

      emit(state.copyWith(
          // status: RadioStatus.success,
          latestGlobalAlbums: globalAlbums,
          latestLocalAlbums: localAlbums,
          artistsGlobal: globalArtists,
          artistsLocal: localArtists,
          recommendedTracks: [...globalTracks, ...localTracks]
      ));
    } catch (e) {
      emit(state.copyWith(status: RadioStatus.error, errorMsg: '$e'));
    }
  }

  void _mapGetFeaturedPlaylistsEventToState(GetFeaturedPlaylists event, Emitter<RadioState> emit) async {
    emit(state.copyWith(status: RadioStatus.loading));

    try {
      final List<Playlist> globalPlaylists = await _playlistService.getFeaturedPlaylists();
      final List<Playlist> localPlaylists = await _playlistService.getFeaturedPlaylists(country: AppConfig.localRegion);
      emit(state.copyWith(
          status: RadioStatus.success,
          featuredGlobalPlaylists: globalPlaylists,
          featuredLocalPlaylists: localPlaylists
      ));
    } catch (e) {
      emit(state.copyWith(status: RadioStatus.error, errorMsg: '$e'));
    }
  }

}
