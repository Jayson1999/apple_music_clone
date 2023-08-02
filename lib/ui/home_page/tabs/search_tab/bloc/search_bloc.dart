import 'package:apple_music_clone/model/album.dart';
import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/model/category.dart';
import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/model/track.dart';
import 'package:apple_music_clone/repository/api_helper.dart';
import 'package:apple_music_clone/repository/category_service.dart';
import 'package:apple_music_clone/repository/playlist_service.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'search_event.dart';
part 'search_state.dart';


class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final APIHelper _apiHelper = APIHelper();
  late PlaylistService _playlistService;
  late CategoryService _categoryService;

  SearchBloc(): super(const SearchState()) {
    _playlistService = PlaylistService(_apiHelper);
    _categoryService = CategoryService(_apiHelper);

    on<GetUserSubscription>(_mapGetUserSubscriptionEventToState);
    on<GetCategoriesPlaylists>(_mapGetCategoriesPlaylistsEventToState);
  }

  void _mapGetUserSubscriptionEventToState(GetUserSubscription event, Emitter<SearchState> emit) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    int userSubscription = preferences.getInt('userSubscription') ?? 0;
    emit(state.copyWith(userSubscription: userSubscription));
  }

  void _mapGetCategoriesPlaylistsEventToState(GetCategoriesPlaylists event, Emitter<SearchState> emit) async {
    emit(state.copyWith(status: SearchStatus.loading));

    try {
      final List<Category> globalCategories = await _categoryService.getBrowseCategories();
      final List<List<Playlist>> globalPlaylists = await _playlistService.getPlaylistsFromCategories(globalCategories);

      final List<Category> localCategories = await _categoryService.getBrowseCategories(country: localRegion);
      final List<List<Playlist>> localPlaylists = await _playlistService.getPlaylistsFromCategories(localCategories, country: localRegion);

      emit(state.copyWith(
          status: SearchStatus.success,
          categoriesGlobalPlaylists: globalPlaylists,
          categoriesLocalPlaylists: localPlaylists,
          categoriesGlobal: globalCategories,
          categoriesLocal: localCategories
      ));
    } catch (e) {
      emit(state.copyWith(status: SearchStatus.error, errorMsg: '$e'));
    }
  }

}
