import 'package:apple_music_clone/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircularItem extends StatelessWidget {
  const CircularItem({Key? key, required this.title, required this.imgUrl}) : super(key: key);

  final String title;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
              errorWidget: (context, url, error) => CachedNetworkImage(imageUrl: AppConfig.placeholderImgUrl),
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

}
