// To parse this JSON data, do
//
//     final officersModel = officersModelFromJson(jsonString);

import 'dart:convert';

import 'package:kmp_pengurus_app/features/dashboard/data/models/dashboard_model.dart';

OfficersModel officersModelFromJson(String str) => OfficersModel.fromJson(json.decode(str));

String officersModelToJson(OfficersModel data) => json.encode(data.toJson());

class OfficersModel {
    OfficersModel({
        this.result,
        this.timestamp,
        this.paginate,
    });

    bool? result;
    int? timestamp;
    Paginate? paginate;

    factory OfficersModel.fromJson(Map<String, dynamic> json) => OfficersModel(
        result: json["result"] == null ? null : json["result"],
        timestamp: json["timestamp"] == null ? null : json["timestamp"],
        paginate: json["paginate"] == null ? null : Paginate.fromJson(json["paginate"]),
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

    List<Officers>? docs;
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
        docs: json["docs"] == null ? null : List<Officers>.from(json["docs"].map((x) => Officers.fromJson(x))),
        totalDocs: json["totalDocs"] == null ? null : json["totalDocs"],
        offset: json["offset"] == null ? null : json["offset"],
        limit: json["limit"] == null ? null : json["limit"],
        totalPages: json["totalPages"] == null ? null : json["totalPages"],
        page: json["page"] == null ? null : json["page"],
        pagingCounter: json["pagingCounter"] == null ? null : json["pagingCounter"],
        hasPrevPage: json["hasPrevPage"] == null ? null : json["hasPrevPage"],
        hasNextPage: json["hasNextPage"] == null ? null : json["hasNextPage"],
        prevPage: json["prevPage"],
        nextPage: json["nextPage"],
    );

    Map<String, dynamic> toJson() => {
        "docs": docs == null ? null : List<dynamic>.from(docs!.map((x) => x.toJson())),
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

class Officers {
    Officers({
        this.id,
        this.isActive,
        this.idCard,
        this.name,
        this.gender,
        this.subDistrict,
        this.street,
        this.rt,
        this.rw,
        this.phone,
        this.phone2,
        this.email,
        this.position,
        this.province,
        this.provinceName,
        this.city,
        this.cityName,
        this.district,
        this.districtName,
        this.region,
        this.regionName,
        this.address,
        this.assignments,
        this.docId,
    });

    String? id;
    bool? isActive;
    String? idCard;
    String? name;
    String? gender;
    String? subDistrict;
    String? street;
    String? rt;
    String? rw;
    String? phone;
    String? phone2;
    String? email;
    Position? position;
    String? province;
    String? provinceName;
    String? city;
    String? cityName;
    String? district;
    String? districtName;
    String? region;
    String? regionName;
    String? address;
    List<Assignment>? assignments;
    String? docId;

    factory Officers.fromJson(Map<String, dynamic> json) => Officers(
        id: json["_id"] == null ? null : json["_id"],
        isActive: json["is_active"] == null ? null : json["is_active"],
        idCard: json["id_card"] == null ? null : json["id_card"],
        name: json["name"] == null ? null : json["name"],
        gender: json["gender"] == null ? null : json["gender"],
        subDistrict: json["sub_district"] == null ? null : json["sub_district"],
        street: json["street"] == null ? null : json["street"],
        rt: json["rt"] == null ? null : json["rt"],
        rw: json["rw"] == null ? null : json["rw"],
        phone: json["phone"] == null ? null : json["phone"],
        phone2: json["phone_2"] == null ? null : json["phone_2"],
        email: json["email"] == null ? null : json["email"],
        position: json["position"] == null ? null : Position.fromJson(json["position"]),
        province: json["province"] == null ? null : json["province"],
        provinceName: json["province_name"] == null ? null : json["province_name"],
        city: json["city"] == null ? null : json["city"],
        cityName: json["city_name"] == null ? null : json["city_name"],
        district: json["district"] == null ? null : json["district"],
        districtName: json["district_name"] == null ? null : json["district_name"],
        region: json["region"] == null ? null : json["region"],
        regionName: json["region_name"] == null ? null : json["region_name"],
        address: json["address"] == null ? null : json["address"],
        assignments: json["assignments"] == null ? null : List<Assignment>.from(json["assignments"].map((x) => Assignment.fromJson(x))),
        docId: json["id"] == null ? null : json["id"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "is_active": isActive == null ? null : isActive,
        "id_card": idCard == null ? null : idCard,
        "name": name == null ? null : name,
        "gender": gender == null ? null : gender,
        "sub_district": subDistrict == null ? null : subDistrict,
        "street": street == null ? null : street,
        "rt": rt == null ? null : rt,
        "rw": rw == null ? null : rw,
        "phone": phone == null ? null : phone,
        "phone_2": phone2 == null ? null : phone2,
        "email": email == null ? null : email,
        "position": position == null ? null : position!.toJson(),
        "province": province == null ? null : province,
        "province_name": provinceName == null ? null : provinceName,
        "city": city == null ? null : city,
        "city_name": cityName == null ? null : cityName,
        "district": district == null ? null : district,
        "district_name": districtName == null ? null : districtName,
        "region": region == null ? null : region,
        "region_name": regionName == null ? null : regionName,
        "address": address == null ? null : address,
        "assignments": assignments == null ? null : List<dynamic>.from(assignments!.map((x) => x.toJson())),
        "id": docId == null ? null : docId,
    };
}

class Assignment {
    Assignment({
        this.id,
        this.rwNumber,
        this.rtNumber,
        this.officer,
        this.rtPlace,
        this.rw,
        this.rt,
        this.villageCode,
        this.villageName,
    });

    String? id;
    int? rwNumber;
    int? rtNumber;
    String? officer;
    String? rtPlace;
    String? rw;
    String? rt;
    String? villageCode;
    String? villageName;

    factory Assignment.fromJson(Map<String, dynamic> json) => Assignment(
        id: json["_id"] == null ? null : json["_id"],
        rwNumber: json["rw_number"] == null ? null : json["rw_number"],
        rtNumber: json["rt_number"] == null ? null : json["rt_number"],
        officer: json["officer"] == null ? null : json["officer"],
        rtPlace: json["rt_place"] == null ? null : json["rt_place"],
        rw: json["rw"] == null ? null : json["rw"],
        rt: json["rt"] == null ? null : json["rt"],
        villageCode: json["village_code"] == null ? null : json["village_code"],
        villageName: json["village_name"] == null ? null : json["village_name"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "rw_number": rwNumber == null ? null : rwNumber,
        "rt_number": rtNumber == null ? null : rtNumber,
        "officer": officer == null ? null : officer,
        "rt_place": rtPlace == null ? null : rtPlace,
        "rw": rw == null ? null : rw,
        "rt": rt == null ? null : rt,
        "village_code": villageCode == null ? null : villageCode,
        "village_name": villageName == null ? null : villageName,
    };
}
