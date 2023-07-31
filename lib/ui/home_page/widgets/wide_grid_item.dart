import 'package:apple_music_clone/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget wideGridItem(BuildContext context, List<String> titleList, List<String> subtitleList, List<String> descriptionList, List<String> imgUrlList, List<String> overlayTextList) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.4,
    child: PageView.builder(
        controller: PageController(viewportFraction: 0.9),
        scrollDirection: Axis.horizontal,
        itemCount: titleList.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(descriptionList[index], style: const TextStyle(fontSize: TextSizes.small, color: Colors.grey),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(titleList[index], style: const TextStyle(fontSize: TextSizes.medium, color: Colors.black),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  subtitleList[index],
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: TextSizes.medium, color: Colors.grey),),
              ),
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
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          height: MediaQuery.of(context).size.height * 0.28,
                          width: double.infinity,
                          imageUrl: imgUrlList[index],
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              overlayTextList[index],
                              style: const TextStyle(
                                  fontSize: TextSizes.small,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
              ),
            ],
          );
        }
    ),
  );
}