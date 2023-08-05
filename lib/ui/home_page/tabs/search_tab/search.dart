import 'dart:math';
import 'package:apple_music_clone/model/category.dart';
import 'package:apple_music_clone/ui/home_page/tabs/search_tab/bloc/search_bloc.dart';
import 'package:apple_music_clone/ui/home_page/tabs/search_tab/search_delegate.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SearchTab extends StatefulWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SearchBloc>(context).add(GetUserSubscription());
    BlocProvider.of<SearchBloc>(context).add(GetCategoriesPlaylists());
  }

  bool showCard = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state.pageLoadStatus.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          else if (state.pageLoadStatus.isSuccess) {
            ScrollController scrollController = ScrollController();
            return CustomScrollView(
              controller: scrollController,
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.white,
                  expandedHeight: 100.0,
                  elevation: 0,
                  floating: true,
                  pinned: true,
                  title: const Text(
                    'Search',
                    style: TextStyle(fontSize: TextSizes.big, color: Colors.black),
                  ),
                  bottom: AppBar(
                    backgroundColor: Colors.white,
                    title: SizedBox(
                        width:double.infinity,
                        child: _searchAppBar()
                    ),
                  ),
                  actions: [
                    PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert, color: Theme.of(context).primaryColor,),
                        onSelected: (value) => Navigator.pushNamed(context, '/$value'),
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'settings',
                            child: Text('Settings'),
                          ),
                        ]
                    )
                  ],
                ),
                SliverList(
                    delegate: SliverChildListDelegate(
                        [
                          state.userSubscription == 0?
                          Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: _subscribeCard(showCard)
                          )
                              :
                          Container(),
                          _featuredCategoriesSection([...state.categoriesGlobal, ...state.categoriesLocal]),
                        ]
                    )
                ),
              ],
            );
          }

          else if (state.pageLoadStatus.isError) {
            return Center(
              child: Text('Failed to fetch data: ${state.errorMsg}'),
            );
          }

          return Text('$state');
        },
      ),
    );
  }

  Widget _featuredCategoriesSection(List<Category> categories){
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Browse Categories', style: TextStyle(fontSize: TextSizes.big, fontWeight: FontWeight.bold),),
          GridView.builder(
            clipBehavior: Clip.hardEdge,
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 100
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Card(
                    clipBehavior: Clip.hardEdge,
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: double.infinity,
                        imageUrl: categories[index].categoryIconsInfo[0].url,
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                      ),
                    ),
                  InkWell(
                    onTap: ()=> print('hello'),
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: _createRandomGradient(),
                          borderRadius: BorderRadius.circular(12)
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 18.0,
                    left: 18.0,
                    child: Text(
                      categories[index].name,
                      style: const TextStyle(
                          fontSize: TextSizes.medium,
                          color: Colors.white
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _searchAppBar() {
    const String searchHint = 'Artists, Songs, Lyrics and more';
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
          ),
            backgroundColor: Colors.white70,
        ),
        onPressed: (){
          final  SearchBloc searchBloc = context.read<SearchBloc>();
          showSearch(
              context: context,
              delegate: SearchBarDelegate(searchBloc, searchHint)
          );
        },
        child: const Text(
          searchHint,
          style: TextStyle(color: Colors.grey),
        )
    );
  }

  Widget _subscribeCard(bool showCard) {
    return Stack(
      children: [
        showCard?
          Card(
              clipBehavior: Clip.hardEdge,
              elevation: 10,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: InkWell(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CachedNetworkImage(
                          imageUrl: 'https://www.apple.com/newsroom/images/product/services/standard/Apple-Music-100-million-songs-hero_big.jpg.slideshow-xlarge_2x.jpg',
                          width: double.infinity,
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                        child: Text(
                          'Explore 100 million songs. All ad-free.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: TextSizes.big
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'Plus your entire music library on all your devices. Plan auto-renews for RM 16.90/month.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: TextSizes.medium
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 8.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.only(bottom: 8, top: 8),
                                  backgroundColor: Colors.red,),
                              onPressed: () => print('hello'),
                              child: const Text('Try it Now')),
                        ),
                      ),
                    ],
                  )
              )
          ):
            Container(),
        Positioned(
          top: 8.0,
          right: 8.0,
          child: InkWell(
            onTap: () {
              _toggleShowCard();
            },
            child: const Icon(Icons.close, color: Colors.grey,),
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

  void _toggleShowCard(){
    setState(() {
      showCard = !showCard;
    });
  }

}
