import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_alarm/Settings/personal_settings_screen.dart';

import 'alarm_settings_screen.dart';


class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: null,
            title: Text('개인정보 설정'),
            subtitle: Text('사용자의 개인정보를 설정합니다'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PersonalSettings())
              );
            } ,
          ),
          ListTile(
            leading: null,
            title: Text('테마 설정'),
            subtitle: Text('앱의 테마를 설정합니다'),
            onTap: () {} ,
          ),
          ListTile(
            leading: null,
            title: Text('알림 설정'),
            subtitle: Text('알림 설정'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AlarmSettings())
              );
            } ,
          ),
          ListTile(
            leading: null,
            title: Text('라이센스 정보'),
            onTap: () {} ,
          ),
          ListTile(
            leading: null,
            title: Text('개인정보처리방침'),
            onTap: () {} ,
          ),
        ],
      ),

    );
  }
}
