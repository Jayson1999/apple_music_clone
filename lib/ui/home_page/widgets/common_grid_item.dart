import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/ui/home_page/details_page/album_details/album_details_page.dart';
import 'package:apple_music_clone/ui/home_page/details_page/album_details/bloc/album_bloc.dart';
import 'package:apple_music_clone/ui/home_page/details_page/playlist_details/bloc/playlist_bloc.dart';
import 'package:apple_music_clone/ui/home_page/details_page/playlist_details/playlist_details_page.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


Widget commonGridItem(BuildContext context, String headerButtonTitle, int noOfRows, List dataList) {
  final int noOfItemsPerRow = dataList.length~/noOfRows;
  List<List> splitDataLists = _splitList(dataList, noOfItemsPerRow);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextButton(
        onPressed: ()=>print('hello'),
        child: Row(
          children: [
            Text(headerButtonTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
            const Icon(Icons.chevron_right, color: Colors.grey,)
          ],
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.3 * noOfRows,
        child: PageView.builder(
            padEnds: false,
            controller: PageController(viewportFraction: 0.5),
            scrollDirection: Axis.horizontal,
            itemCount: noOfItemsPerRow,
            itemBuilder: (context, pageIndex) {
              List<Widget> currentPageCards = [
                for (int rowIndex=0; rowIndex<noOfRows; rowIndex++)
                  _singleCardItem(
                      context,
                      splitDataLists[rowIndex][pageIndex]
                  )
              ];
              return Column(children: currentPageCards);
            }),
      )
    ],
  );
}

Widget _singleCardItem(BuildContext context, dynamic dataItem) {
  String title = '';
  String subtitle = '';
  String imgUrl = '';
  String id = '';
  dynamic nextPage;
  
  switch (dataItem.type){
    case 'playlist':
      title = dataItem.name;
      subtitle = dataItem.description;
      imgUrl = dataItem.images[0].url;
      id = dataItem.id;
      nextPage = BlocProvider<PlaylistBloc>(
          create: (context) => PlaylistBloc(),
          child: PlaylistDetails(playlistId: id)
      );
      break;
    case 'album':
      title = dataItem.name;
      subtitle = [for (Artist artist in dataItem.artists) artist.name].join(', ');
      imgUrl = dataItem.images[0].url;
      id = dataItem.id;
      nextPage = BlocProvider<AlbumBloc>(
          create: (context) => AlbumBloc(),
          child: AlbumDetails(albumId: id)
      );
      break;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Card(
          clipBehavior: Clip.hardEdge,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              width: 0.3,
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: InkWell(
            onTap: ()=> Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => nextPage),
            ),
            child: CachedNetworkImage(
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              imageUrl: imgUrl,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
            ),
          )
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: TextSizes.medium, color: Colors.black),),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
        child: Text(
          subtitle,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: TextSizes.medium, color: Colors.grey),
        ),
      ),
    ],
  );
}

List<List<T>> _splitList<T>(List<T> list, int size) {
  List<List<T>> result = [];
  for (int i = 0; i < list.length; i += size) {
    result.add(list.sublist(i, i + size > list.length ? list.length : i + size));
  }
  return result;
}
