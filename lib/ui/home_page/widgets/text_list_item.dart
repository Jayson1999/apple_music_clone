import 'package:apple_music_clone/utils/config.dart';
import 'package:flutter/material.dart';


class TextListItem extends StatelessWidget {
  const TextListItem(
      {Key? key,
      required this.title,
      required this.detailsPageRoute,
      this.detailsPageArgs})
      : super(key: key);

  final String title;
  final String detailsPageRoute;
  final dynamic detailsPageArgs;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey, width: 0.5),
            )),
        child: TextButton(
            style: TextButton.styleFrom(
                alignment: Alignment.centerLeft
            ),
            onPressed: () => Navigator.pushNamed(
              context,
              detailsPageRoute,
              arguments: detailsPageArgs
            ),
            child: Text(title, style: const TextStyle(color: Colors.red, fontSize: AppConfig.mediumText))
        )
    );
  }
}
