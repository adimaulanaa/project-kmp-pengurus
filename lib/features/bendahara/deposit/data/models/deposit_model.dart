// To parse this JSON data, do
//
//     final depositModel = depositModelFromJson(jsonString);

import 'dart:convert';

DepositModel depositModelFromJson(String str) =>
    DepositModel.fromJson(json.decode(str));

String depositModelToJson(DepositModel data) => json.encode(data.toJson());

class DepositModel {
  DepositModel({
    this.result,
    this.timestamp,
    this.options,
  });

  bool? result;
  int? timestamp;
  List<Option>? options;

  factory DepositModel.fromJson(Map<String, dynamic> json) => DepositModel(
        result: json["result"] == null ? null : json["result"],
        timestamp: json["timestamp"] == null ? null : json["timestamp"],
        options: json["options"] == null
            ? null
            : List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result == null ? null : result,
        "timestamp": timestamp == null ? null : timestamp,
        "options": options == null
            ? null
            : List<dynamic>.from(options!.map((x) => x.toJson())),
      };
}

class Option {
  Option({
    this.value,
    this.label,
    this.lastHasCashDepositAt,
    this.hasCashDepositTotal,
    this.transactions,
  });

  String? value;
  String? label;
  DateTime? lastHasCashDepositAt;
  int? hasCashDepositTotal;
  List<Transaction>? transactions;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        value: json["value"] == null ? null : json["value"],
        label: json["label"] == null ? null : json["label"],
        lastHasCashDepositAt: json["last_has_cash_deposit_at"] == null
            ? null
            : DateTime.parse(json["last_has_cash_deposit_at"]),
        hasCashDepositTotal: json["has_cash_deposit_total"] == null
            ? null
            : json["has_cash_deposit_total"],
        transactions: json["transactions"] == null
            ? null
            : List<Transaction>.from(
                json["transactions"].map((x) => Transaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "value": value == null ? null : value,
        "label": label == null ? null : label,
        "last_has_cash_deposit_at": lastHasCashDepositAt == null
            ? null
            : lastHasCashDepositAt!.toIso8601String(),
        "has_cash_deposit_total":
            hasCashDepositTotal == null ? null : hasCashDepositTotal,
        "transactions": transactions == null
            ? null
            : List<dynamic>.from(transactions!.map((x) => x.toJson())),
      };
}

class Transaction {
  Transaction({
    this.total,
    this.citizenSubscriptions,
    this.subscriptions,
    this.id,
    this.date,
    this.addBy,
    this.subscriptionNames,
    this.transactionId,
  });

  int? total;
  List<CitizenSubscription>? citizenSubscriptions;
  List<Subscription>? subscriptions;
  String? id;
  DateTime? date;
  String? addBy;
  String? subscriptionNames;
  String? transactionId;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        total: json["total"] == null ? null : json["total"],
        citizenSubscriptions: json["citizen_subscriptions"] == null
            ? null
            : List<CitizenSubscription>.from(json["citizen_subscriptions"]
                .map((x) => CitizenSubscription.fromJson(x))),
        subscriptions: json["subscriptions"] == null
            ? null
            : List<Subscription>.from(
                json["subscriptions"].map((x) => Subscription.fromJson(x))),
        id: json["_id"] == null ? null : json["_id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        addBy: json["add_by"] == null ? null : json["add_by"],
        subscriptionNames: json["subscription_names"] == null
            ? null
            : json["subscription_names"],
        transactionId: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "total": total == null ? null : total,
        "citizen_subscriptions": citizenSubscriptions == null
            ? null
            : List<dynamic>.from(citizenSubscriptions!.map((x) => x.toJson())),
        "subscriptions": subscriptions == null
            ? null
            : List<dynamic>.from(subscriptions!.map((x) => x.toJson())),
        "_id": id == null ? null : id,
        "date": date == null ? null : date!.toIso8601String(),
        "add_by": addBy == null ? null : addBy,
        "subscription_names":
            subscriptionNames == null ? null : subscriptionNames,
        "id": transactionId == null ? null : transactionId,
      };
}

class CitizenSubscription {
  CitizenSubscription({
    this.id,
    this.houseAddress,
    this.rw,
    this.rt,
    this.street,
    this.houseBlock,
    this.houseNumber,
    this.citizenName,
    this.citizenGender,
    this.citizenPhone,
    this.citizenSubscriptionId,
  });

  String? id;
  String? houseAddress;
  String? rw;
  String? rt;
  String? street;
  String? houseBlock;
  String? houseNumber;
  String? citizenName;
  String? citizenGender;
  String? citizenPhone;
  String? citizenSubscriptionId;

  factory CitizenSubscription.fromJson(Map<String, dynamic> json) =>
      CitizenSubscription(
        id: json["_id"] == null ? null : json["_id"],
        houseAddress:
            json["house_address"] == null ? null : json["house_address"],
        rw: json["rw"] == null ? null : json["rw"],
        rt: json["rt"] == null ? null : json["rt"],
        street: json["street"] == null ? null : json["street"],
        houseBlock: json["house_block"] == null ? null : json["house_block"],
        houseNumber: json["house_number"] == null ? null : json["house_number"],
        citizenName: json["citizen_name"] == null ? null : json["citizen_name"],
        citizenGender:
            json["citizen_gender"] == null ? null : json["citizen_gender"],
        citizenPhone:
            json["citizen_phone"] == null ? null : json["citizen_phone"],
        citizenSubscriptionId: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "house_address": houseAddress == null ? null : houseAddress,
        "rw": rw == null ? null : rw,
        "rt": rt == null ? null : rt,
        "street": street == null ? null : street,
        "house_block": houseBlock == null ? null : houseBlock,
        "house_number": houseNumber == null ? null : houseNumber,
        "citizen_name": citizenName == null ? null : citizenName,
        "citizen_gender": citizenGender == null ? null : citizenGender,
        "citizen_phone": citizenPhone == null ? null : citizenPhone,
        "id": citizenSubscriptionId == null ? null : citizenSubscriptionId,
      };
}

class Subscription {
  Subscription({
    this.amount,
    this.id,
    this.name,
    this.subscriptionId,
  });

  int? amount;
  String? id;
  String? name;
  String? subscriptionId;

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        amount: json["amount"] == null ? null : json["amount"],
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        subscriptionId: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount == null ? null : amount,
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "id": subscriptionId == null ? null : subscriptionId,
      };
}
