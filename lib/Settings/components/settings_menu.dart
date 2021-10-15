import 'package:flutter/material.dart';

import '../../Theme.dart';
import 'menu_data.dart';

class SettingMenu extends StatelessWidget {
  final List<IconMenu> iconMenuList;

  SettingMenu({required this.iconMenuList});


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: List.generate(
            iconMenuList.length,
                (index) => _buildRowIconItem(
                iconMenuList[index].title, iconMenuList[index].subtitle),
          ),
        ),
      ),
    );
  }

  Widget _buildRowIconItem(String title, String subtitle) {
    return Container(
      height: 50,
      child: Row(
        children: <Widget>[
          const SizedBox(width: 0),
          Text(title, style: textTheme().headline1),

          //Text(subtitle, style: textTheme().bodyText2),
        ],
      ),
    );
  }
}