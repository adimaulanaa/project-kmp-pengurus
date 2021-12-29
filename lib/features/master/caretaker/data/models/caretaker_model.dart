// To parse this JSON data, do
//
//     final CaretakerModel = CaretakerModelFromJson(jsonString);

import 'dart:convert';

CaretakerModel caretakerModelFromJson(String str) => CaretakerModel.fromJson(json.decode(str));

String caretakerModelToJson(CaretakerModel data) => json.encode(data.toJson());

class CaretakerModel {
    CaretakerModel({
        this.result,
        this.timestamp,
        this.paginate,
    });

    bool? result;
    int? timestamp;
    Paginate? paginate;

    factory CaretakerModel.fromJson(Map<String, dynamic> json) => CaretakerModel(
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

    List<Caretakers>? docs;
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
        docs: json["docs"] == null ? null : List<Caretakers>.from(json["docs"].map((x) => Caretakers.fromJson(x))),
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

class Caretakers {
    Caretakers({
        this.id,
        this.isPic,
        this.isTreasurer,
        this.isActive,
        this.idCard,
        this.name,
        this.gender,
        this.street,
        this.phone,
        this.phone2,
        this.email,
        this.address,
        this.province,
        this.provinceName,
        this.city,
        this.cityName,
        this.district,
        this.districtName,
        this.subDistrict,
        this.region,
        this.regionName,
        this.rt,
        this.rw,
        this.docId,
    });

    String? id;
    bool? isPic;
    bool? isTreasurer;
    bool? isActive;
    String? idCard;
    String? name;
    String? gender;
    String? street;
    String? phone;
    String? phone2;
    String? email;
    String? address;
    String? province;
    String? provinceName;
    String? city;
    String? cityName;
    String? district;
    String? districtName;
    String? subDistrict;
    String? region;
    String? regionName;
    String? rt;
    String? rw;
    String? docId;

    factory Caretakers.fromJson(Map<String, dynamic> json) => Caretakers(
        id: json["_id"] == null ? null : json["_id"],
        isPic: json["is_pic"] == null ? null : json["is_pic"],
        isTreasurer: json["is_treasurer"] == null ? null : json["is_treasurer"],
        isActive: json["is_active"] == null ? null : json["is_active"],
        idCard: json["id_card"] == null ? null : json["id_card"],
        name: json["name"] == null ? null : json["name"],
        gender: json["gender"] == null ? null : json["gender"],
        street: json["street"] == null ? null : json["street"],
        phone: json["phone"] == null ? null : json["phone"],
        phone2: json["phone_2"] == null ? null : json["phone_2"],
        email: json["email"] == null ? null : json["email"],
        address: json["address"] == null ? null : json["address"],
        province: json["province"] == null ? null : json["province"],
        provinceName: json["province_name"] == null ? null : json["province_name"],
        city: json["city"] == null ? null : json["city"],
        cityName: json["city_name"] == null ? null : json["city_name"],
        district: json["district"] == null ? null : json["district"],
        districtName: json["district_name"] == null ? null : json["district_name"],
        subDistrict: json["sub_district"] == null ? null : json["sub_district"],
        region: json["region"] == null ? null : json["region"],
        regionName: json["region_name"] == null ? null : json["region_name"],
        rt: json["rt"] == null ? null : json["rt"],
        rw: json["rw"] == null ? null : json["rw"],
        docId: json["id"] == null ? null : json["id"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "is_pic": isPic == null ? null : isPic,
        "is_treasurer": isTreasurer == null ? null : isTreasurer,
        "is_active": isActive == null ? null : isActive,
        "id_card": idCard == null ? null : idCard,
        "name": name == null ? null : name,
        "gender": gender == null ? null : gender,
        "street": street == null ? null : street,
        "phone": phone == null ? null : phone,
        "phone_2": phone2 == null ? null : phone2,
        "email": email == null ? null : email,
        "address": address == null ? null : address,
        "province": province == null ? null : province,
        "province_name": provinceName == null ? null : provinceName,
        "city": city == null ? null : city,
        "city_name": cityName == null ? null : cityName,
        "district": district == null ? null : district,
        "district_name": districtName == null ? null : districtName,
        "sub_district": subDistrict == null ? null : subDistrict,
        "region": region == null ? null : region,
        "region_name": regionName == null ? null : regionName,
        "rt": rt == null ? null : rt,
        "rw": rw == null ? null : rw,
        "id": docId == null ? null : docId,
    };
}
