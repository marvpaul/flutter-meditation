import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../past_sessions/data/repository/impl/past_sessions_middleware_repository.dart';
import '../../../../past_sessions/data/repository/past_sessions_repository.dart';
import '../session_parameter_optimization_repository.dart';

@singleton
@injectable
class SessionParameterOptimizationMiddlewareRepository implements SessionParameterOptimizationRepository {

  final PastSessionsRepository _pastSessionsRepository;
  final SharedPreferences _sharedPreferences;

  SessionParameterOptimizationMiddlewareRepository(this._pastSessionsRepository, this._sharedPreferences);

  @factoryMethod
  static Future<SessionParameterOptimizationMiddlewareRepository> create(
      PastSessionsMiddlewareRepository pastSessionsRepository,
      SharedPreferences sharedPreferences
      ) async {
    return SessionParameterOptimizationMiddlewareRepository(pastSessionsRepository, sharedPreferences);
  }

  @override
  // TODO: implement isAiModeAvailable
  Stream<bool> get isAiModeAvailable => _pastSessionsRepository.pastSessionsStream.map((e) => e.length > 2);

  @override
  Stream<bool> get isAiModeEnabled {
    return _pastSessionsRepository.pastSessionsStream.asyncMap((sessions) async {
      final bool isAiModeAvailable = sessions.length > 2;

      // Retrieve the isAiModeEnabled preference
      bool? isAiModeEnabled = _sharedPreferences.getBool('isAiModeEnabled');
      if (isAiModeEnabled == null) {
        // Set the preference if it's not set yet
        await _sharedPreferences.setBool('isAiModeEnabled', isAiModeAvailable);
        isAiModeEnabled = isAiModeAvailable;
      }

      return isAiModeAvailable && isAiModeEnabled;
    }).asBroadcastStream(); // Using asBroadcastStream to allow multiple listeners
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