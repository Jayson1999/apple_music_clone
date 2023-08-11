import 'package:apple_music_clone/ui/home_page/tab_navigator.dart';
import 'package:apple_music_clone/ui/home_page/tabs/browse_tab/bloc/browse_bloc.dart';
import 'package:apple_music_clone/ui/home_page/tabs/browse_tab/browse.dart';
import 'package:apple_music_clone/ui/home_page/tabs/library_tab/bloc/library_bloc.dart';
import 'package:apple_music_clone/ui/home_page/tabs/library_tab/library.dart';
import 'package:apple_music_clone/ui/home_page/tabs/listennow_tab/bloc/listennow_bloc.dart';
import 'package:apple_music_clone/ui/home_page/tabs/listennow_tab/listennow.dart';
import 'package:apple_music_clone/ui/home_page/tabs/radio_tab/bloc/radio_bloc.dart';
import 'package:apple_music_clone/ui/home_page/tabs/radio_tab/radio.dart';
import 'package:apple_music_clone/ui/home_page/tabs/search_tab/bloc/search_bloc.dart';
import 'package:apple_music_clone/ui/home_page/tabs/search_tab/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTab = 0;
  late PageController _pageController;
  late Future _getSharedPreferences;
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [];
  final Map<String, Map<String, Widget>> _tabItems = {
    'Listen Now': {
      'icon': const Icon(Icons.play_circle),
      'tab': const ListenNowTab()
    },
    'Browse': {
      'icon': const Icon(Icons.grid_view_rounded),
      'tab': const BrowseTab()
    },
    'Radio': {
      'icon': const ImageIcon(AssetImage("assets/images/radio_icon.png")),
      'tab': const RadioTab()
    },
    'Library': {
      'icon': const ImageIcon(AssetImage("assets/images/library_icon.png")),
      'tab': const LibraryTab()
    },
    'Search': {
      'icon': const Icon(Icons.search),
      'tab': const SearchTab()
    },
  };

  @override
  void initState() {
    super.initState();
    _getSharedPreferences = SharedPreferences.getInstance();

    _tabItems.forEach((key, value) {
      GlobalKey<NavigatorState> tabNavigatorKey = GlobalKey<NavigatorState>(debugLabel: key);
      _navigatorKeys.add(tabNavigatorKey);
      value['tab'] = TabNavigator(currentTab: value['tab']!, navigatorKey: tabNavigatorKey);
    });
  }

  void _onPageSelected(tabIndex) async{
    setState(() {
      _selectedTab = tabIndex;
      _pageController.jumpToPage(tabIndex);
    });
    SharedPreferences sPref = await SharedPreferences.getInstance();
    sPref.setInt('lastVisitedPage', tabIndex);
  }

  Future<bool> _systemBackButtonPressed() async {
    if (_navigatorKeys[_selectedTab].currentState == null){
      return true;
    }

    if (_navigatorKeys[_selectedTab].currentState!.canPop()) {
      if (_selectedTab == 4){
        return false;
      }
      _navigatorKeys[_selectedTab].currentState!.pop(_navigatorKeys[_selectedTab].currentContext);
    } else {
      SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getSharedPreferences,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        _selectedTab = snapshot.data.getInt('lastVisitedPage') ?? 0;
        _pageController = PageController(initialPage: _selectedTab);
        return MultiBlocProvider(
          providers: [
            BlocProvider<ListenNowBloc>(create: (context) => ListenNowBloc()),
            BlocProvider<BrowseBloc>(create: (context) => BrowseBloc()),
            BlocProvider<RadioBloc>(create: (context) => RadioBloc()),
            BlocProvider<LibraryBloc>(create: (context) => LibraryBloc()),
            BlocProvider<SearchBloc>(create: (context) => SearchBloc()),
          ],
          child: WillPopScope(
            onWillPop: _systemBackButtonPressed,
            child: SafeArea(
              child: Scaffold(
                body: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: _tabItems.values.map((v) => v['tab']!).toList(),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  items: _tabItems.entries
                      .map((e) =>
                          BottomNavigationBarItem(icon: e.value['icon']!, label: e.key))
                      .toList(),
                  currentIndex: _selectedTab,
                  onTap: _onPageSelected,
                ),
              ),
            ),
          ),
        );
      }
    );
  }

}
