import 'package:kmp_pengurus_app/features/master/caretaker/data/models/caretaker_model.dart';

abstract class CaretakerState {
  List<Object> get props => [];
}

class CaretakerInitial extends CaretakerState {}

class CaretakerLoading extends CaretakerState {}

class CaretakerLoaded extends CaretakerState {
  CaretakerLoaded({
    this.isFromCacheFirst = false,
    this.data,
  });

  bool isFromCacheFirst;
  CaretakerModel? data;

  @override
  List<Object> get props => [isFromCacheFirst, data!];
}


class AddCaretakerLoaded extends CaretakerState {
}

class EditCaretakerLoaded extends CaretakerState {
}

class CaretakerSuccess extends CaretakerState {
  final bool isSuccess;

  CaretakerSuccess({required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class CaretakerFailure extends CaretakerState {
  CaretakerFailure({
    required this.error,
  });

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'caretaker Failure { error: $error }';
}
