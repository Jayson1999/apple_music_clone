import 'dart:math';
import 'package:apple_music_clone/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NarrowTintedItem extends StatelessWidget {
  const NarrowTintedItem(
      {Key? key,
      required this.title,
      required this.imgUrl,
      required this.detailsPageRoute,
      this.detailsPageArgs})
      : super(key: key);

  final String title;
  final String imgUrl;
  final String detailsPageRoute;
  final dynamic detailsPageArgs;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
              onTap: () => Navigator.pushNamed(
                context,
                detailsPageRoute,
                arguments: detailsPageArgs
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: _createRandomGradient(),
                ),
                child: CachedNetworkImage(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: double.infinity,
                  imageUrl: imgUrl,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => CachedNetworkImage(imageUrl: AppConfig.placeholderImgUrl),
                ),
              ),
            )
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: AppConfig.mediumText),
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

}
