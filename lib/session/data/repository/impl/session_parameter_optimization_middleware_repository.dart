import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../past_sessions/data/repository/impl/past_sessions_middleware_repository.dart';
import '../../../../past_sessions/data/repository/past_sessions_repository.dart';
import '../session_parameter_optimization_repository.dart';

@singleton
@injectable
class SessionParameterOptimizationMiddlewareRepository implements SessionParameterOptimizationRepository {

  final String _preferenceKey = 'isAiModeEnabled';
  final bool _defaultValueForAiMode = true;

  final PastSessionsRepository _pastSessionsRepository;
  final SharedPreferences _sharedPreferences;

  SessionParameterOptimizationMiddlewareRepository(this._pastSessionsRepository, this._sharedPreferences) {
    bool? isAiModeEnabled = _sharedPreferences.getBool(_preferenceKey);
    if (isAiModeEnabled != null) {
      _isAiModeEnabledSubject.add(isAiModeEnabled);
    } else {
      _sharedPreferences.setBool(_preferenceKey, _defaultValueForAiMode);
      _isAiModeEnabledSubject.add(_defaultValueForAiMode);
    }
  }

  @factoryMethod
  static Future<SessionParameterOptimizationMiddlewareRepository> create(
      PastSessionsMiddlewareRepository pastSessionsRepository,
      SharedPreferences sharedPreferences
      ) async {
    return SessionParameterOptimizationMiddlewareRepository(pastSessionsRepository, sharedPreferences);
  }

  @override
  Stream<bool> get isAiModeAvailable => _pastSessionsRepository.pastSessionsStream.map((e) => e.length > 2);

  final BehaviorSubject<bool> _isAiModeEnabledSubject = BehaviorSubject<bool>();
  @override
  Stream<bool> get isAiModeEnabled {
    return CombineLatestStream.combine2(
      _pastSessionsRepository.pastSessionsStream,
      _isAiModeEnabledSubject,
          (List<dynamic> sessions, bool isAiModeEnabled) {
        final bool isAiModeAvailable = sessions.length > 2;
        return isAiModeAvailable && isAiModeEnabled;
      },
    ).asBroadcastStream(); // To allow multiple listeners
  }

  @override
  void changeAiMode(bool isEnabled) async {
    await _sharedPreferences.setBool(_preferenceKey, isEnabled);
    _isAiModeEnabledSubject.add(isEnabled);
  }

// @override
// Future<dynamic> getSessionParameterOptimization(PastSession session) async {
//   // TODO: implement getSessionParameterOptimization
//   throw UnimplementedError();
// }
//
// @override
// Future<void> trainSessionParameterOptimization(PastSession sessionParameterOptimization) {
//   // TODO: implement trainSessionParameterOptimization
//   throw UnimplementedError();
// }

}