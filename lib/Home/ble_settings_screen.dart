import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BleSettings extends StatefulWidget {
  const BleSettings({Key? key}) : super(key: key);
  @override
  _BleSettingsState createState() => _BleSettingsState();
}

class _BleSettingsState extends State<BleSettings> {
  String inputText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: const Text('블루투스 기기 관리'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('기기 연결 해제'),
            subtitle: Text('기기와의 연결을 종료합니다'),
          ),
          ListTile(
            title: Text('기기 등록 해제'),
            subtitle: Text('더이상 이 기기를 사용하지 않습니다'),
          ),

          ExpansionTile(
            title: Text('연락처 입력'),
            subtitle: Text('위급 상황 시 저장한 연락처로 SMS를 발송합니다'),
            initiallyExpanded: true,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.height*0.60,
                      child: TextField(
                        decoration: InputDecoration(
                            labelText: '연락처입력'
                        ),
                        onChanged: (text) {
                          setState(() {
                            inputText = text;
                          });
                        },
                        keyboardType: TextInputType.phone
                      ),
                    )

                  ],
                )
              )

            ],
          ),
          Text('$inputText')

        ],
      )
    );
  }
}
