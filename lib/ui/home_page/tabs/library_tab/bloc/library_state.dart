part of 'library_bloc.dart';


enum LibraryStatus { initial, success, error, loading }

extension LibraryStatusX on LibraryStatus {
  bool get isInitial => this == LibraryStatus.initial;
  bool get isSuccess => this == LibraryStatus.success;
  bool get isError => this == LibraryStatus.error;
  bool get isLoading => this == LibraryStatus.loading;
}

class LibraryState extends Equatable {
  const LibraryState({
    this.status = LibraryStatus.initial,
    this.userSubscription = 0,
    this.errorMsg = '',
  });

  final LibraryStatus status;
  final int userSubscription;
  final String errorMsg;

  @override
  List<Object?> get props => [
    status,
    userSubscription,
    errorMsg
  ];

  LibraryState copyWith(
      {LibraryStatus? status,
        int? userSubscription,
        String? errorMsg}) {
    return LibraryState(
        status: status ?? this.status,
        userSubscription: userSubscription ?? this.userSubscription,
        errorMsg: errorMsg ?? this.errorMsg);
  }
}
