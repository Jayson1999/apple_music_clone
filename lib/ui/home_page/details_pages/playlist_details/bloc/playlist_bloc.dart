import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/repository/api_helper.dart';
import 'package:apple_music_clone/repository/playlist_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'playlist_event.dart';
part 'playlist_state.dart';


class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final APIHelper _apiHelper = APIHelper();
  late PlaylistService _playlistService;

  PlaylistBloc(): super(const PlaylistState()) {
    _playlistService = PlaylistService(_apiHelper);

    on<GetUserSubscription>(_mapGetUserSubscriptionEventToState);
    on<GetPlaylistDetails>(_mapGetPlaylistDetailsEventToState);
  }

  void _mapGetUserSubscriptionEventToState(GetUserSubscription event, Emitter<PlaylistState> emit) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    int userSubscription = preferences.getInt('userSubscription') ?? 0;
    emit(state.copyWith(userSubscription: userSubscription));
  }

  void _mapGetPlaylistDetailsEventToState(GetPlaylistDetails event, Emitter<PlaylistState> emit) async {
    final playlistId = event.playlistId;
    emit(state.copyWith(playlistStatus: PlaylistStatus.loading));

    try {
      final Playlist playlistDetails = await _playlistService.getPlaylistById(playlistId);

      emit(state.copyWith(
          playlistStatus: PlaylistStatus.success,
          playlistDetails: playlistDetails
      ));
    } catch (e, stack) {
      emit(state.copyWith(playlistStatus: PlaylistStatus.error, errorMsg: '$e\n$stack'));
    }
  }

}
