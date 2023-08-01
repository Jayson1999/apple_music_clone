import 'package:apple_music_clone/model/album.dart';
import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/model/category.dart';
import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/model/track.dart';
import 'package:apple_music_clone/ui/home_page/tabs/browse_tab/bloc/browse_bloc.dart';
import 'package:apple_music_clone/ui/home_page/widgets/circular_item.dart';
import 'package:apple_music_clone/ui/home_page/widgets/common_grid_item.dart';
import 'package:apple_music_clone/ui/home_page/widgets/narrow_grid_item.dart';
import 'package:apple_music_clone/ui/home_page/widgets/narrow_list_item.dart';
import 'package:apple_music_clone/ui/home_page/widgets/square_grid_item.dart';
import 'package:apple_music_clone/ui/home_page/widgets/wide_grid_item.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class BrowseTab extends StatefulWidget {
  const BrowseTab({Key? key}) : super(key: key);

  @override
  State<BrowseTab> createState() => _BrowseTabState();
}

class _BrowseTabState extends State<BrowseTab> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BrowseBloc>(context).add(GetUserSubscription());
    BlocProvider.of<BrowseBloc>(context).add(GetLatestAlbumsArtists());
    BlocProvider.of<BrowseBloc>(context).add(GetFeaturedPlaylists());
    BlocProvider.of<BrowseBloc>(context).add(GetCategoriesPlaylists());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BrowseBloc, BrowseState>(
          builder: (context, state) {
            if (state.status.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            else if (state.status.isSuccess) {
              ScrollController scrollController = ScrollController();
              const double expandedHeight = 80.0;
              double threshold = state.userSubscription != 0? 30.0: 40.0;

              return CustomScrollView(
                controller: scrollController,
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    expandedHeight: expandedHeight,
                    elevation: 0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return Visibility(
                          visible: scrollController.position.pixels > threshold,
                          child: _browseAppBar()
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
                          child: _browseHeader(),
                        ),
                        _globalFeaturedPlaylistsSection(state.featuredGlobalPlaylists),
                        _globalLatestReleasesSection(state.latestGlobalAlbums),
                        _localLatestReleasesSection(state.latestLocalAlbums),
                        _localFeaturedPlaylistsSection(state.featuredLocalPlaylists),
                        ..._globalCategoriesPlaylistsSection(state.categoriesGlobal, state.categoriesGlobalPlaylists),
                        _featuredCategoriesSection([...state.categoriesGlobal, ...state.categoriesLocal]),
                        _recommendedTracks(state.recommendedTracks),
                        ..._localCategoriesPlaylistsSection(state.categoriesLocal, state.categoriesLocalPlaylists),
                        _featuredArtistsSection([...state.artistsGlobal, ...state.artistsLocal]),
                        _browseCategoriesSection([...state.categoriesGlobal, ...state.categoriesLocal])
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
    );
  }

  Widget _globalFeaturedPlaylistsSection(List<Playlist> featuredPlaylists) {
    return wideGridItem(
        context,
        [for (Playlist playlist in featuredPlaylists) playlist.name],
        [for (Playlist playlist in featuredPlaylists) playlist.description.split(' ').first],
        [for (Playlist playlist in featuredPlaylists) playlist.type],
        [for (Playlist playlist in featuredPlaylists) playlist.images[0].url],
        [for (Playlist playlist in featuredPlaylists) playlist.description]
    );
  }

  Widget _globalLatestReleasesSection(List<Album> latestReleaseAlbums) {
    return commonGridItem(
        context,
        'Latest Hits',
        2,
        [for (Album album in latestReleaseAlbums) album.name],
        [for (Album album in latestReleaseAlbums) [for (Artist artist in album.artists) artist.name].join(', ')],
        [for (Album album in latestReleaseAlbums) album.images[0].url]
    );
  }

  Widget _localLatestReleasesSection(List<Album> latestReleaseAlbums) {
    return commonGridItem(
        context,
        'Latest Local Hits',
        1,
        [for (Album album in latestReleaseAlbums) album.name],
        [for (Album album in latestReleaseAlbums) [for (Artist artist in album.artists) artist.name].join(', ')],
        [for (Album album in latestReleaseAlbums) album.images[0].url]
    );
  }

  Widget _localFeaturedPlaylistsSection(List<Playlist> featuredPlaylists) {
    return squareGridItem(
      context,
      'Featured Playlists',
      [for (Playlist playlist in featuredPlaylists) playlist.name],
      [for (Playlist playlist in featuredPlaylists) playlist.description],
      [for (Playlist playlist in featuredPlaylists) playlist.images[0].url],
    );
  }

  List<Widget> _globalCategoriesPlaylistsSection(List<Category> categories, List<List<Playlist>> categoriesPlaylists) {
    List<Widget> playlistsWidgets = [
      for (int i=0; i<3; i++)
        commonGridItem(
          context,
          categories[i].name,
          2,
          [for (Playlist playlist in categoriesPlaylists[i]) playlist.name],
          [for (Playlist playlist in categoriesPlaylists[i]) playlist.description],
          [for (Playlist playlist in categoriesPlaylists[i]) playlist.images[0].url],
        )
    ];
    return playlistsWidgets;
  }

  List<Widget> _localCategoriesPlaylistsSection(List<Category> categories, List<List<Playlist>> categoriesPlaylists) {
    List<Widget> playlistsWidgets = [
      for (int i=0; i<3; i++)
        commonGridItem(
          context,
          categories[i].name,
          1,
          [for (Playlist playlist in categoriesPlaylists[i]) playlist.name],
          [for (Playlist playlist in categoriesPlaylists[i]) playlist.description],
          [for (Playlist playlist in categoriesPlaylists[i]) playlist.images[0].url],
        )
    ];
    return playlistsWidgets;
  }

  Widget _featuredCategoriesSection(List<Category> categories){
    return narrowGridItem(
        context,
        'Browse by Category',
        [for (Category category in categories) category.name],
        [for (Category category in categories) category.categoryIconsInfo[0].url],
    );
  }

  Widget _recommendedTracks(List<Track> tracks){
    return narrowListCardItem(
      context,
      'Best New Songs',
      [for (Track track in tracks) track.name],
      [for (Track track in tracks) [for (Artist artist in track.artists) artist.name].join(', ')],
      [for (Track track in tracks) '${track.album?.images[0].url}'
      ],
    );
  }

  Widget _featuredArtistsSection(List <Artist> artists) {
    return circularItem(
        context,
        'Artists We Love',
        [for (Artist artist in artists) artist.name],
        [for (Artist artist in artists) artist.images[0].url]
    );
  }

  Widget _browseCategoriesSection (List <Category> categories){
    Widget listItem(String title) {
      return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey, width: 0.5),
              )),
          child: TextButton(
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft
              ),
              onPressed: () => print('hello'),
              child: Text(title, style: const TextStyle(color: Colors.red, fontSize: TextSizes.medium))
          )
      );
    }

    List <Category> top5Categories = categories.sublist(0, 5);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.45,
      child: Column(
        children: [
          listItem('Browse by Category'),
          ...[for (Category category in top5Categories) listItem(category.name)]
        ],
      ),
    );
  }

  Widget _browseAppBar() {
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
            style: TextStyle(fontSize: TextSizes.medium, color: Colors.black),
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

  Widget _browseHeader() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1.0))),
      child: const Text('Browse', style: TextStyle(fontSize: TextSizes.big, fontWeight: FontWeight.bold)),
    );
  }

}
