import 'package:apple_music_clone/model/album.dart';
import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/model/track.dart';
import 'package:apple_music_clone/ui/home_page/tabs/radio_tab/bloc/radio_bloc.dart';
import 'package:apple_music_clone/ui/home_page/widgets/common_grid_item.dart';
import 'package:apple_music_clone/ui/home_page/widgets/square_grid_item.dart';
import 'package:apple_music_clone/ui/home_page/widgets/wide_list_item.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RadioTab extends StatefulWidget {
  const RadioTab({Key? key}) : super(key: key);

  @override
  State<RadioTab> createState() => _RadioTabState();
}

class _RadioTabState extends State<RadioTab> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<RadioBloc>(context).add(GetUserSubscription());
    BlocProvider.of<RadioBloc>(context).add(GetLatestAlbumsArtists());
    BlocProvider.of<RadioBloc>(context).add(GetFeaturedPlaylists());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppConfig.getAppTheme(),
      home: Scaffold(
        body: BlocBuilder<RadioBloc, RadioState>(
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
                    backgroundColor: Colors.white,
                    expandedHeight: 60.0,
                    elevation: 0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return Visibility(
                            visible: scrollController.position.pixels > threshold,
                            child: _radioAppBar()
                        );
                      },
                    ),
                    actions: [
                      PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert, color: Theme.of(context).primaryColor,),
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
                            state.userSubscription == 0?
                            Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: _subscribeButton()
                            )
                                :
                            Container(),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: _radioHeader(),
                            ),
                            _globalFeaturedRadioSection(state.featuredGlobalPlaylists),
                            _globalLatestReleasesSection(state.latestGlobalAlbums),
                            _localBroadcastersSection(state.latestLocalAlbums),
                            _localLatestReleasesSection(state.featuredLocalPlaylists),
                            _globalBroadcastersSection(state.recommendedTracks)
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
        ),
      ),
    );
  }

  Widget _globalFeaturedRadioSection(List<Playlist> featuredPlaylists) {
    return squareGridItem(
      context,
      'Featured Radio',
      [for (Playlist playlist in featuredPlaylists) playlist.name],
      [for (Playlist playlist in featuredPlaylists) playlist.description],
      [for (Playlist playlist in featuredPlaylists) playlist.images[0].url],
      overlayTextList: [for (Playlist playlist in featuredPlaylists) playlist.description]
    );
  }

  Widget _globalLatestReleasesSection(List<Album> latestReleaseAlbums) {
    return squareGridItem(
      context,
      'Loved Everywhere',
      [for (Album album in latestReleaseAlbums) album.name],
      [for (Album album in latestReleaseAlbums) [for (Artist artist in album.artists) artist.name].join(', ')],
      [for (Album album in latestReleaseAlbums) album.images[0].url],
      overlayTextList: [for (Album album in latestReleaseAlbums) 'Started broadcasting on: ${album.releaseDate}. Every day & night']
    );
  }

  Widget _localBroadcastersSection(List<Album> latestReleaseAlbums) {
    return squareGridItem(
      context,
      'Local Broadcasters',
      [for (Album album in latestReleaseAlbums) album.name],
      [for (Album album in latestReleaseAlbums) [for (Artist artist in album.artists) artist.name].join(', ')],
      [for (Album album in latestReleaseAlbums) album.images[0].url],
      overlayTextList: [for (Album album in latestReleaseAlbums) 'Started broadcasting on: ${album.releaseDate}. Every day & night']
    );
  }

  Widget _localLatestReleasesSection(List<Playlist> featuredPlaylists) {
    return commonGridItem(
        context,
        'Loved Locally',
        1,
        featuredPlaylists
    );
  }

  Widget _globalBroadcastersSection(List<Track> tracks){
    return wideListCardItem(
      context,
      'International Broadcasters',
      [for (Track track in tracks) track.name],
      [for (Track track in tracks) [for (Artist artist in track.artists) artist.name].join(', ')],
      [for (Track track in tracks) '${track.album?.images[0].url}'
      ],
    );
  }

  Widget _radioAppBar() {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey, width: 1.0),
          )
      ),
      child: const FlexibleSpaceBar(
          titlePadding: EdgeInsets.all(8.0),
          title: Text(
            'Browse',
            style: TextStyle(fontSize: AppConfig.mediumText, color: Colors.black),
          )
      ),
    );
  }

  Widget _subscribeButton() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
              colors: [Colors.deepPurpleAccent, Colors.blueAccent])),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.only(bottom: 8, top: 8),
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
    );
  }

  Widget _radioHeader() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1.0))),
      child: const Text('Browse', style: TextStyle(fontSize: AppConfig.bigText, fontWeight: FontWeight.bold)),
    );
  }

}
