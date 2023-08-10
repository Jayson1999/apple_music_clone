import 'package:apple_music_clone/ui/home_page/details_pages/album_details/album_details_page.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/album_details/bloc/album_bloc.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/expanded_album_playlist_page.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/playlist_details/bloc/playlist_bloc.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/playlist_details/playlist_details_page.dart';
import 'package:apple_music_clone/ui/home_page/widgets/square_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SquareCarousel extends StatelessWidget {
  const SquareCarousel({Key? key, required this.headerButtonTitle, required this.dataList, this.trailingWidget}) : super(key: key);

  final String headerButtonTitle;
  final List dataList;
  final Widget? trailingWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: ()=> Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AlbumPlaylistExpandedPage(dataList: dataList, title: headerButtonTitle)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(headerButtonTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
              const Icon(Icons.chevron_right, color: Colors.grey,),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: trailingWidget,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: PageView.builder(
              controller: PageController(viewportFraction: 0.9),
              scrollDirection: Axis.horizontal,
              itemCount: dataList.length,
              itemBuilder: (context, index) => _squareItemFromData(dataList[index])
          ),
        ),
      ],
    );
  }

  Widget _squareItemFromData(var dataItem){
    String title = '';
    String subtitle = '';
    String imgUrl = '';
    String overlayText = '';
    Widget detailsPage = Container();

    switch (dataItem.type){
      case 'album':
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
        title = dataItem.name;
        subtitle = dataItem.description;
        imgUrl = dataItem.images.first.url;
        detailsPage = BlocProvider<PlaylistBloc>(
            create: (context) => PlaylistBloc(),
            child: PlaylistDetails(playlistId: dataItem.id,)
        );
        break;
    }

    return SquareItem(title: title, subtitle: subtitle, imgUrl: imgUrl, overlayText: overlayText, detailsPage: detailsPage);
  }

}
