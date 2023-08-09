import 'package:apple_music_clone/utils/config.dart';
import 'package:flutter/material.dart';


class TextListItem extends StatelessWidget {
  const TextListItem({Key? key, required this.title, required this.detailsPage}) : super(key: key);

  final String title;
  final Widget detailsPage;

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
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => detailsPage
              ),
            ),
            child: Text(title, style: const TextStyle(color: Colors.red, fontSize: AppConfig.mediumText))
        )
    );
  }
}
