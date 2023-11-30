import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../base/base_view_model.dart';
import '../../../home/data/model/meditation_model.dart';
import '../../../home/data/repository/past_meditation_repository.dart';
import '../../../past_sessions/view/screens/past_sessions_page_view.dart';
import '../../../settings/view/screens/settings_page_view.dart';
import '../../../session/view/screens/session_page_view.dart';
import '../../di/Setup.dart';
import '../../settings/data/model/bluetooth_device_model.dart';
import '../../settings/data/model/settings_model.dart';
import '../../settings/data/repository/bluetooth_connection_repository.dart';
import '../../settings/data/repository/impl/settings_repository_local.dart';
import '../../settings/data/repository/settings_repository.dart';
import '../../settings/data/service/mi_band_bluetooth_service.dart';
import '../data/repository/impl/past_meditation_repository_local.dart';

@injectable
class HomePageViewModel extends BaseViewModel {
  List<MeditationModel>? _meditationData;

  final SettingsRepository _settingsRepository =
      getIt<SettingsRepositoryLocal>();
  final BluetoothConnectionRepository _bluetoothRepository =
      getIt<MiBandBluetoothService>();
  final MeditationRepository _meditationRepository =
      getIt<MeditationRepositoryLocal>();

  SettingsModel? _settingsModel;

  bool get deviceIsConfigured => _isConfigured;

  Color get watchIconColor => _watchIconColor ?? Colors.red;

  bool get skippedSetup => _skippedSetup;

  List<BluetoothDeviceModel>? get systemDevices => _systemDevices;
  late bool _isConfigured;
  List<BluetoothDeviceModel>? _systemDevices;
  bool _skippedSetup = false;

  String _appbarText = "";

  String get appbarText => _appbarText;

  int get meditationDataCount => _meditationData?.length ?? 0;
  Color? _watchIconColor;

  @override
  void init() async {
    _isConfigured = _bluetoothRepository.isConfigured();
    _systemDevices = await _bluetoothRepository.getSystemDevices();
    _settingsModel = await _settingsRepository.getSettings();
    _meditationData = await _meditationRepository.getAllMeditation();
    if (_isConfigured) {
      _connectToDeviceAndListenForStatus();
    }
    notifyListeners();
  }

  HomePageViewModel() {
    _appbarText = _getGreetingForCurrentTime();
  }

  void navigateToSession(var context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SessionPageView()),
    );
  }

  void navigateToSessionSummary(var context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PastSessionsPageView()),
    );
  }

  void navigateToSettings(var context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SettingsPageView()),
    );
  }

  void skipSetup() {
    debugPrint("skipping setup");
    _skippedSetup = true;
    notifyListeners();
  }

  void selectBluetoothDevice(BluetoothDeviceModel bluetoothDevice) async {
    await _bluetoothRepository.setDevice(bluetoothDevice);
    _isConfigured = true;
    _connectToDeviceAndListenForStatus();
    notifyListeners();
  }

  void _connectToDeviceAndListenForStatus() async {
    if (_isConfigured) {
      await _bluetoothRepository.connectToDevice();
      _setWatchIconColorByStatus();
    }
  }

  String _getGreetingForCurrentTime() {
    final hour = DateTime.now().hour;
    if (hour > 6 && hour < 12) {
      return "Good Morning";
    } else if (hour < 18) {
      return "Good Afternoon";
    } else if (hour < 22) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  void _setWatchIconColorByStatus() async {
    Stream<MiBandConnectionState>? statusStream =
        await _bluetoothRepository.getConnectionState();
    if (statusStream != null) {
      statusStream.listen((status) {
        if (status == MiBandConnectionState.connected) {
          _watchIconColor = Colors.green;
        } else if (status == MiBandConnectionState.disconnected) {
          _watchIconColor = Colors.orange;
        }
        notifyListeners();
      });
    }
  }
}
