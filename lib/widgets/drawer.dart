import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../screens/app_info_screen.dart';
import '../screens/instructions_screen.dart';
import '../screens/settings_screen.dart';


class drawerWidget extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(top: 40.0),
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AppInfoScreen()));
              },
            ),
            ListTile(
                leading: Icon(FontAwesomeIcons.tasks),
                title: Text('How to use'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => InstructionsScreen()));
                }),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SettingsScreen()));
              },
            )
          ],
        ),
      ),
    );
  }
}
