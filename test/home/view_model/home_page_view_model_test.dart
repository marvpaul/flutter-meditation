import 'dart:async';
import 'package:flutter_meditation/di/Setup.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/home/data/repository/impl/all_meditations_repository_local.dart';
import 'package:flutter_meditation/home/view_model/home_page_view_model.dart';
import 'package:flutter_meditation/past_sessions/data/repository/impl/past_sessions_middleware_repository.dart';
import 'package:flutter_meditation/session/data/repository/impl/session_parameter_optimization_middleware_repository.dart';
import 'package:flutter_meditation/settings/data/model/bluetooth_device_model.dart';
import 'package:flutter_meditation/settings/data/model/settings_model.dart';
import 'package:flutter_meditation/settings/data/repository/bluetooth_connection_repository.dart';
import 'package:flutter_meditation/settings/data/repository/impl/settings_repository_local.dart';
import 'package:flutter_meditation/settings/data/service/mi_band_bluetooth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSettingsRepositoryLocal extends Mock
    implements SettingsRepositoryLocal {}

class MockAllMeditationsRepositoryLocal extends Mock
    implements AllMeditationsRepositoryLocal {}

class MockPastSessionsMiddlewareRepository extends Mock
    implements PastSessionsMiddlewareRepository {
  final StreamController<List<MeditationModel>> _pastSessionsController =
      StreamController<List<MeditationModel>>.broadcast();

  @override
  Stream<List<MeditationModel>> get pastSessionsStream =>
      _pastSessionsController.stream;
}

class MockSessionParameterOptimizationMiddlewareRepository extends Mock
    implements SessionParameterOptimizationMiddlewareRepository {
  final StreamController<bool> _aiModeAvailableController =
      StreamController<bool>.broadcast();
  final StreamController<bool> _isAiModeEnabledController =
      StreamController<bool>.broadcast();

  @override
  Stream<bool> get isAiModeAvailable => _aiModeAvailableController.stream;
  @override
  Stream<bool> get isAiModeEnabled => _isAiModeEnabledController.stream;
}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockBluetoothService extends Mock implements MiBandBluetoothService {
  // Mock the behavior of getConnectionState
  Future<Stream<MiBandConnectionState>> getConnectionState() async {
    final controller = StreamController<MiBandConnectionState>();

    // Add some initial value to the stream if needed
    controller.add(MiBandConnectionState.connected);

    // Return the stream
    return controller.stream;
  }

  @override
  Future<void> setDevice(BluetoothDeviceModel bluetoothDevice) async {}
}

void main() async {
  late MockSharedPreferences mockSharedPreferences;
  late MockSettingsRepositoryLocal mockSettingsRepository;
  late MockAllMeditationsRepositoryLocal mockAllMeditationsRepository;
  late MockPastSessionsMiddlewareRepository
      mockPastSessionsMiddlewareRepository;
  late MockBluetoothService mockBluetoothService;
  late MockSessionParameterOptimizationMiddlewareRepository
      mockSessionParameterOptimizationMiddlewareRepository;
  late HomePageViewModel viewModel;
  late SettingsModel settings;
  late BluetoothDeviceModel deviceModel;

  setUpAll(() async {
    mockSharedPreferences = MockSharedPreferences();
    getIt.registerSingleton<SharedPreferences>(mockSharedPreferences);
    mockSessionParameterOptimizationMiddlewareRepository =
        MockSessionParameterOptimizationMiddlewareRepository();
    getIt.registerSingleton<SessionParameterOptimizationMiddlewareRepository>(
        mockSessionParameterOptimizationMiddlewareRepository);

    mockAllMeditationsRepository = MockAllMeditationsRepositoryLocal();
    getIt.registerSingleton<AllMeditationsRepositoryLocal>(
        mockAllMeditationsRepository);
    mockPastSessionsMiddlewareRepository =
        MockPastSessionsMiddlewareRepository();
    getIt.registerSingleton<PastSessionsMiddlewareRepository>(
        mockPastSessionsMiddlewareRepository);
    mockSettingsRepository = MockSettingsRepositoryLocal();
    getIt.registerSingleton<SettingsRepositoryLocal>(mockSettingsRepository);
    mockBluetoothService = MockBluetoothService();
    getIt.registerSingleton<MiBandBluetoothService>(mockBluetoothService);

    viewModel = HomePageViewModel();
    settings = SettingsModel(isHapticFeedbackEnabled: true, uuid: '123');
    deviceModel = BluetoothDeviceModel(macAddress: "", advName: "");

    mockSessionParameterOptimizationMiddlewareRepository
        ._aiModeAvailableController
        .add(false);
    mockSessionParameterOptimizationMiddlewareRepository
        ._isAiModeEnabledController
        .add(false);
    // Mock the behavior of getSystemDevices
    when(() => mockBluetoothService.getSystemDevices()).thenAnswer((_) async {
      // Return your mocked Bluetooth devices here
      return [deviceModel];
    });
    when(() => mockAllMeditationsRepository.getAllMeditation())
        .thenAnswer((_) async {
      // Return your mocked Bluetooth devices here
      return [];
    });

    when(() => mockSettingsRepository.getSettings())
        .thenAnswer((_) => Future(() => settings));
    when(() => mockBluetoothService.isConfigured()).thenAnswer((_) => true);
  });
  group('HomePageViewModel', () {
    test('initialize view model and test if we can generate a welcome message.',
        () async {
      await viewModel.init();
      viewModel.selectBluetoothDevice(deviceModel);
      viewModel.skipSetup();
      viewModel.changeAiMode(false);
      expect(viewModel.appbarText.contains("Good"), true);
      expect(viewModel.deviceIsConfigured, true);
    });
  });

  tearDown(() {
    // Close the correct stream controller
    mockSessionParameterOptimizationMiddlewareRepository
        ._aiModeAvailableController
        .close();
    mockSessionParameterOptimizationMiddlewareRepository
        ._isAiModeEnabledController
        .close();
  });
}
