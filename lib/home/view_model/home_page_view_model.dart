/// {@category ViewModel}
/// ViewModel for the home page. Here we want to show if the user is connected to a device and
/// offer options to navigate to the settings page or start a new meditation session.
library home_page_view_model;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_meditation/session/data/repository/session_parameter_optimization_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../base/base_view_model.dart';
import '../../../home/data/model/meditation_model.dart';
import '../../../past_sessions/view/screens/past_sessions_page_view.dart';
import '../../../settings/view/screens/settings_page_view.dart';
import '../../../session/view/screens/session_page_view.dart';
import '../../di/Setup.dart';
import '../../past_sessions/data/repository/impl/past_sessions_middleware_repository.dart';
import '../../past_sessions/data/repository/past_sessions_repository.dart';
import '../../session/data/repository/impl/session_parameter_optimization_middleware_repository.dart';
import '../../settings/data/model/bluetooth_device_model.dart';
import '../../settings/data/repository/bluetooth_connection_repository.dart';
import '../../settings/data/service/mi_band_bluetooth_service.dart';
import '../data/repository/impl/all_meditations_repository_local.dart';

@injectable
class HomePageViewModel extends BaseViewModel {
  List<MeditationModel>? get meditations => _allMeditationsModel;
  List<MeditationModel>? _allMeditationsModel;

  int get pastSessionsCount => _pastSessionsCount;
  int _pastSessionsCount = 0;

  final AllMeditationsRepositoryLocal _meditationRepository =
      getIt<AllMeditationsRepositoryLocal>();
  final BluetoothConnectionRepository _bluetoothRepository =
      getIt<MiBandBluetoothService>();

  final PastSessionsRepository _pastSessionsRepository =
      getIt<PastSessionsMiddlewareRepository>();
  final SessionParameterOptimizationRepository
      _sessionParameterOptimizationRepository =
      getIt<SessionParameterOptimizationMiddlewareRepository>();

  bool get deviceIsConfigured => _isConfigured;

  Color get watchIconColor => _watchIconColor ?? Colors.red;

  bool get skippedSetup => _skippedSetup;

  bool get isAiModeAvailable =>
      _isAiModeAvailable &&
      _connectionStatus == MiBandConnectionState.connected;

  List<BluetoothDeviceModel>? get systemDevices => _systemDevices;
  late bool _isConfigured;
  List<BluetoothDeviceModel>? _systemDevices;
  bool _skippedSetup = false;
  MiBandConnectionState _connectionStatus = MiBandConnectionState.unconfigured;

  String _appbarText = "";
  final String setupWatchText = "Watch Setup";

  String get appbarText => _appbarText;
  Color? _watchIconColor;

  bool _isAiModeAvailable = false;
  bool isAiModeEnabled = false;
  final Set<StreamSubscription> _subscriptions = {};

  HomePageViewModel() {
    _appbarText = _getGreetingForCurrentTime();
  }

  @override
  Future<void> init() async {
    _isConfigured = _bluetoothRepository.isConfigured();
    _systemDevices = await _bluetoothRepository.getSystemDevices();
    _subscribeToPastSessionsStream();
    _allMeditationsModel = await _meditationRepository.getAllMeditation();
    try {
      _pastSessionsRepository.fetchMeditationSessions();
    } catch (e) {
      print(e);
    }
    if (_isConfigured) {
      _listenForWatchStatus();
      _subscribeToAiModeAvailableAndState();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
    super.dispose();
  }

  /// A stream which contains all previously finished sessions
  void _subscribeToPastSessionsStream() {
    StreamSubscription subscription = _meditationRepository.meditationStream
        .map((event) => event?.length ?? 0)
        .listen(
      (int count) {
        _pastSessionsCount = count;
        notifyListeners();
      },
      onError: (error) {
        // Handle any errors here
      },
    );
    _subscriptions.add(subscription);
  }

  void _subscribeToAiModeAvailableAndState() {
    StreamSubscription availabilitySubscription =
        _sessionParameterOptimizationRepository.isAiModeAvailable
            .listen((event) {
      _isAiModeAvailable = event;
      notifyListeners();
    });
    _subscriptions.add(availabilitySubscription);
    StreamSubscription stateSubscription =
        _sessionParameterOptimizationRepository.isAiModeEnabled.listen((event) {
      isAiModeEnabled = event;
      notifyListeners();
    });
    _subscriptions.add(stateSubscription);
  }

  /// Navigate to our session view page where the user can meditate
  void navigateToSession(var context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SessionPageView()),
    );
  }

  /// Navigate to session summary page where the user can see all previous meditations.
  void navigateToSessionSummary(var context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PastSessionsPageView()),
    );
  }

  void navigateToSettings(var context) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(builder: (context) => SettingsPageView()),
    )
        .whenComplete(() {
      _isConfigured = _bluetoothRepository.isConfigured();
      notifyListeners();
    });
  }

  void skipSetup() {
    _skippedSetup = true;
    notifyListeners();
  }

  /// Select a bluetooth device / miBand to pair. The user will be asked during first app startup to select a device.
  void selectBluetoothDevice(BluetoothDeviceModel bluetoothDevice) async {
    await _bluetoothRepository.setDevice(bluetoothDevice);
    _isConfigured = true;
    _listenForWatchStatus();
    notifyListeners();
  }

  /// Stream which returns if the bluetooth device / fitness tracker is actually connected to our device.
  void _listenForWatchStatus() async {
    Stream<MiBandConnectionState>? statusStream =
        await _bluetoothRepository.getConnectionState();
    if (statusStream != null) {
      statusStream.listen((status) async {
        _connectionStatus = status;
        if (status == MiBandConnectionState.connected) {
          _watchIconColor = Colors.green;
        } else if (status == MiBandConnectionState.disconnected) {
          _watchIconColor = Colors.orange;
          await _bluetoothRepository.connectToDevice();
        }
        notifyListeners();
      });
    }
  }

  /// Get's a proper greeting string for our home screen
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

  /// Toggle the AI option to enable prediction of meditation parameters via ML model
  void changeAiMode(bool isEnabled) {
    _sessionParameterOptimizationRepository.changeAiMode(isEnabled);
  }
}
