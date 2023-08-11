import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/details_pages_args.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/expanded_pages_args.dart';
import 'package:apple_music_clone/ui/home_page/widgets/standard_item.dart';
import 'package:apple_music_clone/utils/app_routes.dart';
import 'package:flutter/material.dart';


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
          onPressed: () => Navigator.pushNamed(
            context,
            AppRoutes.albumsExpandedPage,
            arguments: AlbumsPlaylistsExpandedArguments(headerButtonTitle, dataList)
          ),
          child: Row(
            children: [
              Text(headerButtonTitle, style: const TextStyle(fontWeight: FontWeight.bold),),
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
                return Column(mainAxisAlignment: MainAxisAlignment.center,children: currentPageCards,);
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
  String nextPageRoute = '';
  dynamic nextPageArgs;

  switch (dataItem.type){
    case 'playlist':
      title = dataItem.name;
      subtitle = dataItem.description;
      imgUrl = dataItem.images.first.url;
      id = dataItem.id;
      nextPageRoute = AppRoutes.playlistDetailsPage;
      nextPageArgs = PlaylistDetailsArguments(id);
      break;
    case 'album':
      title = dataItem.name;
      subtitle = [for (Artist artist in dataItem.artists) artist.name].join(', ');
      imgUrl = dataItem.images[0].url;
      id = dataItem.id;
      nextPageRoute = AppRoutes.albumDetailsPage;
      nextPageArgs = AlbumDetailsArguments(id);
      break;
  }

  return StandardItem(
    title: title,
    subtitle: subtitle,
    imgUrl: imgUrl,
    id: id,
    nextPageRoute: nextPageRoute,
    nextPageArgs: nextPageArgs,
  );
}

List<List<T>> _splitList<T>(List<T> list, int size) {
  List<List<T>> result = [];
  for (int i = 0; i < list.length; i += size) {
    result.add(list.sublist(i, i + size > list.length ? list.length : i + size));
  }
  return result;
}
