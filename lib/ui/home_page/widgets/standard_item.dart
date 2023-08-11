import 'package:apple_music_clone/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class StandardItem extends StatelessWidget {
  const StandardItem(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.imgUrl,
      required this.id,
      required this.nextPageRoute,
      required this.nextPageArgs})
      : super(key: key);

  final String title ;
  final String subtitle;
  final String imgUrl;
  final String id ;
  final String nextPageRoute;
  final dynamic nextPageArgs;

  @override
  Widget build(BuildContext context) {
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
              onTap: ()=> Navigator.pushNamed(
                context,
                nextPageRoute,
                arguments: nextPageArgs
              ),
              child: CachedNetworkImage(
                height: MediaQuery.of(context).size.height * 0.2,
                width: double.infinity,
                imageUrl: imgUrl,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => CachedNetworkImage(imageUrl: AppConfig.placeholderImgUrl),
              ),
            )
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: AppConfig.mediumText),),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            subtitle,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: AppConfig.mediumText, color: Colors.grey),
          ),
        ),
      ],
    );
  }

}
