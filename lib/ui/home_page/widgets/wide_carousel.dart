import 'package:apple_music_clone/ui/home_page/details_pages/album_details/album_details_page.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/album_details/bloc/album_bloc.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/playlist_details/bloc/playlist_bloc.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/playlist_details/playlist_details_page.dart';
import 'package:apple_music_clone/ui/home_page/widgets/wide_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class WideCarousel extends StatelessWidget {
  const WideCarousel({Key? key, required this.dataList}) : super(key: key);

  final List dataList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: PageView.builder(
          controller: PageController(viewportFraction: 0.9),
          scrollDirection: Axis.horizontal,
          itemCount: dataList.length,
          itemBuilder: (context, index) => _wideItemFromData(dataList[index])
      ),
    );
  }

  Widget _wideItemFromData(var dataItem){
    String description = '';
    String title = '';
    String subtitle = '';
    String imgUrl = '';
    String overlayText = '';
    Widget detailsPage = Container();

    switch (dataItem.type){
      case 'album':
        description = dataItem.type;
        title = dataItem.name;
        subtitle = dataItem.genres.join(',');
        imgUrl = dataItem.images.first.url;
        overlayText = '${dataItem.releaseDate}, ${dataItem.totalTracks}';
        detailsPage = BlocProvider<AlbumBloc>(
            create: (context) => AlbumBloc(),
            child: AlbumDetails(albumId: dataItem.id,)
        );
        break;
      case 'playlist':
        description = dataItem.type;
        title = dataItem.name;
        subtitle = dataItem.description.split(' ').first;
        imgUrl = dataItem.images.first.url;
        overlayText = dataItem.description;
        detailsPage = BlocProvider<PlaylistBloc>(
            create: (context) => PlaylistBloc(),
            child: PlaylistDetails(playlistId: dataItem.id,)
        );
        break;
    }

    return WideItem(description: description, title: title, subtitle: subtitle, imgUrl: imgUrl, overlayText: overlayText, detailsPage: detailsPage);
  }

}
