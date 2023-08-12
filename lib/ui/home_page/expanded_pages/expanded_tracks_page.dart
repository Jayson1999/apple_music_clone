import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/ui/home_page/widgets/list_item.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:flutter/material.dart';

import '../widgets/bottom_sheet.dart';


class TracksExpandedPage extends StatelessWidget {
  const TracksExpandedPage({Key? key, required this.dataList, required this.title}) : super(key: key);
  final String title;
  final List dataList;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(title, style: const TextStyle(fontSize: AppConfig.mediumText),),
            elevation: 0,
            shape: Border(
                bottom: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 0.5
                )
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _bodyContents(context),
          ),
        ),
      ),
    );
  }

  Widget _bodyContents(BuildContext context){
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        String title = dataList[index].name;
        String subtitle = [for (Artist a in dataList[index].artists) a.name].join(',');
        String url = dataList[index].album?.images.first.url ?? AppConfig.placeholderImgUrl;

        return InkWell(
          onTap: ()=> print('hello'),
          child: ListItem(
              title: title,
              subtitle: subtitle,
              listTileSize: MediaQuery.of(context).size.height * 0.1,
              imgSize: 40,
              imgUrl: url,
              showBtmBorder: index != dataList.length-1,
              trailingWidget: IconButton(
                icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.primary,),
                onPressed: (){
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      isDismissible: true,
                      builder: (context){
                        return BottomSheetLayout(
                            title: title,
                            subtitle: subtitle,
                            imgUrl: url,
                            type: 'song'
                        );
                      });
                },
              )
          ),
        );
      },
    );
  }
}
