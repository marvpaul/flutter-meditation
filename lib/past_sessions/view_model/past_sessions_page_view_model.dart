import 'package:flutter_meditation/base/base_view_model.dart';
import 'package:injectable/injectable.dart';
import '../../di/Setup.dart';
import '../data/repository/impl/past_sessions_repository_local.dart';
import '../data/repository/past_sessions_repository.dart';

@injectable
class PastSessionsPageViewModel extends BaseViewModel {
  final PastSessionsRepository _settingsRepository = getIt<PastSessionsRepositoryLocal>();

}
