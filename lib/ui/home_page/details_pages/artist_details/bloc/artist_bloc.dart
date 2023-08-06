import 'package:apple_music_clone/model/album.dart';
import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/model/track.dart';
import 'package:apple_music_clone/repository/api_helper.dart';
import 'package:apple_music_clone/repository/artist_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'artist_event.dart';
part 'artist_state.dart';


class ArtistBloc extends Bloc<ArtistEvent, ArtistState> {
  final APIHelper _apiHelper = APIHelper();
  late ArtistService _artistService;

  ArtistBloc(): super(const ArtistState()) {
    _artistService = ArtistService(_apiHelper);

    on<GetAlbums>(_mapGetAlbumsEventToState);
    on<GetTopTracks>(_mapGetTopTracksEventToState);
    on<GetRelatedArtists>(_mapGetRelatedArtistsEventToState);
  }

  void _mapGetAlbumsEventToState(GetAlbums event, Emitter<ArtistState> emit) async {
    final String artistId = event.artistId;
    emit(state.copyWith(artistStatus: ArtistStatus.loading));

    try {
      final List<Album> albums = await _artistService.getArtistAlbums(artistId);
      emit(state.copyWith(
          albums: albums
      ));
    } catch (e, stack) {
      emit(state.copyWith(artistStatus: ArtistStatus.error, errorMsg: '$e\n$stack'));
    }
  }

  void _mapGetTopTracksEventToState(GetTopTracks event, Emitter<ArtistState> emit) async {
    final String artistId = event.artistId;
    emit(state.copyWith(artistStatus: ArtistStatus.loading));

    try {
      final List<Track> topTracks = await _artistService.getArtistTopTracks(artistId);
      emit(state.copyWith(
          topTracks: topTracks
      ));
    } catch (e, stack) {
      emit(state.copyWith(artistStatus: ArtistStatus.error, errorMsg: '$e\n$stack'));
    }
  }

  void _mapGetRelatedArtistsEventToState(GetRelatedArtists event, Emitter<ArtistState> emit) async {
    final String artistId = event.artistId;
    emit(state.copyWith(artistStatus: ArtistStatus.loading));

    try {
      final List<Artist> relatedArtists = await _artistService.getRelatedArtists(artistId);
      emit(state.copyWith(
          artistStatus: ArtistStatus.success,
          relatedArtists: relatedArtists
      ));
    } catch (e, stack) {
      emit(state.copyWith(artistStatus: ArtistStatus.error, errorMsg: '$e\n$stack'));
    }
  }

}
