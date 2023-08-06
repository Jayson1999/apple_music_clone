import 'dart:math';
import 'package:apple_music_clone/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


Widget narrowGridItem(BuildContext context, String headerTitle, List<String> titleList, List<String> imgUrlList) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(headerTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        child: PageView.builder(
            padEnds: false,
            controller: PageController(viewportFraction: 0.5),
            scrollDirection: Axis.horizontal,
            itemCount: titleList.length,
            itemBuilder: (context, pageIndex) {
              return _tintedCardItem(context,
                  titleList[pageIndex],
                  imgUrlList[pageIndex]
              );
            }),
      )
    ],
  );
}

Widget _tintedCardItem(BuildContext context, String title, String imgUrl) {
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
            child: Container(
              decoration: BoxDecoration(
                gradient: _createRandomGradient(),
              ),
              child: CachedNetworkImage(
                height: MediaQuery.of(context).size.height * 0.15,
                width: double.infinity,
                imageUrl: imgUrl,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
              ),
            ),
          )
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
        child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: AppConfig.mediumText, color: Colors.black),
        ),
      ),
    ],
  );
}


LinearGradient _createRandomGradient() {
  const double opacity = 0.3;
  final Random random = Random();
  final Color color1 = Color.fromARGB(
      (255*opacity).toInt(),
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256)
  );
  final Color color2 = Color.fromARGB(
      (255*opacity).toInt(),
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256)
  );

  return LinearGradient(
    colors: [color1, color2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

