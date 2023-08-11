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
                TextButton(
                    onPressed: () => print('hello'),
                    child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sign In',
                          style: TextStyle(fontSize: AppConfig.mediumText),
                        ))),
                ..._displaySettingsContent(state.themeMode),
                ..._diagnosticSettingsContent(),
                ..._aboutContent(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Copyright 2023 Apple Clone Inc. All rights reserved', style: TextStyle(fontSize: AppConfig.smallText, color: Theme.of(context).colorScheme.secondary),),
                )
              ],
            )
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

  List<Widget> _displaySettingsContent(ThemeMode themeMode) {
    return [
      ListTile(
        title: Text(
          'Display Options',
          style: TextStyle(
              fontSize: AppConfig.mediumText,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary),
        ),
        shape: Border(
            top: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 0.5)
        ),
      ),
      ListTile(
        title: const Text(
          'Theme', style: TextStyle(fontSize: AppConfig.mediumText),),
        subtitle: Text(
          '${themeMode.name[0].toUpperCase()}${themeMode.name.substring(1)}',
          style: TextStyle(fontSize: AppConfig.smallText, color: Theme.of(context).colorScheme.secondary),
        ),
        onTap: () => _showThemeOptionsDialog(themeMode),
      ),
      ListTile(
        title: const Text(
          'Motion', style: TextStyle(fontSize: AppConfig.mediumText),),
        subtitle: Text(
          'Manage how animations are displayed',
          style: TextStyle(fontSize: AppConfig.smallText, color: Theme.of(context).colorScheme.secondary),
        ),
        onTap: () => print('hello'),
        shape: Border(
            bottom: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 0.5)
        ),
      ),
    ];
  }

  List<Widget> _diagnosticSettingsContent() {
    bool toggleSwitch = true;
    return [
      ListTile(
        title: Text(
          'Diagnostics',
          style: TextStyle(
              fontSize: AppConfig.mediumText,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary),
        ),
        shape: Border(
            top: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 0.5)
        ),
      ),
      ListTile(
        title: const Text(
          'Automatically Send', style: TextStyle(fontSize: AppConfig.mediumText),),
        trailing: Switch(
          value: toggleSwitch,
          onChanged: (value) {
            setState(() {
              toggleSwitch = value;
            });
          },
          activeColor: Theme.of(context).colorScheme.primary,
        ),
      ),
      ListTile(
        title: const Text(
          'About Diagnostics & Privacy', style: TextStyle(fontSize: AppConfig.mediumText),),
        onTap: () => print('hello'),
        shape: Border(
            bottom: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 0.5)
        ),
      ),
    ];
  }

  List<Widget> _aboutContent() {
    return [
      ListTile(
        title: Text(
          'About',
          style: TextStyle(
              fontSize: AppConfig.mediumText,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary),
        ),
        shape: Border(
            top: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 0.5)
        ),
        onTap: () => print('hello'),
      ),
      ListTile(
        title: const Text('About Apple Music Clone & Privacy', style: TextStyle(fontSize: AppConfig.mediumText),),
        onTap: () => print('hello'),
      ),
       ListTile(
          title: const Text('Apple Music Clone Terms & Conditions', style: TextStyle(fontSize: AppConfig.mediumText),),
        onTap: () => print('hello'),
      ),
      ListTile(
          title: const Text('Acknowledgements', style: TextStyle(fontSize: AppConfig.mediumText),),
        onTap: () => print('hello'),
      ),
      ListTile(
          title: const Text('Provide Feedback', style: TextStyle(fontSize: AppConfig.mediumText),),
        onTap: () => print('hello'),
      ),
      ListTile(
          title: const Text('Get Support', style: TextStyle(fontSize: AppConfig.mediumText),),
          onTap: () => print('hello'),
      ),
      ListTile(
          title: const Text('Version', style: TextStyle(fontSize: AppConfig.mediumText),),
          subtitle: Text(
            '1.0.0 (1208)',
            style: TextStyle(fontSize: AppConfig.smallText, color: Theme.of(context).colorScheme.secondary),
          ),
          onTap: () => print('hello'),
          shape: Border(
              bottom: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 0.5)
          ),
      ),
    ];
  }
}
