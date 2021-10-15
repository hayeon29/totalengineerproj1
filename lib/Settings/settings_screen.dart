import 'package:flutter/material.dart';
import 'package:smart_alarm/Settings/components/menu_data.dart';

import 'components/settings_menu.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        actions: [
          
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8.0),
          SettingMenu(iconMenuList: iconMenu),
        ],
      ),

    );
  }
}
