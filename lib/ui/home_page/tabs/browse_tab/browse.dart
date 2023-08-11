import 'package:apple_music_clone/model/album.dart';
import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/model/category.dart';
import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/model/track.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/category_details/bloc/category_bloc.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/category_details/category_details_page.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/expanded_categories_page.dart';
import 'package:apple_music_clone/ui/home_page/tabs/browse_tab/bloc/browse_bloc.dart';
import 'package:apple_music_clone/ui/home_page/widgets/circular_carousel.dart';
import 'package:apple_music_clone/ui/home_page/widgets/list_carousel.dart';
import 'package:apple_music_clone/ui/home_page/widgets/standard_carousel.dart';
import 'package:apple_music_clone/ui/home_page/widgets/narrow_carousel.dart';
import 'package:apple_music_clone/ui/home_page/widgets/square_carousel.dart';
import 'package:apple_music_clone/ui/home_page/widgets/text_list_item.dart';
import 'package:apple_music_clone/ui/home_page/widgets/wide_carousel.dart';
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
    return BlocBuilder<BrowseBloc, BrowseState>(
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
                          _globalFeaturedPlaylistsSection(state.featuredGlobalPlaylists),
                          ..._localCategoriesPlaylistsSection(state.categoriesLocal, state.categoriesLocalPlaylists),
                          _localFeaturedPlaylistsSection(state.featuredLocalPlaylists),
                          ..._globalCategoriesPlaylistsSection(state.categoriesGlobal, state.categoriesGlobalPlaylists),
                          _featuredCategoriesSection([...state.categoriesGlobal, ...state.categoriesLocal], [...state.categoriesGlobalPlaylists, ...state.categoriesLocalPlaylists]),
                          _recommendedTracks(context, state.recommendedTracks),
                          _globalLatestReleasesSection(state.latestGlobalAlbums),
                          _localLatestReleasesSection(state.latestLocalAlbums),
                          _featuredArtistsSection([...state.artistsGlobal, ...state.artistsLocal]),
                          _browseCategoriesSection([...state.categoriesGlobal, ...state.categoriesLocal], [...state.categoriesGlobalPlaylists, ...state.categoriesLocalPlaylists])
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

  Widget _globalFeaturedPlaylistsSection(List<Playlist> featuredPlaylists) {
    return WideCarousel(
        dataList: featuredPlaylists
    );
  }

  Widget _globalLatestReleasesSection(List<Album> latestReleaseAlbums) {
    return StandardCarousel(
        headerButtonTitle: 'Latest Hits',
        noOfRowsPerPage: 2,
        dataList: latestReleaseAlbums
    );
  }

  Widget _localLatestReleasesSection(List<Album> latestReleaseAlbums) {
    return StandardCarousel(
        headerButtonTitle: 'Latest Local Hits',
        noOfRowsPerPage: 1,
        dataList: latestReleaseAlbums
    );
  }

  Widget _localFeaturedPlaylistsSection(List<Playlist> featuredPlaylists) {
    return SquareCarousel(
      headerButtonTitle: 'Featured Playlists',
      dataList: featuredPlaylists
    );
  }

  List<Widget> _globalCategoriesPlaylistsSection(List<Category> categories, List<List<Playlist>> categoriesPlaylists) {
    List<Widget> playlistsWidgets = [
      for (int i=0; i<3; i++)
        StandardCarousel(
          headerButtonTitle: categories[i].name,
          noOfRowsPerPage: 2,
          dataList: categoriesPlaylists[i],
        )
    ];
    return playlistsWidgets;
  }

  List<Widget> _localCategoriesPlaylistsSection(List<Category> categories, List<List<Playlist>> categoriesPlaylists) {
    List<Widget> playlistsWidgets = [
      for (int i=0; i<3; i++)
        StandardCarousel(
          headerButtonTitle: categories[i].name,
          noOfRowsPerPage: 1,
          dataList: categoriesPlaylists[i],
        )
    ];
    return playlistsWidgets;
  }

  Widget _featuredCategoriesSection(List<Category> categories, List<List<Playlist>> categoriesPlaylists){
    return NarrowCarousel(
        headerTitle: 'Browse by Category',
        dataList: categories,
        detailsDataList: categoriesPlaylists
    );
  }

  Widget _recommendedTracks(BuildContext context, List<Track> tracks){
    return ListCarousel(
        headerButtonTitle: 'Best New Songs',
        dataList: tracks,
        noOfRowsPerPage: 4,
        imgSize: 40,
        listTileSize: MediaQuery.of(context).size.height * 0.1
    );
  }

  Widget _featuredArtistsSection(List <Artist> artists) {
    return CircularCarousel(
        headerButtonTitle: 'Artists We Love',
        dataList: artists
    );
  }

  Widget _browseCategoriesSection (List <Category> categories, List<List<Playlist>> categoriesPlaylists){
    List <Category> topCategories = categories.sublist(0, 5);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
      child: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
            TextListItem(
                title: 'Browse by Category',
                detailsPage: CategoriesExpandedPage(
                    categoriesPlaylists: categoriesPlaylists,
                    categories: categories)
            ),
            ...[
              for (int i = 0; i < topCategories.length; i++)
                TextListItem(
                    title: topCategories[i].name,
                    detailsPage: BlocProvider<CategoryBloc>(
                        create: (context) => CategoryBloc(),
                        child: CategoryDetailsPage(
                            title: topCategories[i].name,
                            dataList: categoriesPlaylists[i])
                    )
                )
            ]
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
            style: TextStyle(fontSize: AppConfig.mediumText),
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
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                )
            ),
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
