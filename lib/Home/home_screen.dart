import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';

//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//
//   BleManager _bleManager = BleManager(); // BLE manager
//   bool _isScanning = false; // 스캔중 상태 flag
//   bool _connected = false; // 연결중 상태 flag
//   late Peripheral _curPeripheral; // 연결된 장치 변수
//   List<BleDeviceItem> deviceList = []; // BLE 장치 리스트 변수
//   String _statusText = ''; // BLE 상태 변수
//
//   @override
//   void initState() {
//     init();
//     super.initState();
//   }
//
//   // BLE 초기화 함수
//   void init() async {
//     //ble 매니저 생성
//     await _bleManager.createClient(
//         restoreStateIdentifier: "example-restore-state-identifier",
//         restoreStateAction: (peripherals) {
//           peripherals.forEach((peripheral) {
//             print("Restored peripheral: ${peripheral.name}");
//           });
//         })
//         .catchError((e) => print("Couldn't create BLE client  $e"))
//         .then((_) => _checkPermissions()) //매니저 생성되면 권한 확인
//         .catchError((e) => print("Permission check error $e"));
//   }
//
//   // 권한 확인 함수 권한 없으면 권한 요청 화면 표시, 안드로이드만 상관 있음
//   _checkPermissions() async {
//     if (Platform.isAndroid) {
//       if (await Permission.contacts
//           .request()
//           .isGranted) {}
//       Map<Permission, PermissionStatus> statuses = await [
//         Permission.location
//       ].request();
//       print(statuses[Permission.location]);
//     }
//   }
//
//   //장치 화면에 출력하는 위젯 함수
//   list() {
//     return ListView.builder(
//       itemCount: deviceList.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//             title: Text(deviceList[index].deviceName),
//             //subtitle: Text(deviceList[index].peripheral.identifier),
//             subtitle: Text(
//                 deviceList[index].advertisementData.serviceUuids.toString()),
//             trailing: Text("${deviceList[index].rssi}"),
//             onTap: () { // 리스트중 한개를 탭(터치) 하면 해당 디바이스와 연결을 시도한다.
//               connect(index);
//             }
//         );
//       },
//     );
//   }
//
//   //scan 함수
//   void scan() async {
//     if (!_isScanning) {
//       deviceList.clear(); //기존 장치 리스트 초기화
//       //SCAN 시작
//       _bleManager.startPeripheralScan().listen((scanResult) {
//         //listen 이벤트 형식으로 장치가 발견되면 해당 루틴을 계속 탐.
//         //periphernal.name이 없으면 advertisementData.localName확인 이것도 없다면 unknown으로 표시
//         var name = scanResult.peripheral.name ??
//             scanResult.advertisementData.localName ?? "Unknown";
//         // 기존에 존재하는 장치면 업데이트
//         var findDevice = deviceList.any((element) {
//           if (element.peripheral.identifier ==
//               scanResult.peripheral.identifier) {
//             element.peripheral = scanResult.peripheral;
//             element.advertisementData = scanResult.advertisementData;
//             element.rssi = scanResult.rssi;
//             return true;
//           }
//           return false;
//         });
//         // 새로 발견된 장치면 추가
//         if (!findDevice) {
//           deviceList.add(BleDeviceItem(
//               name, scanResult.rssi, scanResult.peripheral,
//               scanResult.advertisementData));
//         }
//         //페이지 갱신용
//         setState(() {});
//       });
//       setState(() { //BLE 상태가 변경되면 화면도 갱신
//         _isScanning = true;
//         setBLEState('Scanning');
//       });
//     }
//     else {
//       //스켄중이었으면 스캔 중지
//       _bleManager.stopPeripheralScan();
//       setState(() { //BLE 상태가 변경되면 페이지도 갱신
//         _isScanning = false;
//         setBLEState('Stop Scan');
//       });
//     }
//   }
//
//   //BLE 연결시 예외 처리를 위한 래핑 함수
//   _runWithErrorHandling(runFunction) async {
//     try {
//       await runFunction();
//     } on BleError catch (e) {
//       print("BleError caught: ${e.errorCode.value} ${e.reason}");
//     } catch (e) {
//       if (e is Error) {
//         debugPrintStack(stackTrace: e.stackTrace);
//       }
//       print("${e.runtimeType}: $e");
//     }
//   }
//
//   // 상태 변경하면서 페이지도 갱신하는 함수
//   void setBLEState(txt) {
//     setState(() => _statusText = txt);
//   }
//
//   //연결 함수
//   connect(index) async {
//     if (_connected) { //이미 연결상태면 연결 해제후 종료
//       await _curPeripheral.disconnectOrCancelConnection();
//       return;
//     }
//
//     //선택한 장치의 peripheral 값을 가져온다.
//     Peripheral peripheral = deviceList[index].peripheral;
//
//     //해당 장치와의 연결상태를 관촬하는 리스너 실행
//     peripheral.observeConnectionState(emitCurrentValue: true)
//         .listen((connectionState) {
//       // 연결상태가 변경되면 해당 루틴을 탐.
//       switch (connectionState) {
//         case PeripheralConnectionState.connected:
//           { //연결됨
//             _curPeripheral = peripheral;
//             setBLEState('connected');
//           }
//           break;
//         case PeripheralConnectionState.connecting:
//           {
//             setBLEState('connecting');
//           } //연결중
//           break;
//         case PeripheralConnectionState.disconnected:
//           { //해제됨
//             _connected = false;
//             print("${peripheral.name} has DISCONNECTED");
//             setBLEState('disconnected');
//           }
//           break;
//         case PeripheralConnectionState.disconnecting:
//           {
//             setBLEState('disconnecting');
//           } //해제중
//           break;
//         default:
//           { //알수없음...
//             print("unkown connection state is: \n $connectionState");
//           }
//           break;
//       }
//     });
//
//     _runWithErrorHandling(() async {
//       //해당 장치와 이미 연결되어 있는지 확인
//       bool isConnected = await peripheral.isConnected();
//       if (isConnected) {
//         print('device is already connected');
//         //이미 연결되어 있기때문에 무시하고 종료..
//         return;
//       }
//
//       //연결 시작!
//       await peripheral.connect().then((_) {
//         //연결이 되면 장치의 모든 서비스와 캐릭터리스틱을 검색한다.
//         peripheral.discoverAllServicesAndCharacteristics()
//             .then((_) => peripheral.services())
//             .then((services) async {
//           print("PRINTING SERVICES for ${peripheral.name}");
//           //각각의 서비스의 하위 캐릭터리스틱 정보를 디버깅창에 표시한다.
//           for (var service in services) {
//             print("Found service ${service.uuid}");
//             List<Characteristic> characteristics = await service
//                 .characteristics();
//             for (var characteristic in characteristics) {
//               print("${characteristic.uuid}");
//             }
//           }
//           //모든 과정이 마무리되면 연결되었다고 표시
//           _connected = true;
//           print("${peripheral.name} has CONNECTED");
//         });
//       });
//     });
//   }
//
//     @override
//     Widget build(BuildContext context) {
//       return new WillPopScope(
//           onWillPop: _onBackPressed,
//           child: Scaffold(
//               appBar: AppBar(
//                 title: Text('smartAlarm'),
//               ),
//               body: Center(
//                 child: Column(
//                     children: <Widget>[
//                       Expanded(
//                         flex: 1,
//                         child: list(), //리스트 출력
//                       ),
//                       Container(
//                         child: Row(
//                           children: <Widget>[
//                             ElevatedButton( //scan 버튼
//                               onPressed: scan,
//                               child: Icon(_isScanning ? Icons.stop : Icons
//                                   .bluetooth_searching),
//                             ),
//                             SizedBox(width: 10,),
//                             Text("State : "), Text(_statusText), //상태 정보 표시
//                           ],
//                         ),
//                       ),
//                     ]
//                 ),
//               )
//           )
//       );
//     }
//
//   Future<bool> _onBackPressed() async {
//     final result = await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("끝내시겠습니까?"),
//         actions: <Widget>[
//           TextButton(
//             child: Text("Yes"),
//             onPressed: () => Navigator.of(context).pop(true),
//           ),
//           TextButton(
//             child: Text("No"),
//             onPressed: () => Navigator.of(context).pop(false),
//           ),
//         ],
//       ),
//     );
//     return result ?? false;
//   }
// }
//
//
//
// //BLE 장치 정보 저장 클래스
// class BleDeviceItem {
//   String deviceName;
//   Peripheral peripheral;
//
//   int rssi;
//   AdvertisementData advertisementData;
//
//   BleDeviceItem(this.deviceName, this.rssi, this.peripheral,
//       this.advertisementData);
// }
//

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  //final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> scanResultList = [];
  bool _isScanning = false;

  @override
  initState() {
    super.initState();
    // 블루투스 초기화
    initBle();
  }

  void initBle() {
    // BLE 스캔 상태 얻기 위한 리스너
    flutterBlue.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      setState(() {});
    });
  }

  /*
  스캔 시작/정지 함수
  */
  scan() async {
    if (!_isScanning) {
      // 스캔 중이 아니라면
      // 기존에 스캔된 리스트 삭제
      scanResultList.clear();
      // 스캔 시작, 제한 시간 4초
      flutterBlue.startScan(timeout: Duration(seconds: 4));
      // 스캔 결과 리스너
      flutterBlue.scanResults.listen((results) {
        // List<ScanResult> 형태의 results 값을 scanResultList에 복사
        scanResultList = results;
        // UI 갱신
        setState(() {});
      });
    } else {
      // 스캔 중이라면 스캔 정지
      flutterBlue.stopScan();
    }
  }

  /*
   여기서부터는 장치별 출력용 함수들
  */
  /*  장치의 신호값 위젯  */
  Widget deviceSignal(ScanResult r) {
    return Text(r.rssi.toString());
  }

  /* 장치의 MAC 주소 위젯  */
  Widget deviceMacAddress(ScanResult r) {
    return Text(r.device.id.id);
  }

  /* 장치의 명 위젯  */
  Widget deviceName(ScanResult r) {
    String name = '';

    if (r.device.name.isNotEmpty) {
      // device.name에 값이 있다면
      name = r.device.name;
    } else if (r.advertisementData.localName.isNotEmpty) {
      // advertisementData.localName에 값이 있다면
      name = r.advertisementData.localName;
    } else {
      // 둘다 없다면 이름 알 수 없음...
      name = 'N/A';
    }
    return Text(name);
  }

  /* BLE 아이콘 위젯 */
  Widget leading(ScanResult r) {
    return CircleAvatar(
      child: Icon(
        Icons.bluetooth,
        color: Colors.white,
      ),
      backgroundColor: Colors.cyan,
    );
  }

  /* 장치 아이템을 탭 했을때 호출 되는 함수 */
  void onTap(ScanResult r) {
    // 단순히 이름만 출력
    print('${r.device.name}');
  }

  /* 장치 아이템 위젯 */
  Widget listItem(ScanResult r) {
    return ListTile(
      onTap: () => onTap(r),
      leading: leading(r),
      title: deviceName(r),
      subtitle: deviceMacAddress(r),
      trailing: deviceSignal(r),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('블루투스 연결'),
      ),
      body: Center(
        /* 장치 리스트 출력 */
        child: ListView.separated(
          itemCount: scanResultList.length,
          itemBuilder: (context, index) {
            return listItem(scanResultList[index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
        ),
      ),
      /* 장치 검색 or 검색 중지  */
      floatingActionButton: FloatingActionButton(
        onPressed: scan,
        // 스캔 중이라면 stop 아이콘을, 정지상태라면 search 아이콘으로 표시
        child: Icon(_isScanning ? Icons.stop : Icons.search),
      ),
    );
  }
}
