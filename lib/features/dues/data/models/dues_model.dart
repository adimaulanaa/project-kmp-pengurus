// To parse this JSON data, do
//
//     final citizenSubscriptionsModel = citizenSubscriptionsModelFromJson(jsonString);

import 'dart:convert';

CitizenSubscriptionsModel citizenSubscriptionsModelFromJson(String str) => CitizenSubscriptionsModel.fromJson(json.decode(str));

String citizenSubscriptionsModelToJson(CitizenSubscriptionsModel data) => json.encode(data.toJson());

class CitizenSubscriptionsModel {
    CitizenSubscriptionsModel({
        this.result,
        this.timestamp,
        this.months,
        this.years,
    });

    bool? result;
    int? timestamp;
    List<Month>? months;
    List<Year>? years;

    factory CitizenSubscriptionsModel.fromJson(Map<String, dynamic> json) => CitizenSubscriptionsModel(
        result: json["result"] == null ? null : json["result"],
        timestamp: json["timestamp"] == null ? null : json["timestamp"],
        months: json["months"] == null ? null : List<Month>.from(json["months"].map((x) => Month.fromJson(x))),
        years: json["years"] == null ? null : List<Year>.from(json["years"].map((x) => Year.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "result": result == null ? null : result,
        "timestamp": timestamp == null ? null : timestamp,
        "months": months == null ? null : List<dynamic>.from(months!.map((x) => x.toJson())),
        "years": years == null ? null : List<dynamic>.from(years!.map((x) => x.toJson())),
    };
}

class Month {
    Month({
        this.number,
        this.name,
        this.isPaidOff,
        this.percentage,
        this.percentageString,
        this.status,
        this.progressType,
        this.subscriptionPayments,
        this.paidInformation,
    });

    int? number;
    String? name;
    bool? isPaidOff;
    num? percentage;
    String? percentageString;
    String? status;
    String? progressType;
    List<SubscriptionPayment>? subscriptionPayments;
    String? paidInformation;

    factory Month.fromJson(Map<String, dynamic> json) => Month(
        number: json["number"] == null ? null : json["number"],
        name: json["name"] == null ? null : json["name"],
        isPaidOff: json["is_paid_off"] == null ? null : json["is_paid_off"],
        percentage: json["percentage"] == null ? null : json["percentage"],
        percentageString: json["percentage_string"] == null ? null : json["percentage_string"],
        status: json["status"] == null ? null : json["status"],
        progressType: json["progress_type"] == null ? null : json["progress_type"],
        subscriptionPayments: json["subscription_payments"] == null ? null : List<SubscriptionPayment>.from(json["subscription_payments"].map((x) => SubscriptionPayment.fromJson(x))),
        paidInformation: json["paid_information"] == null ? null : json["paid_information"],
    );

    Map<String, dynamic> toJson() => {
        "number": number == null ? null : number,
        "name": name == null ? null : name,
        "is_paid_off": isPaidOff == null ? null : isPaidOff,
        "percentage": percentage == null ? null : percentage,
        "percentage_string": percentageString == null ? null : percentageString,
        "status": status == null ? null : status,
        "progress_type": progressType == null ? null : progressType,
        "subscription_payments": subscriptionPayments == null ? null : List<dynamic>.from(subscriptionPayments!.map((x) => x.toJson())),
        "paid_information": paidInformation == null ? null : paidInformation,
    };
}

class SubscriptionPayment {
    SubscriptionPayment({
        this.id,
        this.name,
        this.amount,
        this.isPaid,
        this.isPayment,
        this.paidAt,
        this.paidAtString,
        this.paymentAcceptedByName,
        this.effectiveDate,
    });

    String? id;
    String? name;
    int? amount;
    bool? isPaid;
    bool? isPayment;
    DateTime? paidAt;
    String? paidAtString;
    String? paymentAcceptedByName;
    DateTime? effectiveDate;

    factory SubscriptionPayment.fromJson(Map<String, dynamic> json) => SubscriptionPayment(
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        amount: json["amount"] == null ? null : json["amount"],
        isPaid: json["is_paid"] == null ? null : json["is_paid"],
        isPayment: json["is_payment"] == null ? null : json["is_payment"],
        paidAt: json["paid_at"] == null ? null : DateTime.parse(json["paid_at"]),
        paidAtString: json["paid_at_string"] == null ? null : json["paid_at_string"],
        paymentAcceptedByName: json["payment_accepted_by_name"] == null ? null : json["payment_accepted_by_name"],
        effectiveDate: json["effective_date"] == null ? null : DateTime.parse(json["effective_date"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "amount": amount == null ? null : amount,
        "is_paid": isPaid == null ? null : isPaid,
        "is_payment": isPayment == null ? null : isPayment,
        "paid_at": paidAt == null ? null : paidAt.toString(),
        "paid_at_string": paidAtString == null ? null : paidAtString,
        "payment_accepted_by_name": paymentAcceptedByName == null ? null : paymentAcceptedByName,
        "effective_date": effectiveDate == null ? null : effectiveDate.toString(),
    };
}

class Year {
    Year({
        this.year,
        this.status,
    });

    int? year;
    String? status;

    factory Year.fromJson(Map<String, dynamic> json) => Year(
        year: json["year"] == null ? null : json["year"],
        status: json["status"] == null ? null : json["status"],
    );

    Map<String, dynamic> toJson() => {
        "year": year == null ? null : year,
        "status": status == null ? null : status,
    };
}
