import 'package:apple_music_clone/model/category.dart';
import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/repository/api_helper.dart';
import 'package:apple_music_clone/repository/category_service.dart';
import 'package:apple_music_clone/repository/playlist_service.dart';
import 'package:apple_music_clone/repository/search_service.dart';
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
  late SearchService _searchService;

  SearchBloc(): super(const SearchState()) {
    _playlistService = PlaylistService(_apiHelper);
    _categoryService = CategoryService(_apiHelper);
    _searchService = SearchService(_apiHelper);

    on<GetUserSubscription>(_mapGetUserSubscriptionEventToState);
    on<GetCategoriesPlaylists>(_mapGetCategoriesPlaylistsEventToState);
    on<SearchTextChanged>(_mapSearchTextChangedEventToState);
  }

  void _mapGetUserSubscriptionEventToState(GetUserSubscription event, Emitter<SearchState> emit) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    int userSubscription = preferences.getInt('userSubscription') ?? 0;
    List<String> searchHistories = preferences.getStringList('searchHistories') ?? [];
    emit(state.copyWith(
        userSubscription: userSubscription,
        searchHistories: searchHistories
    ));
  }

  void _mapGetCategoriesPlaylistsEventToState(GetCategoriesPlaylists event, Emitter<SearchState> emit) async {
    emit(state.copyWith(pageLoadStatus: SearchStatus.loading));

    try {
      final List<Category> globalCategories = await _categoryService.getBrowseCategories();
      final List<List<Playlist>> globalPlaylists = await _playlistService.getPlaylistsFromCategories(globalCategories);

      final List<Category> localCategories = await _categoryService.getBrowseCategories(country: AppConfig.localRegion);
      final List<List<Playlist>> localPlaylists = await _playlistService.getPlaylistsFromCategories(localCategories, country: AppConfig.localRegion);

      emit(state.copyWith(
          pageLoadStatus: SearchStatus.success,
          categoriesGlobalPlaylists: globalPlaylists,
          categoriesLocalPlaylists: localPlaylists,
          categoriesGlobal: globalCategories,
          categoriesLocal: localCategories
      ));
    } catch (e) {
      emit(state.copyWith(pageLoadStatus: SearchStatus.error, errorMsg: '$e'));
    }
  }

  void _mapSearchTextChangedEventToState(SearchTextChanged event, Emitter<SearchState> emit) async {
    final queryStr = event.searchedText;
    emit(state.copyWith(searchStatus: SearchStatus.loading, searchedResults: []));

    try {
      final List searchResults = await _searchService.getSearchResults(queryStr);

      emit(state.copyWith(
          searchStatus: SearchStatus.success,
          searchedResults: searchResults
      ));
    } catch (e, stack) {
      emit(state.copyWith(searchStatus: SearchStatus.error, errorMsg: '$e\n$stack'));
    }
  }

}
