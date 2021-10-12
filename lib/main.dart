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
      title: 'Smart Alarm',
      home: MyHomePage(title: 'Smart Alarm'),
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

  BleManager _bleManager = BleManager(); // BLE manager
  bool _isScanning = false; // 스캔중 상태 flag
  bool _connected = false; // 연결중 상태 flag
  late Peripheral _curPeripheral; // 연결된 장치 변수
  List<BleDeviceItem> deviceList = []; // BLE 장치 리스트 변수
  String _statusText = ''; // BLE 상태 변수

  @override
  void initState() {
    init();
    super.initState();
  }

  // BLE 초기화 함수
  void init() async {
    //ble 매니저 생성
    await _bleManager.createClient(
        restoreStateIdentifier: "example-restore-state-identifier",
        restoreStateAction: (peripherals) {
          peripherals.forEach((peripheral) {
            print("Restored peripheral: ${peripheral.name}");
          });
        })
        .catchError((e) => print("Couldn't create BLE client  $e"))
        .then((_) => _checkPermissions())  //매니저 생성되면 권한 확인
        .catchError((e) => print("Permission check error $e"));
  }

  // 권한 확인 함수 권한 없으면 권한 요청 화면 표시, 안드로이드만 상관 있음
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

  //장치 화면에 출력하는 위젯 함수
  list() {
    return ListView.builder(
      itemCount: deviceList.length,
      itemBuilder: (context, index) {
        return ListTile(
            title: Text(deviceList[index].deviceName),
            subtitle: Text(deviceList[index].peripheral.identifier),
            trailing: Text("${deviceList[index].rssi}"),
            onTap: () {  // 리스트중 한개를 탭(터치) 하면 해당 디바이스와 연결을 시도한다.
              connect(index);
            }
        );
      },
    );
  }
  //scan 함수
  void scan() async {
    if(!_isScanning) {
      deviceList.clear(); //기존 장치 리스트 초기화
      //SCAN 시작
      _bleManager.startPeripheralScan().listen((scanResult) {
        //listen 이벤트 형식으로 장치가 발견되면 해당 루틴을 계속 탐.
        //periphernal.name이 없으면 advertisementData.localName확인 이것도 없다면 unknown으로 표시
        var name = scanResult.peripheral.name ?? scanResult.advertisementData.localName ?? "Unknown";
        // 기존에 존재하는 장치면 업데이트
        var findDevice = deviceList.any((element) {
          if(element.peripheral.identifier == scanResult.peripheral.identifier)
          {
            element.peripheral = scanResult.peripheral;
            element.advertisementData = scanResult.advertisementData;
            element.rssi = scanResult.rssi;
            return true;
          }
          return false;
        });
        // 새로 발견된 장치면 추가
        if(!findDevice) {
          deviceList.add(BleDeviceItem(name, scanResult.rssi, scanResult.peripheral, scanResult.advertisementData));
        }
        //페이지 갱신용
        setState((){});
      });
      setState(() { //BLE 상태가 변경되면 화면도 갱신
        _isScanning = true;
        setBLEState('Scanning');
      });
    }
    else {
      //스켄중이었으면 스캔 중지
      _bleManager.stopPeripheralScan();
      setState(() { //BLE 상태가 변경되면 페이지도 갱신
        _isScanning = false;
        setBLEState('Stop Scan');
      });
    }
  }

  //BLE 연결시 예외 처리를 위한 래핑 함수
  _runWithErrorHandling(runFunction) async {
    try {
      await runFunction();
    } on BleError catch (e) {
      print("BleError caught: ${e.errorCode.value} ${e.reason}");
    } catch (e) {
      if (e is Error) {
        debugPrintStack(stackTrace: e.stackTrace);
      }
      print("${e.runtimeType}: $e");
    }
  }

  // 상태 변경하면서 페이지도 갱신하는 함수
  void setBLEState(txt){
    setState(() => _statusText = txt);
  }

  //연결 함수
  connect(index) async {
    if(_connected) {  //이미 연결상태면 연결 해제후 종료
      await _curPeripheral.disconnectOrCancelConnection();
      return;
    }

    //선택한 장치의 peripheral 값을 가져온다.
    Peripheral peripheral = deviceList[index].peripheral;

    //해당 장치와의 연결상태를 관촬하는 리스너 실행
    peripheral.observeConnectionState(emitCurrentValue: true)
        .listen((connectionState) {
      // 연결상태가 변경되면 해당 루틴을 탐.
      switch(connectionState) {
        case PeripheralConnectionState.connected: {  //연결됨
          _curPeripheral = peripheral;
          setBLEState('connected');
        }
        break;
        case PeripheralConnectionState.connecting: { setBLEState('connecting'); }//연결중
        break;
        case PeripheralConnectionState.disconnected: { //해제됨
          _connected=false;
          print("${peripheral.name} has DISCONNECTED");
          setBLEState('disconnected');
        }
        break;
        case PeripheralConnectionState.disconnecting: { setBLEState('disconnecting');}//해제중
        break;
        default:{//알수없음...
          print("unkown connection state is: \n $connectionState");
        }
        break;
      }
    });

    _runWithErrorHandling(() async {
      //해당 장치와 이미 연결되어 있는지 확인
      bool isConnected = await peripheral.isConnected();
      if(isConnected) {
        print('device is already connected');
        //이미 연결되어 있기때문에 무시하고 종료..
        return;
      }

      //연결 시작!
      await peripheral.connect().then((_) {
        //연결이 되면 장치의 모든 서비스와 캐릭터리스틱을 검색한다.
        peripheral.discoverAllServicesAndCharacteristics()
            .then((_) => peripheral.services())
            .then((services) async {
          print("PRINTING SERVICES for ${peripheral.name}");
          //각각의 서비스의 하위 캐릭터리스틱 정보를 디버깅창에 표시한다.
          for(var service in services) {
            print("Found service ${service.uuid}");
            List<Characteristic> characteristics = await service.characteristics();
            for( var characteristic in characteristics ) {
              print("${characteristic.uuid}");
            }
          }
          //모든 과정이 마무리되면 연결되었다고 표시
          _connected = true;
          print("${peripheral.name} has CONNECTED");
        });
      });
    });
  }

  Future<bool> _onBackPressed() async{

    final result = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("끝내시겠습니까?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Yes"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
            FlatButton(
              child: Text("No"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        ),
      );
      return result ?? false;
  }

  //페이지 구성
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(

            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: list(), //리스트 출력
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      RaisedButton( //scan 버튼
                        onPressed: scan,
                        child: Icon(_isScanning?Icons.stop:Icons.bluetooth_searching),
                      ),
                      SizedBox(width: 10,),
                      Text("State : "), Text(_statusText), //상태 정보 표시
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}




//BLE 장치 정보 저장 클래스
class BleDeviceItem {
  String deviceName;
  Peripheral peripheral;
  int rssi;
  AdvertisementData advertisementData;
  BleDeviceItem(this.deviceName, this.rssi, this.peripheral, this.advertisementData);
}