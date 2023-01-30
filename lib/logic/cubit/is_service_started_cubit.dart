import 'package:bloc/bloc.dart';
import 'package:independet/app/di.dart';
import 'package:independet/data/network/error_handler.dart';
import 'package:independet/domain/models/models.dart';
import 'package:independet/domain/repository/repository.dart';

part 'is_service_started_state.dart';

class IsServiceStartedCubit extends Cubit<IsServiceStartedState> {
  final Repository _repository = instance<Repository>();
  IsServiceStartedCubit() : super(IsServiceStartedInitial()) {
    _getAppReady();
  }
  _getAppReady() async {
    (await _repository.getAppReady()).fold(
        (l) => l.code == ResponseCode.NO_CONTENT
            ? emit(ServiceStartedWithNewUser())
            : _getAppReady(),
        (r) => emit(ServiceStarted(r)));
  }
}
