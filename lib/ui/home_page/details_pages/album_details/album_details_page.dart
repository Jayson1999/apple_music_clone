import 'package:apple_music_clone/model/album.dart';
import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/album_details/bloc/album_bloc.dart';
import 'package:apple_music_clone/ui/home_page/widgets/bottom_sheet.dart';
import 'package:apple_music_clone/ui/home_page/widgets/list_item.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AlbumDetails extends StatefulWidget {
  const AlbumDetails({Key? key, required this.albumId}) : super(key: key);

  final String albumId;

  @override
  State<AlbumDetails> createState() => _AlbumDetailsState();
}

class _AlbumDetailsState extends State<AlbumDetails> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AlbumBloc>(context).add(GetAlbumDetails(widget.albumId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumBloc, AlbumState>(
          builder: (context, state){
            if (state.albumStatus.isLoading || state.albumStatus.isInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            else if (state.albumStatus.isSuccess) {
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
                              child: _expandedAppBarContent(state.albumDetails)
                          ),
                          title: Visibility(
                            visible: showAppBarTitleOnly,
                            child: Text(
                              state.albumDetails?.name ?? 'albumDetails is null',
                              style: const TextStyle(fontSize: AppConfig.bigText),
                            ),
                          ),
                        );
                      },
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: (){
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              isDismissible: true,
                              builder: (context){
                            return BottomSheetLayout(
                                title: state.albumDetails?.name ??
                                    'albumDetails is null',
                                subtitle: state.albumDetails?.releaseDate ?? '',
                                imgUrl: state.albumDetails?.images.first.url ?? AppConfig.placeholderImgUrl,
                                type: 'album'
                            );
                          });
                        },
                      )
                    ],
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate(
                          [
                            _tracksLayout(state.albumDetails)
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

  Widget _expandedAppBarContent(Album? albumDetails){
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: albumDetails?.images.first.url ?? 'albumDetails is null',
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
                    albumDetails?.name ?? 'albumDetails is null',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: AppConfig.bigText, color: Colors.white),
                  ),
                  Text(albumDetails?.type?? '', style: const TextStyle(fontSize: AppConfig.smallText, color: Colors.white),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
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
                      ElevatedButton.icon(
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
                    ],
                  ),
                  Text(
                    albumDetails?.releaseDate ?? '',
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

  Widget _tracksLayout(Album? albumDetails){
    return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: albumDetails?.tracks.length ?? 0,
        itemBuilder: (context, index){
          final currentItem = albumDetails?.tracks[index];
          if (currentItem == null){
            return ListTile(
              leading: Icon(Icons.error, color: Theme.of(context).colorScheme.primary,),
              title: const Text('ERROR'),
              subtitle: const Text('currentItem is null'),
            );
          }
          String title = currentItem.name;
          String subtitle = '${currentItem.type} . ${[for (Artist a in currentItem.artists) a.name].join(',')}';
          String imgUrl = currentItem.album?.images.first.url ?? AppConfig.placeholderImgUrl;
          return ListItem(
              title: title,
              subtitle: subtitle,
              listTileSize: MediaQuery.of(context).size.height * 0.1,
              imgSize: 40,
              imgUrl: imgUrl,
              showBtmBorder: false,
              trailingWidget: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: (){
                  showBottomSheet(context: context, builder: (context){
                    return BottomSheetLayout(title: title, subtitle: subtitle, imgUrl: imgUrl, type: 'song');
                  });
                },
              )
          );
        }
    );
  }
}
