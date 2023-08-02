import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'library_event.dart';
part 'library_state.dart';


class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {

  LibraryBloc(): super(const LibraryState()) {
    on<GetUserSubscription>(_mapGetUserSubscriptionEventToState);
  }

  void _mapGetUserSubscriptionEventToState(GetUserSubscription event, Emitter<LibraryState> emit) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    int userSubscription = preferences.getInt('userSubscription') ?? 0;
    emit(state.copyWith(status: LibraryStatus.success, userSubscription: userSubscription));
  }

}
