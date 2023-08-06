import 'package:apple_music_clone/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


Widget wideListCardItem(BuildContext context, String headerButtonTitle, List<String> titleList, List<String> subtitleList, List<String> imgUrlList) {
  final int noOfItemsPerRow = titleList.length~/3;
  List<List<String>> splitTitleLists = _splitList(titleList, noOfItemsPerRow);
  List<List<String>> splitSubtitleLists = _splitList(subtitleList, noOfItemsPerRow);
  List<List<String>> splitImgUrlLists = _splitList(imgUrlList, noOfItemsPerRow);

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
        height: MediaQuery.of(context).size.height * 0.5,
        child: PageView.builder(
            controller: PageController(viewportFraction: 0.9),
            scrollDirection: Axis.horizontal,
            itemCount: splitTitleLists.length,
            itemBuilder: (context, pageIndex) {
              List<Widget> currentPageCards = [
                for (int rowIndex=0; rowIndex<3; rowIndex++)
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: ListTile(
                        leading: CachedNetworkImage(
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          imageUrl: splitImgUrlLists[rowIndex][pageIndex],
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                        ),
                        title: Text(splitTitleLists[rowIndex][pageIndex], style: const TextStyle(color: Colors.black, fontSize: AppConfig.mediumText)),
                        subtitle: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: rowIndex!=2? Colors.grey: Colors.white, width: 0.5),
                                )
                            ),
                            child: Text(splitSubtitleLists[rowIndex][pageIndex], style: const TextStyle(color: Colors.grey, fontSize: AppConfig.smallText))
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
