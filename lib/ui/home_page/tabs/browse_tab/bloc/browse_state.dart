part of 'browse_bloc.dart';


abstract class BrowseState extends Equatable {
  const BrowseState();

  @override
  List<Object?> get props => [];
}

class BrowseLoading extends BrowseState {
  // State to indicate that data is being loaded
}

class BrowseLoaded extends BrowseState {
  // State to indicate that data has been successfully loaded
  final List<Album> albums; // Your Album model
  // final List<Artist> artists; // Your Artist model

  BrowseLoaded({
    required this.albums,
    // required this.artists
  });

  @override
  List<Object?> get props => [
    albums,
    // artists
  ];
}

class BrowseError extends BrowseState {
  // State to indicate that an error occurred while fetching data
  final String errorMessage;

  BrowseError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
