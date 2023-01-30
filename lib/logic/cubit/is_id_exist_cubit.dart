import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../app/di.dart';
import '../../domain/repository/repository.dart';

part 'is_id_exist_state.dart';

class IsIdExistCubit extends Cubit<IsIdExistState> {
  final Repository _repository = instance<Repository>();
  int counter = 0;
  IsIdExistCubit() : super(IsIdExistInitial());
  requestIsIdExist(String id) async {
    counter++;
    final result = await _repository.isIdExist(id);
    if (result) {
      emit(IdExist());
    } else if (counter > 3) {
      emit(MaximumTriesExceededState());
    } else {
      emit(IdNotExist());
    }
  }
}
