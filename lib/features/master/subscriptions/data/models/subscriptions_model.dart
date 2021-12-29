// To parse this JSON data, do
//
//     final subscriptionsModel = subscriptionsModelFromJson(jsonString);

import 'dart:convert';

SubscriptionsModel subscriptionsModelFromJson(String str) =>
    SubscriptionsModel.fromJson(json.decode(str));

String subscriptionsModelToJson(SubscriptionsModel data) =>
    json.encode(data.toJson());

class SubscriptionsModel {
  SubscriptionsModel({
    this.result,
    this.timestamp,
    this.paginate,
  });

  bool? result;
  num? timestamp;
  Paginate? paginate;

  factory SubscriptionsModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionsModel(
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

  List<Subscription>? docs;
  num? totalDocs;
  num? offset;
  num? limit;
  num? totalPages;
  num? page;
  num? pagingCounter;
  bool? hasPrevPage;
  bool? hasNextPage;
  dynamic prevPage;
  dynamic nextPage;

  factory Paginate.fromJson(Map<String, dynamic> json) => Paginate(
        docs: json["docs"] == null
            ? null
            : List<Subscription>.from(
                json["docs"].map((x) => Subscription.fromJson(x))),
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

class Subscription {
  Subscription({
    this.id,
    this.amount,
    this.isActive,
    this.name,
    this.description,
    this.subscriptionCategory,
    this.subscriptionCategoryName,
    this.effectiveDateString,
    this.docId,
  });

  String? id;
  num? amount;
  bool? isActive;
  String? name;
  String? description;
  SubscriptionCategory? subscriptionCategory;
  String? subscriptionCategoryName;
  DateTime? effectiveDateString;
  String? docId;

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        id: json["_id"] == null ? null : json["_id"],
        amount: json["amount"] == null ? null : json["amount"],
        isActive: json["is_active"] == null ? null : json["is_active"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        subscriptionCategory: json["subscription_category"] == null
            ? null
            : SubscriptionCategory.fromJson(json["subscription_category"]),
        subscriptionCategoryName: json["subscription_category_name"] == null
            ? null
            : json["subscription_category_name"],
        effectiveDateString: json["effective_date_string"] == null
            ? null
            : DateTime.parse(json["effective_date_string"]),
        docId: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "amount": amount == null ? null : amount,
        "is_active": isActive == null ? null : isActive,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "subscription_category": subscriptionCategory == null
            ? null
            : subscriptionCategory!.toJson(),
        "subscription_category_name":
            subscriptionCategoryName == null ? null : subscriptionCategoryName,
        "effective_date_string": effectiveDateString == null
            ? null
            : "${effectiveDateString!.year.toString().padLeft(4, '0')}-${effectiveDateString!.month.toString().padLeft(2, '0')}-${effectiveDateString!.day.toString().padLeft(2, '0')}",
        "id": docId == null ? null : docId,
      };
}

class SubscriptionCategory {
  SubscriptionCategory({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory SubscriptionCategory.fromJson(Map<String, dynamic> json) =>
      SubscriptionCategory(
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}
