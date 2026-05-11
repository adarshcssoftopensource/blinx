import 'dart:io';
import 'dart:math';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:blinx_mobile/social_pulse_screen/bluetooth_screen/model/bluetooth_model.dart';
import 'package:blinx_mobile/social_pulse_screen/bluetooth_screen/services/bluetooth_services.dart'
    as blinx;
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BluetoothController extends GetxController {
  final isBluetoothOn = false.obs;
  final isScanning = false.obs;
  final isTogglingOn = false.obs;
  final nearbyBlinxUsers = <NearbyBlinxUser>[].obs;

  final blinx.BlinxBluetoothService _service = blinx.BlinxBluetoothService();
  bool _isToggling = false;

  Future<String> getMyBluetoothId() async {
    final prefs = await SharedPreferences.getInstance();
    String? existingId = prefs.getString('my_bluetooth_id');
    if (existingId != null) return existingId;

    final random = Random();
    String randomMac = List.generate(6, (_) {
      return random
          .nextInt(256)
          .toRadixString(16)
          .padLeft(2, '0')
          .toUpperCase();
    }).join(':');

    await prefs.setString('my_bluetooth_id', randomMac);
    return randomMac;
  }

  Future<Position?> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> registerMyDevice() async {
    try {
      final myBluetoothId = await getMyBluetoothId();
      final position = await getCurrentLocation();

      await _service.registerDevice({
        "bluetoothId": myBluetoothId,
        "deviceName": Platform.isIOS ? "iPhone" : "Android",
        "latitude": position?.latitude ?? 0.0,
        "longitude": position?.longitude ?? 0.0,
      });
    } catch (e) {}
  }

  Future<void> deregisterMyDevice() async {
    try {
      await _service.deregisterDevice();
    } catch (e) {}
  }

  Future<void> fetchNearbyUsers() async {
    try {
      isScanning.value = true;
      final position = await getCurrentLocation();
      final lat = position?.latitude ?? 0.0;
      final lng = position?.longitude ?? 0.0;
      final users = await _service.fetchNearbyUsers(lat, lng);
      nearbyBlinxUsers.value = users;
    } catch (e) {
    } finally {
      isScanning.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();

    _autoEnableBluetooth();

    FlutterBluePlus.adapterState.listen((state) async {
      if (state == BluetoothAdapterState.turningOn ||
          state == BluetoothAdapterState.turningOff)
        return;

      final isOn = state == BluetoothAdapterState.on;
      isBluetoothOn.value = isOn;
      isTogglingOn.value = false;
      _isToggling = false;

      if (!isOn) {
        nearbyBlinxUsers.clear();
        isScanning.value = false;
        await deregisterMyDevice();
      } else {
        isBluetoothOn.value = true;
        await registerMyDevice();
        await fetchNearbyUsers();
      }
    });
  }

  Future<void> _autoEnableBluetooth() async {
    try {
      if (Platform.isIOS) return;

      final state = await FlutterBluePlus.adapterState.first;

      if (state == BluetoothAdapterState.on) {
        return;
      }

      final connectStatus = await Permission.bluetoothConnect.status;
      final scanStatus = await Permission.bluetoothScan.status;

      if (!connectStatus.isGranted || !scanStatus.isGranted) {
        await [
          Permission.bluetooth,
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
        ].request();
      }

      await FlutterBluePlus.turnOn();
    } catch (e) {}
  }

  Future<bool> _ensureBluetoothPermissions() async {
    final connectStatus = await Permission.bluetoothConnect.status;
    final scanStatus = await Permission.bluetoothScan.status;

    if (connectStatus.isGranted && scanStatus.isGranted) return true;

    if (connectStatus.isPermanentlyDenied || scanStatus.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    final results = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();

    final allGranted = results.values.every((s) => s.isGranted);

    if (!allGranted) {
      await openAppSettings();
      return false;
    }

    return true;
  }

  Future<void> toggleBluetooth(bool value) async {
    if (_isToggling) {
      return;
    }

    _isToggling = true;
    isTogglingOn.value = true;

    try {
      if (Platform.isIOS) {
        await FlutterBluePlus.turnOn().catchError((_) async {
          await openAppSettings();
        });
        return;
      }

      if (value) {
        final connectStatus = await Permission.bluetoothConnect.status;
        final scanStatus = await Permission.bluetoothScan.status;

        final granted = await _ensureBluetoothPermissions();

        if (!granted) {
          return;
        }
        try {
          await FlutterBluePlus.turnOn();
          await Future.delayed(const Duration(seconds: 2));

          final state = await FlutterBluePlus.adapterState.first;

          if (state != BluetoothAdapterState.on) {
            final intent = AndroidIntent(
              action: 'android.bluetooth.adapter.action.REQUEST_ENABLE',
              flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
            );
            await intent.launch();
          }
        } catch (e) {
          final intent = AndroidIntent(
            action: 'android.bluetooth.adapter.action.REQUEST_ENABLE',
            flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
          );
          await intent.launch();
        }
      } else {
        nearbyBlinxUsers.clear();
        isScanning.value = false;
        isBluetoothOn.value = false;
        await Future.delayed(const Duration(milliseconds: 500));

        try {
          await FlutterBluePlus.turnOff();
          await Future.delayed(const Duration(milliseconds: 500));
        } catch (e) {}
      }
    } catch (e) {
      await openAppSettings();
    } finally {
      _isToggling = false;
      isTogglingOn.value = false;
    }
  }
}
