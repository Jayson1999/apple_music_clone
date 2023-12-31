import 'package:apple_music_clone/ui/home_page/tabs/library_tab/bloc/library_bloc.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LibraryTab extends StatefulWidget {
  const LibraryTab({Key? key}) : super(key: key);

  @override
  State<LibraryTab> createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<LibraryBloc>(context).add(GetUserSubscription());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<LibraryBloc, LibraryState>(
          builder: (context, state) {
            if (state.status.isLoading || state.status.isInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            else if (state.status.isSuccess) {
              ScrollController scrollController = ScrollController();
              double threshold = state.userSubscription != 0? 30.0: 40.0;
              return CustomScrollView(
                controller: scrollController,
                slivers: <Widget>[
                  SliverAppBar(

                    expandedHeight: 60.0,
                    elevation: 0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return Visibility(
                            visible: scrollController.position.pixels > threshold,
                            child: _libraryAppBar()
                        );
                      },
                    ),
                    actions: [
                      PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.primary,),
                          onSelected: (value) => Navigator.pushNamed(context, '/$value'),
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'settings',
                              child: Text('Settings'),
                            ),
                          ]
                      )
                    ],
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate(
                          [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: _libraryHeader(),
                            ),
                            state.userSubscription != 0 ?
                                _subscribedLayout()
                                :
                                _unsubscribedLayout()
                          ]
                      )
                  ),
                ],
              );
            }

            else if (state.status.isError) {
              return Center(
                child: Text('Failed to fetch data: ${state.errorMsg}'),
              );
            }

            return Text('$state');
          },
        );
  }

  Widget _libraryAppBar() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1.0),
          )
      ),
      child: FlexibleSpaceBar(
          titlePadding: const EdgeInsets.all(8.0),
          title: Text(
            'Library',
            style: TextStyle(
                fontSize: AppConfig.mediumText,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white
            ),
          )
      ),
    );
  }

  Widget _libraryHeader() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: const Text('Library', style: TextStyle(fontSize: AppConfig.bigText, fontWeight: FontWeight.bold)),
    );
  }

  Widget _subscribedLayout() {
    return Container();
  }

  Widget _unsubscribedLayout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Your music everywhere.', textAlign: TextAlign.start,
              style: TextStyle(fontSize: AppConfig.mediumText, fontWeight: FontWeight.bold)),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Listen to your library across your devices, including music you add to iTunes and millions of songs on Apple Music.', textAlign: TextAlign.start),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _subscribeButton(),
        )
      ],
    );
  }

  Widget _subscribeButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.only(bottom: 8, top: 8),
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
              )
          ),
          onPressed: () => print('hello'),
          child: const Text('Try it Now')),
    );
  }

}
