import 'package:apple_music_clone/ui/home_page/details_pages/expanded_artists_page.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


Widget circularItem(BuildContext context, String headerButtonTitle, List dataList) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArtistsExpandedPage(dataList: dataList, title: headerButtonTitle),
          ),
        ),
        child: Row(
          children: [
            Text(headerButtonTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
            const Icon(Icons.chevron_right, color: Colors.grey,)
          ],
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        child: PageView.builder(
            padEnds: false,
            controller: PageController(viewportFraction: 0.32),
            scrollDirection: Axis.horizontal,
            itemCount: dataList.length,
            itemBuilder: (context, pageIndex) {
              return _circularItem(
                  context,
                  dataList[pageIndex].name,
                  dataList[pageIndex].images.first.url
              );
            }),
      )
    ],
  );
}

Widget _circularItem(BuildContext context, String title, String imgUrl) {
  return Column(
    children: [
      CircleAvatar(
        radius: 50,
        child: ClipOval(
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height * 0.15,
            width: double.infinity,
            imageUrl: imgUrl,
            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: AppConfig.mediumText, color: Colors.black),
        ),
      ),
    ],
  );
}
