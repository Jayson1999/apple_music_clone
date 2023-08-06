import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/model/track.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/category_details/bloc/category_bloc.dart';
import 'package:apple_music_clone/ui/home_page/widgets/circular_item.dart';
import 'package:apple_music_clone/ui/home_page/widgets/common_grid_item.dart';
import 'package:apple_music_clone/ui/home_page/widgets/narrow_list_item.dart';
import 'package:apple_music_clone/ui/home_page/widgets/square_grid_item.dart';
import 'package:apple_music_clone/ui/home_page/widgets/wide_grid_item.dart';
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
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CategoryBloc>(context).add(GetTracksAndArtists([for(Playlist p in widget.dataList) p.id]));
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    double threshold = 25.0;
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
                            child: _categoryExpandedAppBar(widget.title)
                        );
                      },
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate(
                          [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: _categoryExpandedHeader(widget.title),
                            ),
                            _globalFeaturedPlaylistsSection(context, widget.dataList),
                            _globalLatestReleasesSection(context, widget.dataList),
                            _localLatestReleasesSection(context, widget.dataList),
                            _localFeaturedPlaylistsSection(context, widget.dataList),
                            _recommendedTracks(context, state.tracks),
                            _featuredArtistsSection(context, state.artists)
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
    return wideGridItem(
        context,
        [for (Playlist playlist in playlists) playlist.name],
        [for (Playlist playlist in playlists) playlist.description.split(' ').first],
        [for (Playlist playlist in playlists) playlist.type],
        [for (Playlist playlist in playlists) playlist.images.first.url],
        [for (Playlist playlist in playlists) playlist.description]
    );
  }

  Widget _globalLatestReleasesSection(BuildContext context, List<Playlist> playlists) {
    return commonGridItem(
        context,
        'Latest Hits',
        2,
        playlists
    );
  }

  Widget _localLatestReleasesSection(BuildContext context, List<Playlist> playlists) {
    return commonGridItem(
        context,
        'Latest Local Hits',
        1,
        playlists
    );
  }

  Widget _localFeaturedPlaylistsSection(BuildContext context, List<Playlist> playlists) {
    return squareGridItem(
      context,
      'Featured Playlists',
      [for (Playlist playlist in playlists) playlist.name],
      [for (Playlist playlist in playlists) playlist.description],
      [for (Playlist playlist in playlists) playlist.images.first.url],
    );
  }

  Widget _recommendedTracks(BuildContext context, List<Track> tracks){
    return narrowListCardItem(
        context,
        'Tracks',
        tracks
    );
  }

  Widget _featuredArtistsSection(BuildContext context, List <Artist> artists) {
    return circularItem(
        context,
        'Artists',
        artists
    );
  }

  Widget _categoryExpandedAppBar(String title) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey, width: 1.0),
          )
      ),
      child: FlexibleSpaceBar(
          titlePadding: const EdgeInsets.all(8.0),
          title: Text(
            title,
            style: const TextStyle(fontSize: AppConfig.mediumText, color: Colors.black),
          )
      ),
    );
  }

  Widget _categoryExpandedHeader(String title) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1.0))),
      child: Text(title, style: const TextStyle(fontSize: AppConfig.bigText, fontWeight: FontWeight.bold)),
    );
  }

}
