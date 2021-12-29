// To parse this JSON data, do

//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
    ProfileModel({
        this.id,
        this.token,
        this.refreshToken,
        this.username,
        this.roleName,
        this.name,
        this.gender,
        this.email,
        this.phone,
        this.avatar,
        this.caretaker,
        this.timestamp,
    });

    String? id;
    String? token;
    String? refreshToken;
    String? username;
    String? roleName;
    String? name;
    String? gender;
    String? email;
    String? phone;
    String? avatar;
    Caretaker? caretaker;
    int? timestamp;

    factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json["_id"] == null ? null : json["_id"],
        token: json["token"] == null ? null : json["token"],
        refreshToken: json["refresh_token"] == null ? null : json["refresh_token"],
        username: json["username"] == null ? null : json["username"],
        roleName: json["role_name"] == null ? null : json["role_name"],
        name: json["name"] == null ? null : json["name"],
        gender: json["gender"] == null ? null : json["gender"],
        email: json["email"] == null ? null : json["email"],
        phone: json["phone"] == null ? null : json["phone"],
        avatar: json["avatar"] == null ? null : json["avatar"],
        caretaker: json["caretaker"] == null ? null : Caretaker.fromJson(json["caretaker"]),
        timestamp: json["timestamp"] == null ? null : json["timestamp"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "token": token == null ? null : token,
        "refresh_token": refreshToken == null ? null : refreshToken,
        "username": username == null ? null : username,
        "role_name": roleName == null ? null : roleName,
        "name": name == null ? null : name,
        "gender": gender == null ? null : gender,
        "email": email == null ? null : email,
        "phone": phone == null ? null : phone,
        "avatar": avatar == null ? null : avatar,
        "caretaker": caretaker == null ? null : caretaker!.toJson(),
        "timestamp": timestamp == null ? null : timestamp,
    };
}

class Caretaker {
    Caretaker({
        this.rtNumber,
        this.rwNumber,
        this.isPic,
        this.isTreasurer,
        this.id,
        this.idCard,
        this.name,
        this.gender,
        this.rtPlace,
        this.street,
        this.email,
        this.phone,
        this.phone2,
        this.genderName,
        this.address,
        this.province,
        this.provinceName,
        this.city,
        this.cityName,
        this.district,
        this.districtName,
        this.subDistrict,
        this.subDistrictName,
        this.region,
        this.regionName,
        this.rt,
        this.rw,
        this.createdBy,
        this.user,
        this.userUsername,
        this.userName,
        this.createdAt,
        this.updatedAt,
        this.positionName,
        this.updatedBy,
        this.idCardFileUrl,
        this.pasFileUrl,
        this.position,
        this.caretakerId,
    });

    int? rtNumber;
    int? rwNumber;
    bool? isPic;
    bool? isTreasurer;
    String? id;
    String? idCard;
    String? name;
    String? gender;
    dynamic rtPlace;
    String? street;
    String? email;
    String? phone;
    String? phone2;
    String? genderName;
    String? address;
    String? province;
    String? provinceName;
    String? city;
    String? cityName;
    String? district;
    String? districtName;
    String? subDistrict;
    String? subDistrictName;
    String? region;
    String? regionName;
    String? rt;
    String? rw;
    String? createdBy;
    String? user;
    String? userUsername;
    String? userName;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? positionName;
    String? updatedBy;
    String? idCardFileUrl;
    String? pasFileUrl;
    String? position;
    String? caretakerId;

    factory Caretaker.fromJson(Map<String, dynamic> json) => Caretaker(
        rtNumber: json["rt_number"] == null ? null : json["rt_number"],
        rwNumber: json["rw_number"] == null ? null : json["rw_number"],
        isPic: json["is_pic"] == null ? null : json["is_pic"],
        isTreasurer: json["is_treasurer"] == null ? null : json["is_treasurer"],
        id: json["_id"] == null ? null : json["_id"],
        idCard: json["id_card"] == null ? null : json["id_card"],
        name: json["name"] == null ? null : json["name"],
        gender: json["gender"] == null ? null : json["gender"],
        rtPlace: json["rt_place"],
        street: json["street"] == null ? null : json["street"],
        email: json["email"] == null ? null : json["email"],
        phone: json["phone"] == null ? null : json["phone"],
        phone2: json["phone_2"] == null ? null : json["phone_2"],
        genderName: json["gender_name"] == null ? null : json["gender_name"],
        address: json["address"] == null ? null : json["address"],
        province: json["province"] == null ? null : json["province"],
        provinceName: json["province_name"] == null ? null : json["province_name"],
        city: json["city"] == null ? null : json["city"],
        cityName: json["city_name"] == null ? null : json["city_name"],
        district: json["district"] == null ? null : json["district"],
        districtName: json["district_name"] == null ? null : json["district_name"],
        subDistrict: json["sub_district"] == null ? null : json["sub_district"],
        subDistrictName: json["sub_district_name"] == null ? null : json["sub_district_name"],
        region: json["region"] == null ? null : json["region"],
        regionName: json["region_name"] == null ? null : json["region_name"],
        rt: json["rt"] == null ? null : json["rt"],
        rw: json["rw"] == null ? null : json["rw"],
        createdBy: json["created_by"] == null ? null : json["created_by"],
        user: json["user"] == null ? null : json["user"],
        userUsername: json["user_username"] == null ? null : json["user_username"],
        userName: json["user_name"] == null ? null : json["user_name"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        positionName: json["position_name"] == null ? null : json["position_name"],
        updatedBy: json["updated_by"] == null ? null : json["updated_by"],
        idCardFileUrl: json["id_card_file_url"] == null ? null : json["id_card_file_url"],
        pasFileUrl: json["pas_file_url"] == null ? null : json["pas_file_url"],
        position: json["position"] == null ? null : json["position"],
        caretakerId: json["id"] == null ? null : json["id"],
    );

    Map<String, dynamic> toJson() => {
        "rt_number": rtNumber == null ? null : rtNumber,
        "rw_number": rwNumber == null ? null : rwNumber,
        "is_pic": isPic == null ? null : isPic,
        "is_treasurer": isTreasurer == null ? null : isTreasurer,
        "_id": id == null ? null : id,
        "id_card": idCard == null ? null : idCard,
        "name": name == null ? null : name,
        "gender": gender == null ? null : gender,
        "rt_place": rtPlace,
        "street": street == null ? null : street,
        "email": email == null ? null : email,
        "phone": phone == null ? null : phone,
        "phone_2": phone2 == null ? null : phone2,
        "gender_name": genderName == null ? null : genderName,
        "address": address == null ? null : address,
        "province": province == null ? null : province,
        "province_name": provinceName == null ? null : provinceName,
        "city": city == null ? null : city,
        "city_name": cityName == null ? null : cityName,
        "district": district == null ? null : district,
        "district_name": districtName == null ? null : districtName,
        "sub_district": subDistrict == null ? null : subDistrict,
        "sub_district_name": subDistrictName == null ? null : subDistrictName,
        "region": region == null ? null : region,
        "region_name": regionName == null ? null : regionName,
        "rt": rt == null ? null : rt,
        "rw": rw == null ? null : rw,
        "created_by": createdBy == null ? null : createdBy,
        "user": user == null ? null : user,
        "user_username": userUsername == null ? null : userUsername,
        "user_name": userName == null ? null : userName,
        "created_at": createdAt == null ? null : createdAt.toString(),
        "updated_at": updatedAt == null ? null : updatedAt.toString(),
        "position_name": positionName == null ? null : positionName,
        "updated_by": updatedBy == null ? null : updatedBy,
        "id_card_file_url": idCardFileUrl == null ? null : idCardFileUrl,
        "pas_file_url": pasFileUrl == null ? null : pasFileUrl,
        "position": position == null ? null : position,
        "id": caretakerId == null ? null : caretakerId,
    };
}
