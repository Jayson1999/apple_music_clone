import 'package:apple_music_clone/model/album.dart';
import 'package:apple_music_clone/repository/album_service.dart';
import 'package:apple_music_clone/repository/api_helper.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'browse_event.dart';
part 'browse_state.dart';


class BrowseBloc extends Bloc<BrowseEvent, BrowseState> {
  final AlbumService _albumService = AlbumService(APIHelper());

  BrowseBloc(): super(const BrowseState()) {
    on<GetLatestAlbums>(_mapGetLatestAlbumsEventToState);
  }

  void _mapGetLatestAlbumsEventToState(GetLatestAlbums event, Emitter<BrowseState> emit) async {
    emit(state.copyWith(status: BrowseStatus.loading));

    try {
        final List<Album> globalAlbums = await _albumService.getNewReleasesAlbum();
        final List<Album> localAlbums = await _albumService.getNewReleasesAlbum(region: localRegion);
        emit(state.copyWith(status: BrowseStatus.success, latestGlobalAlbums: globalAlbums, latestLocalAlbums: localAlbums));
      } catch (e) {
        emit(state.copyWith(status: BrowseStatus.error, errorMsg: '$e'));
      }
  }
}
