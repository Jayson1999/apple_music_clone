import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/album_details/album_details_page.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/album_details/bloc/album_bloc.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/expanded_album_playlist_page.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/playlist_details/bloc/playlist_bloc.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/playlist_details/playlist_details_page.dart';
import 'package:apple_music_clone/ui/home_page/widgets/standard_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class StandardCarousel extends StatelessWidget {
  const StandardCarousel({Key? key, required this.headerButtonTitle, required this.noOfRowsPerPage, required this.dataList}) : super(key: key);

  final String headerButtonTitle;
  final int noOfRowsPerPage;
  final List dataList;

  int get noOfPages => dataList.length ~/ noOfRowsPerPage;
  List<List> get splitDataLists => _splitList(dataList, noOfRowsPerPage);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AlbumPlaylistExpandedPage(dataList: dataList, title: headerButtonTitle)),
          ),
          child: Row(
            children: [
              Text(headerButtonTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
              const Icon(Icons.chevron_right, color: Colors.grey,)
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3 * noOfRowsPerPage,
          child: PageView.builder(
              padEnds: false,
              controller: PageController(viewportFraction: 0.5),
              scrollDirection: Axis.horizontal,
              itemCount: noOfPages,
              itemBuilder: (context, pageIndex) {
                List<Widget> currentPageCards = [
                  for (int rowIndex=0; rowIndex<noOfRowsPerPage; rowIndex++)
                    _standardItemFromData(splitDataLists[pageIndex][rowIndex])
                ];
                return Column(children: currentPageCards);
              }),
        )
      ],
    );
  }
}

Widget _standardItemFromData(var dataItem) {
  String title = '';
  String subtitle = '';
  String id = '';
  String imgUrl = '';
  Widget nextPage = Container();

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

  return StandardItem(title: title, subtitle: subtitle, imgUrl: imgUrl, id: id, nextPage: nextPage);
}

List<List<T>> _splitList<T>(List<T> list, int size) {
  List<List<T>> result = [];
  for (int i = 0; i < list.length; i += size) {
    result.add(list.sublist(i, i + size > list.length ? list.length : i + size));
  }
  return result;
}
