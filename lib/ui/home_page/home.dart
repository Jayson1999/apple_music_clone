import 'package:apple_music_clone/ui/home_page/tabs/browse_tab/bloc/browse_bloc.dart';
import 'package:apple_music_clone/ui/home_page/tabs/browse_tab/browse.dart';
import 'package:apple_music_clone/ui/home_page/tabs/library_tab/library.dart';
import 'package:apple_music_clone/ui/home_page/tabs/listennow_tab/listennow.dart';
import 'package:apple_music_clone/ui/home_page/tabs/radio_tab/radio.dart';
import 'package:apple_music_clone/ui/home_page/tabs/search_tab/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  int _selectedIndex = 0;

  void _onPageChanged(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BrowseBloc>(create: (context) => BrowseBloc()),
        // BlocProvider<RadioBloc>(create: (context) => RadioBloc()),
        // BlocProvider<SearchBloc>(create: (context) => SearchBloc()),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _tabItems.values.map((v) => v['tab']!).toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: _tabItems.entries
              .map((e) =>
                  BottomNavigationBarItem(icon: e.value['icon']!, label: e.key))
              .toList(),
          currentIndex: _selectedIndex,
          onTap: _onPageChanged,
        ),
      ),
    );
  }
}
