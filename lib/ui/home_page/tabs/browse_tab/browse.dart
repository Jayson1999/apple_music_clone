import 'package:apple_music_clone/model/album.dart';
import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/model/category.dart';
import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/ui/home_page/tabs/browse_tab/bloc/browse_bloc.dart';
import 'package:apple_music_clone/ui/home_page/widgets/common_grid_item.dart';
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
                        _globalLatestReleasesSection(state.latestGlobalAlbums),
                        _globalFeaturedPlaylistsSection(state.featuredGlobalPlaylists),
                        _localFeaturedPlaylistsSection(state.featuredLocalPlaylists),
                        _localLatestReleasesSection(state.latestLocalAlbums),
                        _globalCategoriesPlaylistsSection(state.categoriesGlobalPlaylists),
                        _localCategoriesPlaylistsSection(state.categoriesLocalPlaylists),
                        _featuredCategoriesSection([...state.categoriesGlobal, ...state.categoriesLocal]),
                        _featuredArtistsSection([...state.artistsGlobal, ...state.artistsLocal])
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

  Widget _globalLatestReleasesSection(List<Album> latestReleaseAlbums) {
    return wideGridItem(
        context,
        [for (Album album in latestReleaseAlbums) album.name],
        [for (Album album in latestReleaseAlbums) [for (Artist artist in album.artists) artist.name].join(', ')],
        [for (Album album in latestReleaseAlbums) album.releaseDate],
        [for (Album album in latestReleaseAlbums) album.images[0].url],
        [for (Album album in latestReleaseAlbums) album.label.isNotEmpty ? album.label: 'Released on ${album.releaseDate}. Number of tracks: ${album.totalTracks}']
    );
  }

  Widget _globalFeaturedPlaylistsSection(List<Playlist> featuredPlaylists) {
    return commonGridItem(
      context,
      'Featured Playlists',
      2,
      [for (Playlist playlist in featuredPlaylists) playlist.name],
      [for (Playlist playlist in featuredPlaylists) playlist.description],
      [for (Playlist playlist in featuredPlaylists) playlist.images[0].url],
    );
  }

  Widget _localFeaturedPlaylistsSection(List<Playlist> featuredPlaylists) {
    return Container(height: 50,);
  }

  Widget _localLatestReleasesSection(List<Album> latestReleaseAlbums) {
    return squareGridItem(
        context,
        'Latest Local Releases',
        [for (Album album in latestReleaseAlbums) album.name],
        [for (Album album in latestReleaseAlbums) [for (Artist artist in album.artists) artist.name].join(', ')],
        [for (Album album in latestReleaseAlbums) album.images[0].url],
    );
  }

  Widget _globalCategoriesPlaylistsSection(List<List<Playlist>> categoriesPlaylists) {
    return Container(height: 500,);
  }

  Widget _localCategoriesPlaylistsSection(List<List<Playlist>> categoriesPlaylists) {
    return Container(height: 500,);
  }

  Widget _featuredCategoriesSection(List<Category> categories){
    return Container(height: 500,);
  }

  Widget _featuredArtistsSection(List <Artist> artists) {
    return Container(height: 500,);
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
          borderRadius: BorderRadius.circular(4),
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
