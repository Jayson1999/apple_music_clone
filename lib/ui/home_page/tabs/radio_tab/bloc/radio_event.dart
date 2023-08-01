part of 'radio_bloc.dart';


class RadioEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetUserSubscription extends RadioEvent {}
class GetLatestAlbumsArtists extends RadioEvent {}
class GetFeaturedPlaylists extends RadioEvent {}
