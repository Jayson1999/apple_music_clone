import 'package:apple_music_clone/ui/home_page/tabs/listennow_tab/bloc/listennow_bloc.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListenNowTab extends StatefulWidget {
  const ListenNowTab({Key? key}) : super(key: key);

  @override
  State<ListenNowTab> createState() => _ListenNowTabState();
}

class _ListenNowTabState extends State<ListenNowTab> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ListenNowBloc>(context).add(GetUserSubscription());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ListenNowBloc, ListenNowState>(
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
                            child: _listennowAppBar()
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
                              child: _listennowHeader(),
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

  Widget _listennowAppBar() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1.0),
          )
      ),
      child: FlexibleSpaceBar(
          titlePadding: const EdgeInsets.all(8.0),
          title: Text(
            'ListenNow',
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

  Widget _listennowHeader() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: const Text('Listen Now', style: TextStyle(fontSize: AppConfig.bigText, fontWeight: FontWeight.bold)),
    );
  }

  Widget _subscribedLayout() {
    return Container();
  }

  Widget _unsubscribedLayout() {
    return Card(
        color: Colors.pink,
        clipBehavior: Clip.hardEdge,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: InkWell(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(28.0),
                child: Text(
                  'Explore 100 million songs. All ad-free.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: AppConfig.bigText
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: Transform.scale(scale: 4.0, child: const Icon(Icons.apple, color: Colors.white)),
                    ),
                    const SizedBox(width: 30,),
                    const Text(
                      'Music',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 56
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Try It Now',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: AppConfig.smallText
                      ),
                    ),
                    Icon(Icons.arrow_circle_right_rounded, color: Colors.white,)
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 28.0),
                child: Text(
                  'Plan auto-renews for RM 16.90/month.',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: AppConfig.smallText
                  ),
                ),
              ),
            ],
          )
        )
    );
  }

}
