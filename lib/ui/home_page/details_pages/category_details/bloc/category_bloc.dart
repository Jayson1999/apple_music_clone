import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/model/track.dart';
import 'package:apple_music_clone/repository/api_helper.dart';
import 'package:apple_music_clone/repository/artist_service.dart';
import 'package:apple_music_clone/repository/playlist_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'category_event.dart';
part 'category_state.dart';


class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final APIHelper _apiHelper = APIHelper();
  late PlaylistService _playlistService;
  late ArtistService _artistService;

  CategoryBloc(): super(const CategoryState()) {
    _playlistService = PlaylistService(_apiHelper);
    _artistService =ArtistService(_apiHelper);

    on<GetTracksAndArtists>(_mapGetTracksAndArtistsEventToState);
  }

  void _mapGetTracksAndArtistsEventToState(GetTracksAndArtists event, Emitter<CategoryState> emit) async {
    final List<String> playlistIds = event.playlistIds;
    emit(state.copyWith(categoryStatus: CategoryStatus.loading));

    try {
      List<Future<Playlist>> futures = [for (String playlistId in playlistIds) _playlistService.getPlaylistById(playlistId)];
      List<Playlist> playlists = await Future.wait(futures);

      List<Track> tracksList = [];
      List<Future<List<Artist>>> artistsFutures = [];
      for (Playlist playlist in playlists){
        tracksList = [...tracksList, ...playlist.tracks];

        List<String> currentPlaylistArtistIds = [for (Track t in playlist.tracks) if (t.artists.isNotEmpty) t.artists.first.id];
        artistsFutures.add(_artistService.getArtistsByIds(currentPlaylistArtistIds));
      }
      List<List<Artist>> artistsListsInList = await Future.wait(artistsFutures);
      List<Artist> artistsList = [for(List<Artist> aList in artistsListsInList) ...aList];

      emit(state.copyWith(
          categoryStatus: CategoryStatus.success,
          tracks: tracksList,
          artists: artistsList
      ));
    } catch (e, stack) {
      emit(state.copyWith(categoryStatus: CategoryStatus.error, errorMsg: '$e\n$stack'));
    }
  }

}
