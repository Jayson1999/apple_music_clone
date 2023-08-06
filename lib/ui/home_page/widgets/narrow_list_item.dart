import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/expanded_tracks_page.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


Widget narrowListCardItem(BuildContext context, String headerButtonTitle, List dataList) {
  const int noOfRowsPerPage = 4;
  final int noOfPages = dataList.length~/noOfRowsPerPage;
  List<List> splitDataLists = _splitList(dataList, noOfRowsPerPage);
  print("HERE!! splitDataLists length: ${splitDataLists.length}\ndataList length: ${dataList.length}\nbatchSize: ${noOfPages}\n\n");

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TracksExpandedPage(dataList: dataList, title: headerButtonTitle)),
        ),
        child: Row(
          children: [
            Text(headerButtonTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
            const Icon(Icons.chevron_right, color: Colors.grey,)
          ],
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: PageView.builder(
            controller: PageController(viewportFraction: 0.9),
            scrollDirection: Axis.horizontal,
            itemCount: noOfPages,
            itemBuilder: (context, pageIndex) {
              List<Widget> currentPageCards = [
                for (int rowIndex=0; rowIndex<noOfRowsPerPage; rowIndex++)
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: ListTile(
                        leading: CachedNetworkImage(
                          height: 30,
                          width: 30,
                          imageUrl: splitDataLists[pageIndex][rowIndex].album?.images.first.url ?? '',
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                        ),
                        title: Text(splitDataLists[pageIndex][rowIndex].name, style: const TextStyle(color: Colors.black, fontSize: AppConfig.smallText)),
                        subtitle: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: rowIndex!=3? Colors.grey: Colors.white, width: 0.5),
                                )
                            ),
                            child: Text(
                                [for (Artist a in splitDataLists[pageIndex][rowIndex].artists) a.name].join(','),
                                style: const TextStyle(color: Colors.grey, fontSize: AppConfig.smallText)
                            )
                        ),
                      ),
                    ),
                  )
              ];
              return Column(children: currentPageCards);
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
