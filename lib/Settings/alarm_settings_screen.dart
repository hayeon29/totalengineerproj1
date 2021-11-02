import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmSettings extends StatefulWidget {
  const AlarmSettings({Key? key}) : super(key: key);

  @override
  _AlarmSettingsState createState() => _AlarmSettingsState();
}

class _AlarmSettingsState extends State<AlarmSettings> {

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  bool _vibrateAlarm = false;
  bool _soundAlarm = false;
  bool _smsAlarm = false;

  void _setData(bool vibrateAlarm, bool soundAlarm, bool smsAlarm) async {
    var keyVib = 'vibAlarm';
    var keySnd = 'sndAlarm';
    var keySms = 'smsAlarm';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(keyVib, vibrateAlarm);
    preferences.setBool(keySnd, soundAlarm);
    preferences.setBool(keySms, smsAlarm);
  }

  void _loadData() async {
    var keyVib = 'vibAlarm';
    var keySnd = 'sndAlarm';
    var keySms = 'smsAlarm';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _vibrateAlarm = preferences.getBool(keyVib)!;
      _soundAlarm = preferences.getBool(keySnd)!;
      _smsAlarm = preferences.getBool(keySms)!;
    });
  }

  void _setAlarmSettings() {
    setState(() {
      _setData(_vibrateAlarm, _soundAlarm, _smsAlarm);
    });
  }

//TODO: 뒤로가기 버튼 막고 저장 버튼 추가할것(?)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              _setAlarmSettings();
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: const Text('알람설정'),

        ),
        body: ListView(
          children: <Widget>[
            SwitchListTile(
              title: Text('진동 알림'),
                subtitle: Text('수면 중 무호흡 시 푸시알림을 전송합니다'),
                value: _vibrateAlarm,
                onChanged: (bool value) {
                  setState(() {
                    _vibrateAlarm = value;
                  });
                }
            ),
            SwitchListTile(
              title: Text('소리 알림'),
                subtitle: Text('수면 중 위급한 상황에 소리알림을 사용합니다'),
                value: _soundAlarm,
                onChanged: (bool value) {
                  setState(() {
                    _soundAlarm = value;
                  });
                }
            ),
            SwitchListTile(
              title: Text('SMS 알림'),
                subtitle: Text('위급상황 시 보호자 및 응급시설에 SMS를 전송합니다'),
                value: _smsAlarm,
                onChanged: (bool value) {
                  setState(() {
                    _smsAlarm = value;
                  });
                }
            ),
            Text('진동알림: $_vibrateAlarm, 소리알림: $_soundAlarm, SMS알림: $_smsAlarm')
          ],

        ),
    );
  }
}

