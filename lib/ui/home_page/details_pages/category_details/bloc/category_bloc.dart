import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/model/track.dart';
import 'package:apple_music_clone/repository/api_helper.dart';
import 'package:apple_music_clone/repository/playlist_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'category_event.dart';
part 'category_state.dart';


class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final APIHelper _apiHelper = APIHelper();
  late PlaylistService _playlistService;

  CategoryBloc(): super(const CategoryState()) {
    _playlistService = PlaylistService(_apiHelper);

    on<GetTracksAndArtists>(_mapGetTracksAndArtistsEventToState);
  }

  void _mapGetTracksAndArtistsEventToState(GetTracksAndArtists event, Emitter<CategoryState> emit) async {
    final List<String> playlistIds = event.playlistIds;
    emit(state.copyWith(categoryStatus: CategoryStatus.loading));

    try {
      List<Track> tracksList = [];
      List<Artist> artistsList = [];
      for (String playlistId in playlistIds){
        final Playlist playlistDetails = await _playlistService.getPlaylistById(playlistId);
        tracksList = [...tracksList, ...playlistDetails.tracks];
        artistsList = [...artistsList, ...[for (Track t in playlistDetails.tracks) for (Artist a in t.artists) a]];
      }

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
