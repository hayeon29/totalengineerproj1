/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter BLE Demo',
      home: MyHomePage(title: 'Flutter BLE Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BleManager _bleManager = BleManager(); //BLE 메니저
  bool _isScanning= false;               //스캔 확인용
  List<BleDeviceItem> deviceList = [];   //BLE 정보 저장용

  @override
  void initState() {
    init(); //BLE 초기화
    super.initState();
  }

  void init() async {
    //BLE 생성
    await _bleManager.createClient(
        restoreStateIdentifier: "example-restore-state-identifier",
        restoreStateAction: (peripherals) {
          peripherals.forEach((peripheral) {
            print("Restored peripheral: ${peripheral.name}");
          });
        })
        .catchError((e) => print("Couldn't create BLE client  $e"))
        .then((_) => _checkPermissions()) //BLE 생성 후 퍼미션 체크
        .catchError((e) => print("Permission check error $e"));
    //.then((_) => _waitForBluetoothPoweredOn())
  }
  //퍼미션 체크 및 없으면 퍼미션 동의 화면 출력
  _checkPermissions() async {
    if (Platform.isAndroid) {
      if (await Permission.contacts.request().isGranted) {
      }
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location
      ].request();
      print(statuses[Permission.location]);
    }
  }

  //스캔 ON/OFF
  void scan() async {
    if(!_isScanning) {
      deviceList.clear();
      _bleManager.startPeripheralScan().listen((scanResult) {
        // 페리페럴 항목에 이름이 있으면 그걸 사용하고
        // 없다면 어드버타이지먼트 데이터의 이름을 사용하고 그것 마져 없다면 Unknown으로 표시
        var name = scanResult.peripheral.name ?? scanResult.advertisementData.localName ?? "Unknown";

        // 여러가지 정보 확인
        print("Scanned Name ${name}, RSSI ${scanResult.rssi}");
        print("\tidentifier(mac) ${scanResult.peripheral.identifier}"); //mac address
        print("\tservice UUID : ${scanResult.advertisementData.serviceUuids}");
        print("\tmanufacture Data : ${scanResult.advertisementData.manufacturerData}");
        print("\tTx Power Level : ${scanResult.advertisementData.txPowerLevel}");
        print("\t${scanResult.peripheral}");

        //이미 검색된 장치인지 확인 mac 주소로 확인
        var findDevice = deviceList.any((element) {
          if(element.peripheral.identifier == scanResult.peripheral.identifier)
          {
            //이미 존재하면 기존 값을 갱신.
            element.peripheral = scanResult.peripheral;
            element.advertisementData = scanResult.advertisementData;
            element.rssi = scanResult.rssi;
            return true;
          }
          return false;
        });
        //처음 발견된 장치라면 devicelist에 추가
        if(!findDevice) {
          deviceList.add(BleDeviceItem(name, scanResult.rssi, scanResult.peripheral, scanResult.advertisementData));
        }
        //갱긴 적용.
        setState((){});
      });
      //스캔중으로 변수 변경
      setState(() { _isScanning = true; });
    }
    else {
      //스캔중이었다면 스캔 정지
      _bleManager.stopPeripheralScan();
      setState(() { _isScanning = false; });
    }
  }

  //디바이스 리스트 화면에 출력
  list() {
    return ListView.builder(
      itemCount: deviceList.length,
      itemBuilder: (context, index) {
        return ListTile(
          //디바이스 이름과 맥주소 그리고 신호 세기를 표시한다.
          title: Text(deviceList[index].deviceName),
          subtitle: Text(deviceList[index].peripheral.identifier),
          trailing: Text("${deviceList[index].rssi}"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        //디바이스 리스트 함수 호출
        child: list(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scan, //버튼이 눌리면 스캔 ON/OFF 동작
        child: Icon(_isScanning?Icons.stop:Icons.bluetooth_searching), //_isScanning 변수에 따라 아이콘 표시 변경
      ),
    );
  }
}

//디바이스 정보 저장용 클래스
class BleDeviceItem {
  String deviceName;
  Peripheral peripheral;
  int rssi;
  AdvertisementData advertisementData;
  BleDeviceItem(this.deviceName, this.rssi, this.peripheral, this.advertisementData);
}
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_alarm/Graph/graph_screen.dart';

import 'Home/home_screen.dart';
import 'Settings/settings_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '블루투스 연결',
      home: MyHomePage(title: '블루투스 연결'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;

  //페이지 구성
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          GraphScreen(),
          HomeScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
              label: '그래프', icon: Icon(CupertinoIcons.graph_circle)),
          const BottomNavigationBarItem(
              label: '홈', icon: Icon(CupertinoIcons.home)),
          const BottomNavigationBarItem(
              label: '설정', icon: Icon(CupertinoIcons.settings)),
        ],
      ),
    );
  }
}