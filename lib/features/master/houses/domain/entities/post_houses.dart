class PostHouses {
  PostHouses({
    this.id,
    this.rtPlace, 
    this.street, 
    this.houseBlock, 
    this.houseNumber, 
    this.isVacant, 
    this.citizenIdCard, 
    this.citizenName, 
    this.citizenGender, 
    this.citizenPhone, 
    this.isPermanentCitizen, 
    this.subscriptions, 
    this.isFree,
  });
  String? id;
  String? rtPlace;
  String? street;
  String? houseBlock;
  String? houseNumber;
  bool? isVacant;
  String? citizenIdCard;
  String? citizenName;
  String? citizenGender;
  String? citizenPhone;
  bool? isPermanentCitizen;
  List<String>? subscriptions;
  bool? isFree;
}
