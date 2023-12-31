import 'package:apple_music_clone/model/album.dart';
import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/model/track.dart';
import 'package:apple_music_clone/ui/home_page/tabs/radio_tab/bloc/radio_bloc.dart';
import 'package:apple_music_clone/ui/home_page/widgets/list_carousel.dart';
import 'package:apple_music_clone/ui/home_page/widgets/standard_carousel.dart';
import 'package:apple_music_clone/ui/home_page/widgets/square_carousel.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RadioTab extends StatefulWidget {
  const RadioTab({Key? key}) : super(key: key);

  @override
  State<RadioTab> createState() => _RadioTabState();
}

class _RadioTabState extends State<RadioTab> with AutomaticKeepAliveClientMixin{
  final ScrollController _scrollController = ScrollController();
  bool _showTitleOnAppBar = false;
  double _offsetNeeded = 120.0;

  void _handleScroll() {
    if (_showTitleOnAppBar != (_scrollController.offset > _offsetNeeded)) {
      setState(() {
        _showTitleOnAppBar = !_showTitleOnAppBar;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<RadioBloc>(context).add(GetUserSubscription());
    BlocProvider.of<RadioBloc>(context).add(GetLatestAlbumsArtists());
    BlocProvider.of<RadioBloc>(context).add(GetFeaturedPlaylists());
    _scrollController.addListener(_handleScroll);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<RadioBloc, RadioState>(
          builder: (context, state) {
            if (state.status.isLoading || state.status.isInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            else if (state.status.isSuccess) {
              if (state.userSubscription != 0) {
                _offsetNeeded -= 60.0;
              }
              return CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverAppBar(
                    foregroundColor: Theme.of(context).colorScheme.primary,

                    elevation: 0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: Visibility(
                        visible: _showTitleOnAppBar,
                        child: _disappearingAppBar()
                    ),
                    actions: [
                      PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
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
                            state.userSubscription == 0? _subscribeButton(): Container(),
                            _headerBeforeScroll(),
                            _globalFeaturedRadioSection(state.featuredGlobalPlaylists),
                            _globalLatestReleasesSection(state.latestGlobalAlbums),
                            _localBroadcastersSection(state.latestLocalAlbums),
                            _localLatestReleasesSection(state.featuredLocalPlaylists),
                            _globalBroadcastersSection(context, state.recommendedTracks)
                          ]
                      )
                  ),
                ],
              );
            }

            else if (state.status.isError) {
              if (state.errorMsg.contains('Failed host lookup')){
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("You're Offline\n", style: TextStyle(fontWeight: FontWeight.bold),),
                    Text("Turn off Aeroplane Mode or connect to Wi-Fi", style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
                  ],
                );
              }

              return Center(
                child: Text('Failed to fetch data: ${state.errorMsg}'),
              );
            }

            return Text('$state');
          },
        );
  }

  Widget _globalFeaturedRadioSection(List<Playlist> featuredPlaylists) {
    return SquareCarousel(
      headerButtonTitle: 'Featured Radio',
      dataList: featuredPlaylists,
      trailingWidget: IconButton(
        color: Theme.of(context).colorScheme.primary,
        icon: const Icon(Icons.calendar_month_rounded),
        onPressed: ()=> print('hello'),
      ),
    );
  }

  Widget _globalLatestReleasesSection(List<Album> latestReleaseAlbums) {
    return SquareCarousel(
      headerButtonTitle: 'Loved Everywhere',
      dataList: latestReleaseAlbums
    );
  }

  Widget _localBroadcastersSection(List<Album> latestReleaseAlbums) {
    return SquareCarousel(
      headerButtonTitle: 'Local Broadcasters',
      dataList: latestReleaseAlbums
    );
  }

  Widget _localLatestReleasesSection(List<Playlist> featuredPlaylists) {
    return StandardCarousel(
        headerButtonTitle: 'Loved Locally',
        noOfRowsPerPage: 1,
        dataList: featuredPlaylists
    );
  }

  Widget _globalBroadcastersSection(BuildContext context, List<Track> tracks){
    return ListCarousel(
      headerButtonTitle: 'International Broadcasters',
      dataList: tracks,
      noOfRowsPerPage: 3,
      imgSize: 100,
      listTileSize: MediaQuery.of(context).size.height * 0.15
    );
  }

  Widget _disappearingAppBar(){
    return Container(
      decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1.0),
          )
      ),
      child: FlexibleSpaceBar(
          titlePadding: const EdgeInsets.all(8.0),
          title: Text(
            'Radio',
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

  Widget _subscribeButton() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
                colors: [Colors.deepPurpleAccent, Colors.blueAccent])),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(bottom: 8, top: 8),
                foregroundColor: Colors.white,
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent),
            onPressed: () => print('hello'),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Icon(Icons.apple), Text('Music')],
                ),
                const Text('Try it Now')
              ],
            )),
      ),
    );
  }

  Widget _headerBeforeScroll(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1.0))),
        child: const Text('Radio', style: TextStyle(fontSize: AppConfig.bigText, fontWeight: FontWeight.bold)),
      ),
    );
  }

}
