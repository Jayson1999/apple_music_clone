import 'package:apple_music_clone/model/album.dart';
import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/model/track.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/artist_details/bloc/artist_bloc.dart';
import 'package:apple_music_clone/ui/home_page/widgets/circular_carousel.dart';
import 'package:apple_music_clone/ui/home_page/widgets/common_grid_item.dart';
import 'package:apple_music_clone/ui/home_page/widgets/narrow_list_item.dart';
import 'package:apple_music_clone/ui/home_page/widgets/square_grid_item.dart';
import 'package:apple_music_clone/ui/home_page/widgets/wide_grid_item.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ArtistDetailsPage extends StatefulWidget {
  const ArtistDetailsPage({Key? key, required this.artist}) : super(key: key);
  final Artist artist;

  @override
  State<ArtistDetailsPage> createState() => _ArtistDetailsPageState();
}

class _ArtistDetailsPageState extends State<ArtistDetailsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ArtistBloc>(context).add(GetAlbums(widget.artist.id));
    BlocProvider.of<ArtistBloc>(context).add(GetTopTracks(widget.artist.id));
    BlocProvider.of<ArtistBloc>(context).add(GetRelatedArtists(widget.artist.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ArtistBloc, ArtistState>(
          builder: (context, state) {
            if (state.artistStatus.isLoading || state.artistStatus.isInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            else if (state.artistStatus.isSuccess){
              return CustomScrollView(
                controller: ScrollController(),
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.height*0.5,
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).primaryColor,
                    elevation: 0,
                    pinned: true,
                    floating: false,
                    flexibleSpace: LayoutBuilder(
                      builder: (context, constraints) {
                        bool showAppBarTitleOnly = constraints.maxHeight == kToolbarHeight + MediaQuery.of(context).padding.top;
                        return FlexibleSpaceBar(
                          centerTitle: true,
                          background: Visibility(
                              visible: !showAppBarTitleOnly,
                              child: _expandedAppBarContent(widget.artist)
                          ),
                          title: Visibility(
                            visible: showAppBarTitleOnly,
                            child: Text(
                              widget.artist.name,
                              style: const TextStyle(fontSize: AppConfig.bigText, color: Colors.black),
                            ),
                          ),
                        );
                      },
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
                            _latestAlbumsSection(context, state.albums),
                            _greatestHitsSection(context, state.albums),
                            _featuredAlbumsSection(context, state.albums),
                            _essentialAlbumsSection(context, state.albums),
                            _topTracksSection(context, state.topTracks),
                            _similarArtistsSection(state.relatedArtists)
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

  Widget _latestAlbumsSection(BuildContext context, List<Album> albums) {
    return wideGridItem(
        context,
        albums
    );
  }

  Widget _greatestHitsSection(BuildContext context, List<Album> albums) {
    return commonGridItem(
        context,
        'Greatest Hits',
        2,
        albums
    );
  }

  Widget _featuredAlbumsSection(BuildContext context, List<Album> albums) {
    return commonGridItem(
        context,
        'Featured Albums',
        1,
        albums
    );
  }

  Widget _essentialAlbumsSection(BuildContext context, List<Album> albums) {
    return squareGridItem(
      context,
      'Essential Albums',
      albums
    );
  }

  Widget _topTracksSection(BuildContext context, List<Track> tracks){
    return narrowListCardItem(
        context,
        'Top Tracks',
        tracks
    );
  }

  Widget _similarArtistsSection(List <Artist> artists) {
    return CircularCarousel(
        headerButtonTitle: 'Similar Artists',
        dataList: artists
    );
  }

  Widget _expandedAppBarContent(Artist artistDetails){
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: artistDetails.images.first.url,
          fit: BoxFit.cover,
        ),
        Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    artistDetails.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: AppConfig.bigText, color: Colors.white),
                  ),
                ],
              ),
            )
        ),
      ],
    );
  }

}
