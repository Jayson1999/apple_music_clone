import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/expanded_tracks_page.dart';
import 'package:apple_music_clone/ui/home_page/widgets/list_item.dart';
import 'package:flutter/material.dart';


class ListCarousel extends StatelessWidget {
  const ListCarousel({Key? key, required this.dataList, required this.noOfRowsPerPage, required this.headerButtonTitle, required this.listTileSize, required this.imgSize}) : super(key: key);

  final String headerButtonTitle;
  final int noOfRowsPerPage;
  final List dataList;
  final double listTileSize;
  final double imgSize;

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
            MaterialPageRoute(
                builder: (context) => TracksExpandedPage(title: 'Tracks', dataList: dataList)),
          ),
          child: Row(
            children: [
              Text(headerButtonTitle, style: const TextStyle(fontWeight: FontWeight.bold),),
              const Icon(Icons.chevron_right, color: Colors.grey,)
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.55,
          child: PageView.builder(
              controller: PageController(viewportFraction: 0.9),
              scrollDirection: Axis.horizontal,
              itemCount: noOfPages,
              itemBuilder: (context, pageIndex) {
                List<Widget> currentPageCards = [
                  for (int rowIndex=0; rowIndex<noOfRowsPerPage; rowIndex++)
                    ListItem(
                        title: splitDataLists[pageIndex][rowIndex].name,
                        subtitle: [for (Artist artist in splitDataLists[pageIndex][rowIndex].artists) artist.name].join(', '),
                        listTileSize: listTileSize,
                        imgSize: imgSize,
                        imgUrl: '${splitDataLists[pageIndex][rowIndex].album?.images[0].url}',
                        showBtmBorder: rowIndex != noOfRowsPerPage-1
                    )
                ];
                return Column(mainAxisAlignment: MainAxisAlignment.center,children: currentPageCards,);
              }),
        )
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

}
