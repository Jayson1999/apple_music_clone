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
        decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 0.5),
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
            child: Text(title, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: AppConfig.mediumText))
        )
    );
  }
}
