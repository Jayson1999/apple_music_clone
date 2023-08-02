part of 'listennow_bloc.dart';


enum ListenNowStatus { initial, success, error, loading }

extension ListenNowStatusX on ListenNowStatus {
  bool get isInitial => this == ListenNowStatus.initial;
  bool get isSuccess => this == ListenNowStatus.success;
  bool get isError => this == ListenNowStatus.error;
  bool get isLoading => this == ListenNowStatus.loading;
}

class ListenNowState extends Equatable {
  const ListenNowState({
    this.status = ListenNowStatus.initial,
    this.userSubscription = 0,
    this.errorMsg = '',
  });

  final ListenNowStatus status;
  final int userSubscription;
  final String errorMsg;

  @override
  List<Object?> get props => [
    status,
    userSubscription,
    errorMsg
  ];

  ListenNowState copyWith(
      {ListenNowStatus? status,
        int? userSubscription,
        String? errorMsg}) {
    return ListenNowState(
        status: status ?? this.status,
        userSubscription: userSubscription ?? this.userSubscription,
        errorMsg: errorMsg ?? this.errorMsg);
  }
}
