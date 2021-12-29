// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  CategoryModel({
    this.result,
    this.timestamp,
    this.paginate,
  });

  bool? result;
  int? timestamp;
  Paginate? paginate;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
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

  List<AccountCategory>? docs;
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
            : List<AccountCategory>.from(
                json["docs"].map((x) => AccountCategory.fromJson(x))),
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

class AccountCategory {
  AccountCategory({
    this.id,
    this.isActive,
    this.name,
    this.description,
    this.docId,
  });

  String? id;
  bool? isActive;
  String? name;
  String? description;
  String? docId;

  factory AccountCategory.fromJson(Map<String, dynamic> json) => AccountCategory(
        id: json["_id"] == null ? null : json["_id"],
        isActive: json["is_active"] == null ? null : json["is_active"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        docId: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "is_active": isActive == null ? null : isActive,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "id": docId == null ? null : docId,
      };
}
