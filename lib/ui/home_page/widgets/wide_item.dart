import 'package:apple_music_clone/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class WideItem extends StatelessWidget {
  const WideItem(
      {Key? key,
      required this.description,
      required this.title,
      required this.subtitle,
      required this.imgUrl,
      required this.overlayText,
      required this.detailsPageRoute,
      this.detailsPageArgs})
      : super(key: key);

  final String description;
  final String title;
  final String subtitle;
  final String imgUrl;
  final String overlayText;
  final String detailsPageRoute;
  final dynamic detailsPageArgs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(description, style: TextStyle(fontSize: AppConfig.smallText, color: Theme.of(context).colorScheme.secondary),),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(title, style: const TextStyle(fontSize: AppConfig.mediumText),),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            subtitle,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: AppConfig.mediumText, color: Theme.of(context).colorScheme.secondary),),
        ),
        Card(
            clipBehavior: Clip.hardEdge,
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 0.3,
                color: Theme.of(context).colorScheme.secondary,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: InkWell(
              onTap: () => Navigator.pushNamed(
                context,
                detailsPageRoute,
                arguments: detailsPageArgs
              ),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    height: MediaQuery.of(context).size.height * 0.28,
                    width: double.infinity,
                    imageUrl: imgUrl,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => CachedNetworkImage(imageUrl: AppConfig.placeholderImgUrl),
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
                        overlayText,
                        style: const TextStyle(
                            fontSize: AppConfig.smallText,
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

}
