part of 'search_bloc.dart';


class SearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetUserSubscription extends SearchEvent {}
class GetCategoriesPlaylists extends SearchEvent {}
class SearchTextChanged extends SearchEvent {
  final String searchedText;

  SearchTextChanged(this.searchedText);

  @override
  List<Object?> get props => [searchedText];
}
