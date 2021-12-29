import 'package:equatable/equatable.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/domain/entities/post_caretaker.dart';

abstract class CaretakerEvent extends Equatable {
  const CaretakerEvent();

  @override
  List<Object> get props => [];
}

class LoadCaretaker extends CaretakerEvent {
  
}

class AddLoadCaretaker extends CaretakerEvent {
  
}

class EditLoadCaretaker extends CaretakerEvent {
  
}

class AddCaretakerEvent extends CaretakerEvent {
  final PostCaretaker caretaker;

  const AddCaretakerEvent({
    required this.caretaker,
  });
}

class EditCaretakerEvent extends CaretakerEvent {
  final PostCaretaker caretakerEdit;

  const EditCaretakerEvent({
    required this.caretakerEdit,
  });
}

