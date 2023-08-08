import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/model/track.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/category_details/bloc/category_bloc.dart';
import 'package:apple_music_clone/ui/home_page/widgets/circular_carousel.dart';
import 'package:apple_music_clone/ui/home_page/widgets/list_carousel.dart';
import 'package:apple_music_clone/ui/home_page/widgets/standard_carousel.dart';
import 'package:apple_music_clone/ui/home_page/widgets/square_carousel.dart';
import 'package:apple_music_clone/ui/home_page/widgets/wide_carousel.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CategoryDetailsPage extends StatefulWidget {
  const CategoryDetailsPage({Key? key, required this.dataList, required this.title}) : super(key: key);
  final String title;
  final List<Playlist> dataList;

  @override
  State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showTitleOnAppBar = false;
  final double _offsetNeeded = 60.0;

  void _handleScroll() {
    if (_showTitleOnAppBar != (_scrollController.offset > _offsetNeeded)) {
      setState(() {
        _showTitleOnAppBar = !_showTitleOnAppBar;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CategoryBloc>(context).add(GetTracksAndArtists([for(Playlist p in widget.dataList) p.id]));
    _scrollController.addListener(_handleScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state.categoryStatus.isLoading || state.categoryStatus.isInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            else if (state.categoryStatus.isSuccess){
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
                        child: _disappearingAppBar(widget.title)
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
                            _headerBeforeScroll(widget.title),
                            _globalFeaturedPlaylistsSection(context, widget.dataList),
                            _globalLatestReleasesSection(context, widget.dataList),
                            _localLatestReleasesSection(context, widget.dataList),
                            _localFeaturedPlaylistsSection(context, widget.dataList),
                            _recommendedTracks(context, state.tracks),
                            _featuredArtistsSection(state.artists)
                          ]
                      )
                  ),
                ],
              );
            }

            else {
              return Text('$state');
            }
          }
        ),
    );
  }

  Widget _globalFeaturedPlaylistsSection(BuildContext context, List<Playlist> playlists) {
    return WideCarousel(
        dataList: playlists
    );
  }

  Widget _globalLatestReleasesSection(BuildContext context, List<Playlist> playlists) {
    return StandardCarousel(
        headerButtonTitle: 'Latest Hits',
        noOfRows: 2,
        dataList: playlists
    );
  }

  Widget _localLatestReleasesSection(BuildContext context, List<Playlist> playlists) {
    return StandardCarousel(
        headerButtonTitle: 'Latest Local Hits',
        noOfRows: 1,
        dataList: playlists
    );
  }

  Widget _localFeaturedPlaylistsSection(BuildContext context, List<Playlist> playlists) {
    return SquareCarousel(
      headerButtonTitle: 'Featured Playlists',
      dataList: playlists
    );
  }

  Widget _recommendedTracks(BuildContext context, List<Track> tracks){
    return ListCarousel(
        headerButtonTitle: 'Tracks',
        dataList: tracks,
        noOfRowsPerPage: 4,
        imgSize: 30,
        listTileSize: MediaQuery.of(context).size.height * 0.1,
    );
  }

  Widget _featuredArtistsSection(List <Artist> artists) {
    return CircularCarousel(
        headerButtonTitle: 'Artists',
        dataList: artists
    );
  }

  Widget _disappearingAppBar(String title){
    return Container(
      decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey, width: 1.0),
          )
      ),
      child: FlexibleSpaceBar(
          title: Text(
            title,
            style: const TextStyle(fontSize: AppConfig.mediumText, color: Colors.black),
          )
      ),
    );
  }

  Widget _headerBeforeScroll(String title){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.only(bottom: 10.0),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1.0))),
        child: Text(title, style: const TextStyle(fontSize: AppConfig.bigText, fontWeight: FontWeight.bold)),
      ),
    );
  }

}
