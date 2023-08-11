import 'package:apple_music_clone/ui/home_page/bloc/theme_bloc.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ThemeBloc>(context).add(GetCurrentTheme());
  }

  void _setSelectedTheme(ThemeMode themeMode,ThemeBloc dialogThemeBloc, ThemeBloc contextThemeBloc) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('theme', themeMode.index);
    contextThemeBloc.add(GetCurrentTheme());
    dialogThemeBloc.add(GetCurrentTheme());
  }

  void _showThemeOptionsDialog(ThemeMode currentThemeMode) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        ThemeBloc dialogThemeBloc = BlocProvider.of<ThemeBloc>(dialogContext);
        ThemeBloc contextThemeBloc = BlocProvider.of<ThemeBloc>(context);
        return AlertDialog(
          title: const Text('Theme'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                selectedTileColor: Theme.of(dialogContext).colorScheme.primary,
                title: const Text('Light'),
                value: ThemeMode.light,
                groupValue: currentThemeMode,
                onChanged: (value) {
                  _setSelectedTheme(value!, dialogThemeBloc, contextThemeBloc);
                  Navigator.pop(dialogContext);
                },
              ),
              RadioListTile(
                selectedTileColor: Theme.of(dialogContext).colorScheme.primary,
                title: const Text('Dark'),
                value: ThemeMode.dark,
                groupValue: currentThemeMode,
                onChanged: (value) {
                  _setSelectedTheme(value!, dialogThemeBloc, contextThemeBloc);
                  Navigator.pop(dialogContext);
                },
              ),
              RadioListTile(
                selectedTileColor: Theme.of(dialogContext).colorScheme.primary,
                title: const Text('System Default'),
                value: ThemeMode.system,
                groupValue: currentThemeMode,
                onChanged: (value) {
                  _setSelectedTheme(value!, dialogThemeBloc, contextThemeBloc);
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: ()=> Navigator.of(dialogContext).pop(), child: const Text('Cancel'))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        if (state.status.isLoading || state.status.isInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        else if (state.status.isSuccess) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              shape: Border(
                bottom: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 0.5)
              ),
              title: const Text('Settings'),
            ),
            body: ListView(
              children: [
                ListTile(
                    title: Text(
                      'Display Options',
                      style: TextStyle(
                          fontSize: AppConfig.mediumText,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    )
                ),
                ListTile(
                  title: const Text('Theme Settings', style: TextStyle(fontSize: AppConfig.mediumText),),
                  subtitle: Text(
                    '${state.themeMode.name[0].toUpperCase()}${state.themeMode.name.substring(1)}',
                    style: TextStyle(fontSize: AppConfig.smallText, color: Theme.of(context).colorScheme.secondary),
                  ),
                  onTap: ()=> _showThemeOptionsDialog(state.themeMode),
                ),
                // Add other settings items here
              ],
            ),
          );
        }

        else if (state.status.isError) {
          return Center(
            child: Text('Failed to fetch data: ${state.errorMsg}'),
          );
        }

        return Text('$state');
      }
    );
  }
}
