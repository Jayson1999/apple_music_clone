import 'package:apple_music_clone/model/album.dart';
import 'package:apple_music_clone/repository/api_helper.dart';
import 'package:apple_music_clone/repository/album_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'album_event.dart';
part 'album_state.dart';


class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final APIHelper _apiHelper = APIHelper();
  late AlbumService _albumService;

  AlbumBloc(): super(const AlbumState()) {
    _albumService = AlbumService(_apiHelper);

    on<GetUserSubscription>(_mapGetUserSubscriptionEventToState);
    on<GetAlbumDetails>(_mapGetAlbumDetailsEventToState);
  }

  void _mapGetUserSubscriptionEventToState(GetUserSubscription event, Emitter<AlbumState> emit) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    int userSubscription = preferences.getInt('userSubscription') ?? 0;
    emit(state.copyWith(userSubscription: userSubscription));
  }

  void _mapGetAlbumDetailsEventToState(GetAlbumDetails event, Emitter<AlbumState> emit) async {
    final albumId = event.albumId;
    emit(state.copyWith(albumStatus: AlbumStatus.loading));

    try {
      final Album albumDetails = (await _albumService.getAlbumsByIds([albumId])).first;

      emit(state.copyWith(
          albumStatus: AlbumStatus.success,
          albumDetails: albumDetails
      ));
    } catch (e, stack) {
      emit(state.copyWith(albumStatus: AlbumStatus.error, errorMsg: '$e\n$stack'));
    }
  }

}
