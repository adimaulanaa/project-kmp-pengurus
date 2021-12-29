import 'package:equatable/equatable.dart';
import 'package:kmp_pengurus_app/features/master/officers/domain/entities/post_officers.dart';

abstract class OfficersEvent extends Equatable {
  const OfficersEvent();

  @override
  List<Object> get props => [];
}

class LoadOfficers extends OfficersEvent {
  
}

class AddLoadOfficers extends OfficersEvent {
  
}

class EditLoadOfficers extends OfficersEvent {
  
}

class AddOfficersEvent extends OfficersEvent {
  final PostOfficers officers;

  const AddOfficersEvent({
    required this.officers,
  });
}

class EditOfficersEvent extends OfficersEvent {
  final PostOfficers officersEdit;

  const EditOfficersEvent({
    required this.officersEdit,
  });
}

class DeleteOfficersEvent extends OfficersEvent {
  final String idOfficer;

  const DeleteOfficersEvent({
    required this.idOfficer,
  });
}

