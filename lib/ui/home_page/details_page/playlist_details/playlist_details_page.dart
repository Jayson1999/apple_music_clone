import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/ui/home_page/details_page/playlist_details/bloc/playlist_bloc.dart';
import 'package:apple_music_clone/ui/home_page/widgets/singleTrackListTile.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class PlaylistDetails extends StatefulWidget {
  const PlaylistDetails({Key? key, required this.playlistId}) : super(key: key);

  final String playlistId;

  @override
  State<PlaylistDetails> createState() => _PlaylistDetailsState();
}

class _PlaylistDetailsState extends State<PlaylistDetails> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PlaylistBloc>(context).add(GetPlaylistDetails(widget.playlistId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PlaylistBloc, PlaylistState>(
        builder: (context, state){
          if (state.playlistStatus.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if (state.playlistStatus.isSuccess) {
            ScrollController scrollController = ScrollController();
            return CustomScrollView(
              controller: scrollController,
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.height*0.5,
                  elevation: 0,
                  floating: true,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: _appBarTitleContent(state.playlistDetails),
                    background: CachedNetworkImage(
                      imageUrl: state.playlistDetails?.images.last.url ?? 'playlistDetails is null',
                      fit: BoxFit.cover,
                    ),
                    collapseMode: CollapseMode.parallax,
                  ),
                  actions: [
                    PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.white,),
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
                          _tracksLayout(state.playlistDetails)
                        ]
                    )
                ),
              ],
            );
          }
          else {
            return Text('$state');
          }
        },
      )
    );
  }

  Widget _appBarTitleContent(Playlist? playlistDetails){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          playlistDetails?.name ?? 'playlistDetails is null',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: TextSizes.big, color: Colors.white),
        ),
        Text(playlistDetails?.type?? '', style: const TextStyle(fontSize: TextSizes.small, color: Colors.white),),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow, color: Colors.black,),
              onPressed: () => print('hello'),
              label: const Text('Play'),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                  )
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.shuffle, color: Colors.black,),
              onPressed: () => print('hello'),
              label: const Text('Shuffle'),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                  )
              ),
            ),
          ],
        ),
        Text(
          playlistDetails?.description ?? '',
          textAlign: TextAlign.justify,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: TextSizes.medium),
        )
      ],
    );
  }

  Widget _tracksLayout(Playlist? playlistDetails){
    return ListView.builder(
        itemCount: playlistDetails?.tracks.length ?? 0,
        itemBuilder: (context, index){
          final currentItem = playlistDetails?.tracks[index];
          if (currentItem == null){
            return const ListTile(
              leading: Icon(Icons.error, color: Colors.red,),
              title: Text('ERROR'),
              subtitle: Text('currentItem is null'),
            );
          }
          return singleTrack(currentItem, context);
          }
        );
  }
}
