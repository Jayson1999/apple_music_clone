part of 'search_bloc.dart';


enum SearchStatus { initial, success, error, loading }

extension SearchStatusX on SearchStatus {
  bool get isInitial => this == SearchStatus.initial;
  bool get isSuccess => this == SearchStatus.success;
  bool get isError => this == SearchStatus.error;
  bool get isLoading => this == SearchStatus.loading;
}

class SearchState extends Equatable {
  const SearchState({
    this.pageLoadStatus = SearchStatus.initial,
    this.searchStatus = SearchStatus.initial,
    this.categoriesGlobalPlaylists = const [],
    this.categoriesLocalPlaylists = const [],
    this.categoriesGlobal = const [],
    this.categoriesLocal = const [],
    this.searchedResults = const[],
    this.userSubscription = 0,
    this.errorMsg = '',
  });

  final SearchStatus pageLoadStatus;
  final SearchStatus searchStatus;
  final List<List<Playlist>> categoriesGlobalPlaylists;
  final List<List<Playlist>> categoriesLocalPlaylists;
  final List<Category> categoriesGlobal;
  final List<Category> categoriesLocal;
  final List searchedResults;
  final int userSubscription;
  final String errorMsg;

  @override
  List<Object?> get props => [
    pageLoadStatus,
    searchStatus,
    categoriesGlobalPlaylists,
    categoriesLocalPlaylists,
    categoriesGlobal,
    categoriesLocal,
    searchedResults,
    userSubscription,
    errorMsg
  ];

  SearchState copyWith(
      { List<List<Playlist>>? categoriesGlobalPlaylists,
        List<List<Playlist>>? categoriesLocalPlaylists,
        List<Category>? categoriesGlobal,
        List<Category>? categoriesLocal,
        List? searchedResults,
        SearchStatus? pageLoadStatus,
        SearchStatus? searchStatus,
        int? userSubscription,
        String? errorMsg}) {
    return SearchState(
        categoriesGlobalPlaylists: categoriesGlobalPlaylists ?? this.categoriesGlobalPlaylists,
        categoriesLocalPlaylists: categoriesLocalPlaylists ?? this.categoriesLocalPlaylists,
        categoriesGlobal: categoriesGlobal ?? this.categoriesGlobal,
        categoriesLocal: categoriesLocal ?? this.categoriesLocal,
        searchedResults: searchedResults ?? this.searchedResults,
        pageLoadStatus: pageLoadStatus ?? this.pageLoadStatus,
        searchStatus: searchStatus ?? this.searchStatus,
        userSubscription: userSubscription ?? this.userSubscription,
        errorMsg: errorMsg ?? this.errorMsg);
  }

}
