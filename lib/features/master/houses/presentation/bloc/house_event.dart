import 'package:equatable/equatable.dart';
import 'package:kmp_pengurus_app/features/master/houses/domain/entities/post_houses.dart';

abstract class HousesEvent extends Equatable {
  const HousesEvent();

  @override
  List<Object> get props => [];
}

class LoadHouses extends HousesEvent {
  
} 

class AddLoadHouses extends HousesEvent {
  
}

class EditLoadHouses extends HousesEvent {
  
}

class AddHousesEvent extends HousesEvent {
  final PostHouses houses;

  const AddHousesEvent({
    required this.houses,
  });
}

class EditHousesEvent extends HousesEvent {
  final PostHouses housesEdit;

  const EditHousesEvent({
    required this.housesEdit,
  });
}

class DeleteHousesEvent extends HousesEvent {
  final String idHouse;

  const DeleteHousesEvent({
    required this.idHouse,
  });
}
