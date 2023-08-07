import 'package:apple_music_clone/model/album.dart';
import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/model/category.dart';
import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/model/track.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/category_details/bloc/category_bloc.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/category_details/category_details_page.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/expanded_categories_page.dart';
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

class _BrowseTabState extends State<BrowseTab> with AutomaticKeepAliveClientMixin{
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
    BlocProvider.of<BrowseBloc>(context).add(GetUserSubscription());
    BlocProvider.of<BrowseBloc>(context).add(GetLatestAlbumsArtists());
    BlocProvider.of<BrowseBloc>(context).add(GetFeaturedPlaylists());
    BlocProvider.of<BrowseBloc>(context).add(GetCategoriesPlaylists());
    _scrollController.addListener(_handleScroll);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      theme: AppConfig.getAppTheme(),
      home: Scaffold(
        body: BlocBuilder<BrowseBloc, BrowseState>(
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
                      foregroundColor: Theme.of(context).primaryColor,
                      backgroundColor: Colors.white,
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
                          _globalFeaturedPlaylistsSection(context, state.featuredGlobalPlaylists),
                          _globalLatestReleasesSection(context, state.latestGlobalAlbums),
                          _localLatestReleasesSection(context, state.latestLocalAlbums),
                          _localFeaturedPlaylistsSection(context, state.featuredLocalPlaylists),
                          ..._globalCategoriesPlaylistsSection(context, state.categoriesGlobal, state.categoriesGlobalPlaylists),
                          _featuredCategoriesSection(context, [...state.categoriesGlobal, ...state.categoriesLocal], [...state.categoriesGlobalPlaylists, ...state.categoriesLocalPlaylists]),
                          _recommendedTracks(context, state.recommendedTracks),
                          ..._localCategoriesPlaylistsSection(context, state.categoriesLocal, state.categoriesLocalPlaylists),
                          _featuredArtistsSection(context, [...state.artistsGlobal, ...state.artistsLocal]),
                          _browseCategoriesSection(context, [...state.categoriesGlobal, ...state.categoriesLocal], [...state.categoriesGlobalPlaylists, ...state.categoriesLocalPlaylists])
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

  Widget _globalFeaturedPlaylistsSection(BuildContext context, List<Playlist> featuredPlaylists) {
    return wideGridItem(
        context,
        featuredPlaylists
    );
  }

  Widget _globalLatestReleasesSection(BuildContext context, List<Album> latestReleaseAlbums) {
    return commonGridItem(
        context,
        'Latest Hits',
        2,
        latestReleaseAlbums
    );
  }

  Widget _localLatestReleasesSection(BuildContext context, List<Album> latestReleaseAlbums) {
    return commonGridItem(
        context,
        'Latest Local Hits',
        1,
        latestReleaseAlbums
    );
  }

  Widget _localFeaturedPlaylistsSection(BuildContext context, List<Playlist> featuredPlaylists) {
    return squareGridItem(
      context,
      'Featured Playlists',
      featuredPlaylists
    );
  }

  List<Widget> _globalCategoriesPlaylistsSection(BuildContext context, List<Category> categories, List<List<Playlist>> categoriesPlaylists) {
    List<Widget> playlistsWidgets = [
      for (int i=0; i<3; i++)
        commonGridItem(
          context,
          categories[i].name,
          2,
          categoriesPlaylists[i],
        )
    ];
    return playlistsWidgets;
  }

  List<Widget> _localCategoriesPlaylistsSection(BuildContext context, List<Category> categories, List<List<Playlist>> categoriesPlaylists) {
    List<Widget> playlistsWidgets = [
      for (int i=0; i<3; i++)
        commonGridItem(
          context,
          categories[i].name,
          1,
          categoriesPlaylists[i],
        )
    ];
    return playlistsWidgets;
  }

  Widget _featuredCategoriesSection(BuildContext context, List<Category> categories, List<List<Playlist>> categoriesPlaylists){
    return narrowGridItem(
        context,
        'Browse by Category',
        categories,
        categoriesPlaylists
    );
  }

  Widget _recommendedTracks(BuildContext context, List<Track> tracks){
    return narrowListCardItem(
      context,
      'Best New Songs',
      tracks
    );
  }

  Widget _featuredArtistsSection(BuildContext context, List <Artist> artists) {
    return circularItem(
        context,
        'Artists We Love',
        artists
    );
  }

  Widget _browseCategoriesSection (BuildContext context, List <Category> categories, List<List<Playlist>> categoriesPlaylists){
    Widget categoryItem(String title, List<Playlist> dataList) {
      var detailsPage = BlocProvider<CategoryBloc>(
          create: (context) => CategoryBloc(),
          child: CategoryDetailsPage(title: title, dataList: dataList)
      );
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
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => detailsPage
                ),
              ),
              child: Text(title, style: const TextStyle(color: Colors.red, fontSize: AppConfig.mediumText))
          )
      );
    }

    List <Category> top5Categories = categories.sublist(0, 5);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.45,
      child: Column(
        children: [
          Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey, width: 0.5),
                  )),
              child: TextButton(
                  style: TextButton.styleFrom(
                      alignment: Alignment.centerLeft
                  ),
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoriesExpandedPage(
                                categoriesPlaylists: categoriesPlaylists, categories: categories)
                        ),
                      ),
                  child: const Text('Browse by Category', style: TextStyle(color: Colors.red, fontSize: AppConfig.mediumText))
              )
          ),
          ...[for (int i=0; i<top5Categories.length; i++) categoryItem(top5Categories[i].name, categoriesPlaylists[i])]
        ],
      ),
    );
  }

  Widget _disappearingAppBar(){
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
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1.0))),
        child: const Text('Browse', style: TextStyle(fontSize: AppConfig.bigText, fontWeight: FontWeight.bold)),
      ),
    );
  }

}
