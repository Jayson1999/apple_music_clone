import 'package:apple_music_clone/ui/home_page/tabs/browse_tab/bloc/browse_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrowseTab extends StatefulWidget {
  const BrowseTab({Key? key}) : super(key: key);

  @override
  State<BrowseTab> createState() => _BrowseTabState();
}

class _BrowseTabState extends State<BrowseTab> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BrowseBloc>(context).add(GetLatestAlbums());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<BrowseBloc, BrowseState>(
        listener: (context, state) {
          // Add any additional logic here based on state changes
        },
        child: BlocBuilder<BrowseBloc, BrowseState>(
          builder: (context, state) {
            if (state.status.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.status.isSuccess) {
              // Display your browse content here
              return ListView.builder(
                itemCount: state.latestAlbums.length,
                itemBuilder: (context, index) {
                  final album = state.latestAlbums[index];
                  return ListTile(
                    title: Text(album.name),
                    subtitle: Text(album.name),
                  );
                },
              );
            } else if (state.status.isError) {
              return Center(
                child: Text('Failed to fetch data: ${state.errorMsg}'),
              );
            }
            return Text('$state');
          },
        ),
      ),
    );
  }
}
