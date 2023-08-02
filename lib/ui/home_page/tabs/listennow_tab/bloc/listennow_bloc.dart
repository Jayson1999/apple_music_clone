import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'listennow_event.dart';
part 'listennow_state.dart';


class ListenNowBloc extends Bloc<ListenNowEvent, ListenNowState> {

  ListenNowBloc(): super(const ListenNowState()) {
    on<GetUserSubscription>(_mapGetUserSubscriptionEventToState);
  }

  void _mapGetUserSubscriptionEventToState(GetUserSubscription event, Emitter<ListenNowState> emit) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    int userSubscription = preferences.getInt('userSubscription') ?? 0;
    emit(state.copyWith(status: ListenNowStatus.success, userSubscription: userSubscription));
  }

}
