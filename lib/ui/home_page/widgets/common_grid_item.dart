import 'package:apple_music_clone/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget commonGridItem(BuildContext context, String headerButtonTitle, int noOfRows, List<String> titleList, List<String> subtitleList, List<String> imgUrlList) {
  for (int i=0; i<noOfRows; i++){

  }

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
        height: MediaQuery.of(context).size.height * 0.3,
        child: PageView.builder(
            controller: PageController(viewportFraction: 0.9),
            scrollDirection: Axis.horizontal,
            itemCount: titleList.length,
            itemBuilder: (context, index) {
              return _singleCardItem(context, titleList[index], subtitleList[index], imgUrlList[index]);
            }
        ),
      ),
    ],
  );
}

Widget _singleCardItem(BuildContext context, String title, String subtitle, String imgUrl){
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
        child: Text(title, style: const TextStyle(fontSize: TextSizes.medium, color: Colors.black),),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          subtitle,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: TextSizes.medium, color: Colors.grey),
        ),
      ),
    ],
  );
}
