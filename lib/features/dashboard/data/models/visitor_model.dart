// To parse this JSON data, do
//
//     final visitorModel = visitorModelFromJson(jsonString);

import 'dart:convert';

VisitorModel visitorModelFromJson(String str) =>
    VisitorModel.fromJson(json.decode(str));

String visitorModelToJson(VisitorModel data) => json.encode(data.toJson());

class VisitorModel {
  VisitorModel({
    this.result,
    this.timestamp,
    this.paginate,
  });

  bool? result;
  int? timestamp;
  Paginate? paginate;

  factory VisitorModel.fromJson(Map<String, dynamic> json) => VisitorModel(
        result: json["result"] == null ? null : json["result"],
        timestamp: json["timestamp"] == null ? null : json["timestamp"],
        paginate: json["paginate"] == null
            ? null
            : Paginate.fromJson(json["paginate"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result == null ? null : result,
        "timestamp": timestamp == null ? null : timestamp,
        "paginate": paginate == null ? null : paginate!.toJson(),
      };
}

class Paginate {
  Paginate({
    this.docs,
    this.totalDocs,
    this.offset,
    this.limit,
    this.totalPages,
    this.page,
    this.pagingCounter,
    this.hasPrevPage,
    this.hasNextPage,
    this.prevPage,
    this.nextPage,
  });

  List<Guest>? docs;
  int? totalDocs;
  int? offset;
  int? limit;
  int? totalPages;
  int? page;
  int? pagingCounter;
  bool? hasPrevPage;
  bool? hasNextPage;
  dynamic prevPage;
  dynamic nextPage;

  factory Paginate.fromJson(Map<String, dynamic> json) => Paginate(
        docs: json["docs"] == null
            ? null
            : List<Guest>.from(json["docs"].map((x) => Guest.fromJson(x))),
        totalDocs: json["totalDocs"] == null ? null : json["totalDocs"],
        offset: json["offset"] == null ? null : json["offset"],
        limit: json["limit"] == null ? null : json["limit"],
        totalPages: json["totalPages"] == null ? null : json["totalPages"],
        page: json["page"] == null ? null : json["page"],
        pagingCounter:
            json["pagingCounter"] == null ? null : json["pagingCounter"],
        hasPrevPage: json["hasPrevPage"] == null ? null : json["hasPrevPage"],
        hasNextPage: json["hasNextPage"] == null ? null : json["hasNextPage"],
        prevPage: json["prevPage"],
        nextPage: json["nextPage"],
      );

  Map<String, dynamic> toJson() => {
        "docs": docs == null
            ? null
            : List<dynamic>.from(docs!.map((x) => x.toJson())),
        "totalDocs": totalDocs == null ? null : totalDocs,
        "offset": offset == null ? null : offset,
        "limit": limit == null ? null : limit,
        "totalPages": totalPages == null ? null : totalPages,
        "page": page == null ? null : page,
        "pagingCounter": pagingCounter == null ? null : pagingCounter,
        "hasPrevPage": hasPrevPage == null ? null : hasPrevPage,
        "hasNextPage": hasNextPage == null ? null : hasNextPage,
        "prevPage": prevPage,
        "nextPage": nextPage,
      };
}

class Guest {
  Guest({
    this.id,
    this.guestCount,
    this.name,
    this.phone,
    this.necessity,
    this.destinationPersonName,
    this.houseAddress,
    this.fullAddress,
    this.rw,
    this.rt,
    this.street,
    this.houseBlock,
    this.houseNumber,
    this.citizenPhone,
    this.village,
    this.villageName,
    this.clientDisplayName,
    this.acceptedAt,
    this.acceptedByName,
    this.acceptedByPhone,
    this.docId,
    this.idCardFile,
    this.selfieFile,
    this.open,
  });

  String? id;
  int? guestCount;
  String? name;
  String? phone;
  String? necessity;
  String? destinationPersonName;
  String? houseAddress;
  String? fullAddress;
  String? rw;
  String? rt;
  String? street;
  String? houseBlock;
  String? houseNumber;
  String? citizenPhone;
  Village? village;
  String? villageName;
  String? clientDisplayName;
  DateTime? acceptedAt;
  String? acceptedByName;
  String? acceptedByPhone;
  String? docId;
  IdCardFile? idCardFile;
  IdCardFile? selfieFile;
  bool? open;

  factory Guest.fromJson(Map<String, dynamic> json) => Guest(
        id: json["_id"] == null ? null : json["_id"],
        guestCount: json["guest_count"] == null ? null : json["guest_count"],
        name: json["name"] == null ? null : json["name"],
        phone: json["phone"] == null ? null : json["phone"],
        necessity: json["necessity"] == null ? null : json["necessity"],
        destinationPersonName: json["destination_person_name"] == null
            ? null
            : json["destination_person_name"],
        houseAddress:
            json["house_address"] == null ? null : json["house_address"],
        fullAddress: json["full_address"] == null ? null : json["full_address"],
        rw: json["rw"] == null ? null : json["rw"],
        rt: json["rt"] == null ? null : json["rt"],
        street: json["street"] == null ? null : json["street"],
        houseBlock: json["house_block"] == null ? null : json["house_block"],
        houseNumber: json["house_number"] == null ? null : json["house_number"],
        citizenPhone:
            json["citizen_phone"] == null ? null : json["citizen_phone"],
        village:
            json["village"] == null ? null : Village.fromJson(json["village"]),
        villageName: json["village_name"] == null ? null : json["village_name"],
        clientDisplayName: json["client_display_name"] == null
            ? null
            : json["client_display_name"],
        acceptedAt: json["accepted_at"] == null
            ? null
            : DateTime.parse(json["accepted_at"]),
        acceptedByName:
            json["accepted_by_name"] == null ? null : json["accepted_by_name"],
        acceptedByPhone: json["accepted_by_phone"] == null
            ? null
            : json["accepted_by_phone"],
        docId: json["id"] == null ? null : json["id"],
        idCardFile: json["id_card_file"] == null
            ? null
            : IdCardFile.fromJson(json["id_card_file"]),
        selfieFile: json["selfie_file"] == null
            ? null
            : IdCardFile.fromJson(json["selfie_file"]),
        open: json["open"] == null ? false : json["open"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "guest_count": guestCount == null ? null : guestCount,
        "name": name == null ? null : name,
        "phone": phone == null ? null : phone,
        "necessity": necessity == null ? null : necessity,
        "destination_person_name":
            destinationPersonName == null ? null : destinationPersonName,
        "house_address": houseAddress == null ? null : houseAddress,
        "full_address": fullAddress == null ? null : fullAddress,
        "rw": rw == null ? null : rw,
        "rt": rt == null ? null : rt,
        "street": street == null ? null : street,
        "house_block": houseBlock == null ? null : houseBlock,
        "house_number": houseNumber == null ? null : houseNumber,
        "citizen_phone": citizenPhone == null ? null : citizenPhone,
        "village": village == null ? null : village!.toJson(),
        "village_name": villageName == null ? null : villageName,
        "client_display_name":
            clientDisplayName == null ? null : clientDisplayName,
        "accepted_at": acceptedAt == null ? null : acceptedAt.toString(),
        "accepted_by_name": acceptedByName == null ? null : acceptedByName,
        "accepted_by_phone": acceptedByPhone == null ? null : acceptedByPhone,
        "id": docId == null ? null : docId,
        "id_card_file": idCardFile == null ? null : idCardFile!.toJson(),
        "selfie_file": selfieFile == null ? null : selfieFile!.toJson(),
        "open": open == null ? false : open,
      };
}

class IdCardFile {
  IdCardFile({
    this.id,
    this.size,
    this.type,
    this.mime,
    this.category,
    this.name,
    this.url,
  });

  String? id;
  int? size;
  String? type;
  String? mime;
  String? category;
  String? name;
  String? url;

  factory IdCardFile.fromJson(Map<String, dynamic> json) => IdCardFile(
        id: json["_id"] == null ? null : json["_id"],
        size: json["size"] == null ? null : json["size"],
        type: json["type"] == null ? null : json["type"],
        mime: json["mime"] == null ? null : json["mime"],
        category: json["category"] == null ? null : json["category"],
        name: json["name"] == null ? null : json["name"],
        url: json["url"] == null ? null : json["url"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "size": size == null ? null : size,
        "type": type == null ? null : type,
        "mime": mime == null ? null : mime,
        "category": category == null ? null : category,
        "name": name == null ? null : name,
        "url": url == null ? null : url,
      };
}

class Village {
  Village({
    this.id,
    this.code,
    this.name,
  });

  String? id;
  String? code;
  String? name;

  factory Village.fromJson(Map<String, dynamic> json) => Village(
        id: json["_id"] == null ? null : json["_id"],
        code: json["code"] == null ? null : json["code"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "code": code == null ? null : code,
        "name": name == null ? null : name,
      };
}
