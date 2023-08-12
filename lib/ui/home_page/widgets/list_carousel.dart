import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/ui/home_page/expanded_pages/expanded_pages_args.dart';
import 'package:apple_music_clone/ui/home_page/widgets/bottom_sheet.dart';
import 'package:apple_music_clone/ui/home_page/widgets/list_item.dart';
import 'package:apple_music_clone/utils/app_routes.dart';
import 'package:apple_music_clone/utils/config.dart';
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
          onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.tracksExpandedPage,
              arguments: TracksExpandedArguments('Tracks', dataList)
          ),
          child: Row(
            children: [
              Text(headerButtonTitle, style: const TextStyle(fontWeight: FontWeight.bold),),
              Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.secondary,)
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
                List<Widget> currentPageCards = [];
                for (int rowIndex=0; rowIndex<noOfRowsPerPage; rowIndex++) {
                  String title = splitDataLists[pageIndex][rowIndex].name;
                  String subtitle = [for (Artist artist in splitDataLists[pageIndex][rowIndex].artists) artist.name].join(', ');
                  String imgUrl = splitDataLists[pageIndex][rowIndex].album?.images?.first.url ?? AppConfig.placeholderImgUrl;
                  currentPageCards.add(ListItem(
                      title: title,
                      subtitle: subtitle,
                      listTileSize: listTileSize,
                      imgSize: imgSize,
                      imgUrl: imgUrl,
                      showBtmBorder: rowIndex != noOfRowsPerPage - 1,
                      trailingWidget: IconButton(
                        icon: Icon(Icons.more_vert, color: Theme
                            .of(context)
                            .colorScheme
                            .primary,),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              isDismissible: true,
                              builder: (context) {
                                return BottomSheetLayout(
                                    title: title,
                                    subtitle: subtitle,
                                    imgUrl: imgUrl,
                                    type: 'song'
                                );
                              });
                        },
                      )
                  ));
                }

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
