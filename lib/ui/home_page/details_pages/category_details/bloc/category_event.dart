part of 'category_bloc.dart';


class CategoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetTracksAndArtists extends CategoryEvent {
  final List<String> playlistIds;

  GetTracksAndArtists(this.playlistIds);

  @override
  List<Object?> get props => [playlistIds];
}
