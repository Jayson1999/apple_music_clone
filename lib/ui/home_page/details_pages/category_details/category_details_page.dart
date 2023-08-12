import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/model/track.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/category_details/bloc/category_bloc.dart';
import 'package:apple_music_clone/ui/home_page/widgets/bottom_sheet.dart';
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
    return BlocBuilder<CategoryBloc, CategoryState>(
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
                    foregroundColor: Theme.of(context).colorScheme.primary,

                    elevation: 0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: Visibility(
                        visible: _showTitleOnAppBar,
                        child: _disappearingAppBar(widget.title)
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.primary,),
                        onPressed: (){
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              isDismissible: true,
                              builder: (context){
                                return BottomSheetLayout(
                                    title: widget.title,
                                    subtitle: widget.dataList.first.type,
                                    imgUrl: widget.dataList.first.images.first.url,
                                    type: widget.dataList.first.type
                                );
                              });
                        },
                      )
                    ],
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate(
                          [
                            _headerBeforeScroll(widget.title),
                            _globalFeaturedPlaylistsSection(widget.dataList),
                            _globalLatestReleasesSection(widget.dataList),
                            _localLatestReleasesSection(widget.dataList),
                            _localFeaturedPlaylistsSection(widget.dataList),
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
        );
  }

  Widget _globalFeaturedPlaylistsSection(List<Playlist> playlists) {
    return WideCarousel(
        dataList: playlists
    );
  }

  Widget _globalLatestReleasesSection(List<Playlist> playlists) {
    return StandardCarousel(
        headerButtonTitle: 'Latest Hits',
        noOfRowsPerPage: 2,
        dataList: playlists
    );
  }

  Widget _localLatestReleasesSection(List<Playlist> playlists) {
    return StandardCarousel(
        headerButtonTitle: 'Latest Local Hits',
        noOfRowsPerPage: 1,
        dataList: playlists
    );
  }

  Widget _localFeaturedPlaylistsSection(List<Playlist> playlists) {
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
        imgSize: 40,
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
      decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1.0),
          )
      ),
      child: FlexibleSpaceBar(
          title: Text(
            title,
            style: const TextStyle(fontSize: AppConfig.mediumText),
          )
      ),
    );
  }

  Widget _headerBeforeScroll(String title){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1.0))),
        child: Text(title, style: const TextStyle(fontSize: AppConfig.bigText, fontWeight: FontWeight.bold)),
      ),
    );
  }

}
