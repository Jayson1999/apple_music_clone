import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/playlist_details/bloc/playlist_bloc.dart';
import 'package:apple_music_clone/ui/home_page/widgets/list_item.dart';
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
    return BlocBuilder<PlaylistBloc, PlaylistState>(
        builder: (context, state){
          if (state.playlistStatus.isLoading || state.playlistStatus.isInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if (state.playlistStatus.isSuccess) {
            return CustomScrollView(
              controller: ScrollController(),
              slivers: <Widget>[
                SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.height*0.5,

                    foregroundColor: Theme.of(context).colorScheme.primary,
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
                            child: _expandedAppBarContent(state.playlistDetails)
                          ),
                        title: Visibility(
                          visible: showAppBarTitleOnly,
                          child: Text(
                            state.playlistDetails?.name ?? 'playlistDetails is null',
                            style: const TextStyle(fontSize: AppConfig.bigText),
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
      );
  }

  Widget _expandedAppBarContent(Playlist? playlistDetails){
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: playlistDetails?.images.last.url ?? 'playlistDetails is null',
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
                    playlistDetails?.name ?? 'playlistDetails is null',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: AppConfig.bigText, color: Colors.white),
                  ),
                  Text(playlistDetails?.type?? '', style: const TextStyle(fontSize: AppConfig.smallText, color: Colors.white),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.play_arrow),
                            onPressed: () => print('hello'),
                            label: const Text('Play'),
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                foregroundColor: Theme.of(context).brightness == Brightness.light? Colors.black: Colors.white,
                                backgroundColor: Theme.of(context).brightness == Brightness.light? Colors.white: Colors.black
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.shuffle),
                            onPressed: () => print('hello'),
                            label: const Text('Shuffle'),
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                foregroundColor: Theme.of(context).brightness == Brightness.light? Colors.black: Colors.white,
                                backgroundColor: Theme.of(context).brightness == Brightness.light? Colors.white: Colors.black
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    playlistDetails?.description ?? '',
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: AppConfig.mediumText, color: Colors.white),
                  )
                ],
              ),
            )
        ),
      ],
    );
  }

  Widget _tracksLayout(Playlist? playlistDetails){
    return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: playlistDetails?.tracks.length ?? 0,
        itemBuilder: (context, index){
          final currentItem = playlistDetails?.tracks[index];
          if (currentItem == null){
            return ListTile(
              leading: Icon(Icons.error, color: Theme.of(context).colorScheme.primary),
              title: const Text('ERROR'),
              subtitle: const Text('currentItem is null'),
            );
          }
          return ListItem(
              title: currentItem.name,
              subtitle: '${currentItem.type} . ${[for (Artist a in currentItem.artists) a.name].join(',')}',
              listTileSize: MediaQuery.of(context).size.height * 0.1,
              imgSize: 40,
              imgUrl: currentItem.album?.images.first.url ?? '',
              showBtmBorder: false,
              trailingWidget: PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.primary,),
                  onSelected: (value) => print('hello'),
                  itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'settings',
                      child: Text('Settings'),
                    ),
                  ]
              ),
            );
          }
        );
  }
}
