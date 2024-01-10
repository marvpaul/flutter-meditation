import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_meditation/di/Setup.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/home/data/repository/impl/all_meditations_repository_local.dart';
import 'package:flutter_meditation/home/data/repository/impl/meditation_repository_local.dart';
import 'package:flutter_meditation/past_sessions/data/repository/impl/past_sessions_middleware_repository.dart';
import 'package:flutter_meditation/session/data/repository/impl/binaural_beats_repository_local.dart';
import 'package:flutter_meditation/session/data/repository/impl/breathing_pattern_repository_local.dart';
import 'package:flutter_meditation/session/data/repository/impl/session_parameter_optimization_middleware_repository.dart';
import 'package:flutter_meditation/session/data/service/meditation_session_validation_service.dart';
import 'package:flutter_meditation/session/view_model/session_page_view_model.dart';
import 'package:flutter_meditation/settings/data/model/bluetooth_device_model.dart';
import 'package:flutter_meditation/settings/data/model/settings_model.dart';
import 'package:flutter_meditation/settings/data/repository/bluetooth_connection_repository.dart';
import 'package:flutter_meditation/settings/data/repository/impl/settings_repository_local.dart';
import 'package:flutter_meditation/settings/data/service/mi_band_bluetooth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MockSettingsRepositoryLocal extends Mock
    implements SettingsRepositoryLocal {}

class MockAllMeditationsRepositoryLocal extends Mock
    implements AllMeditationsRepositoryLocal {}

class MockBinauralBeatsRepositoryLocal extends Mock
    implements BinauralBeatsRepositoryLocal {}

class MockMeditationSessionValidationService extends Mock
    implements MeditationSessionValidationService {}

class MockBuildContext extends Mock implements BuildContext {}

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
  final BehaviorSubject<bool> _aiModeAvailableSubject = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _isAiModeEnabledSubject = BehaviorSubject<bool>.seeded(false);

  @override
  Stream<bool> get isAiModeAvailable => _aiModeAvailableSubject.stream;
  @override
  Stream<bool> get isAiModeEnabled => _isAiModeEnabledSubject.stream;
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
  late MockBuildContext _mockContext;
  late MockSharedPreferences mockSharedPreferences;
  late MockBinauralBeatsRepositoryLocal mockBinauralBeatsRepositoryLocal;
  late MockSettingsRepositoryLocal mockSettingsRepository;
  late MockAllMeditationsRepositoryLocal mockAllMeditationsRepository;
  late BreathingPatternRepositoryLocal breathingPatternRepositoryLocal;
  late MeditationRepositoryLocal meditationRepositoryLocal;
  late MockMeditationSessionValidationService
      mockMeditationSessionValidationService;
  late MockPastSessionsMiddlewareRepository
      mockPastSessionsMiddlewareRepository;
  late MockBluetoothService mockBluetoothService;
  late MockSessionParameterOptimizationMiddlewareRepository
      mockSessionParameterOptimizationMiddlewareRepository;
  late SessionPageViewModel viewModel;
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

    meditationRepositoryLocal =
        MeditationRepositoryLocal(mockSharedPreferences);
    getIt.registerSingleton<MeditationRepositoryLocal>(
        meditationRepositoryLocal);

    breathingPatternRepositoryLocal =
        BreathingPatternRepositoryLocal(mockSharedPreferences);
    getIt.registerSingleton<BreathingPatternRepositoryLocal>(
        breathingPatternRepositoryLocal);

    mockMeditationSessionValidationService =
        MockMeditationSessionValidationService();
    getIt.registerSingleton<MeditationSessionValidationService>(
        mockMeditationSessionValidationService);

    mockBinauralBeatsRepositoryLocal = MockBinauralBeatsRepositoryLocal();
    getIt.registerSingleton<BinauralBeatsRepositoryLocal>(
        mockBinauralBeatsRepositoryLocal);

    viewModel = SessionPageViewModel();
    settings = SettingsModel(isHapticFeedbackEnabled: true, uuid: '123');
    deviceModel = BluetoothDeviceModel(macAddress: "", advName: "");
    _mockContext = MockBuildContext();

    when(() => mockSharedPreferences.getString(any())).thenReturn(null);
    when(() => mockSharedPreferences.setString(any(), any()))
        .thenAnswer((_) => Future(() => true));

    mockSessionParameterOptimizationMiddlewareRepository
        ._aiModeAvailableSubject
        .add(false);

    mockSessionParameterOptimizationMiddlewareRepository
        ._isAiModeEnabledSubject
        .add(false);

    when(() => mockBluetoothService.getSystemDevices()).thenAnswer((_) async {
      return [deviceModel];
    });

    when(() => mockBinauralBeatsRepositoryLocal.playBinauralBeats(
        any<double>(), any<double>(), any<double>())).thenAnswer((_) async {
      return true;
    });

    when(() => mockBinauralBeatsRepositoryLocal.stopBinauralBeats())
        .thenAnswer((_) async {
      return true;
    });

    when(() => mockBluetoothService.isAvailableAndConnected())
        .thenAnswer((_) => false);
    when(() => mockAllMeditationsRepository.getAllMeditation())
        .thenAnswer((_) async {
      return [];
    });

    when(() => mockSettingsRepository.getSettings())
        .thenAnswer((_) => Future(() => settings));
    when(() => mockBluetoothService.isConfigured()).thenAnswer((_) => true);
  });

  tearDown(() {
    // Close the correct stream controller
    mockSessionParameterOptimizationMiddlewareRepository
        ._aiModeAvailableSubject
        .close();
    mockSessionParameterOptimizationMiddlewareRepository
        ._isAiModeEnabledSubject
        .close();
  });
  group('Session page view model', () {
    test('initialize view model, start running a session and cancel it finally',
        () async {
      await viewModel.initWithContext(_mockContext);

      expect(viewModel.running, true);

      viewModel.cancelSession();
      expect(viewModel.running, false);
    });

    test('get random parameters', () async {
      await viewModel.initWithContext(_mockContext);
      viewModel.updateHeartRate();
      expect(viewModel.running, true);

      int beatFreq = viewModel.getRandomBinauralBeats();
      expect(beatFreq >= 2 && beatFreq <= 30, true);

      double randomBreathingMultiplier =
          viewModel.getRandomBreathingMultiplier();
      expect(
          randomBreathingMultiplier >= 0.5 && randomBreathingMultiplier <= 1.5,
          true);
    });

    test('next state', () async {
      await viewModel.initWithContext(_mockContext);
      expect(viewModel.running, true);

      viewModel.nextState();
      expect(viewModel.stateCounter, 1);
    });
  });
}
