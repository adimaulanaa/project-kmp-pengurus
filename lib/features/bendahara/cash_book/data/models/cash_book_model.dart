// To parse this JSON data, do
//
//     final cashBookModel = cashBookModelFromJson(jsonString);

import 'dart:convert';

CashBookModel cashBookModelFromJson(String str) => CashBookModel.fromJson(json.decode(str));

String cashBookModelToJson(CashBookModel data) => json.encode(data.toJson());

class CashBookModel {
    CashBookModel({
        this.result,
        this.timestamp,
        this.cashBooks,
        this.total,
    });

    bool? result;
    int? timestamp;
    List<CashBook>? cashBooks;
    Total? total;

    factory CashBookModel.fromJson(Map<String, dynamic> json) => CashBookModel(
        result: json["result"] == null ? null : json["result"],
        timestamp: json["timestamp"] == null ? null : json["timestamp"],
        cashBooks: json["cash_books"] == null ? null : List<CashBook>.from(json["cash_books"].map((x) => CashBook.fromJson(x))),
        total: json["total"] == null ? null : Total.fromJson(json["total"]),
    );

    Map<String, dynamic> toJson() => {
        "result": result == null ? null : result,
        "timestamp": timestamp == null ? null : timestamp,
        "cash_books": cashBooks == null ? null : List<dynamic>.from(cashBooks!.map((x) => x.toJson())),
        "total": total == null ? null : total!.toJson(),
    };
}

class CashBook {
    CashBook({
        this.date,
        this.dateName,
        this.cashBookCategoryName,
        this.citizenName,
        this.monthNumber,
        this.year,
        this.paymentMonthName,
        this.name,
        this.type,
        this.total,
    });

    DateTime? date;
    String? dateName;
    String? cashBookCategoryName;
    String? citizenName;
    int? monthNumber;
    int? year;
    String? paymentMonthName;
    String? name;
    String? type;
    int? total;

    factory CashBook.fromJson(Map<String, dynamic> json) => CashBook(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        dateName: json["date_name"] == null ? null : json["date_name"],
        cashBookCategoryName: json["cash_book_category_name"] == null ? null : json["cash_book_category_name"],
        citizenName: json["citizen_name"] == null ? null : json["citizen_name"],
        monthNumber: json["month_number"] == null ? null : json["month_number"],
        year: json["year"] == null ? null : json["year"],
        paymentMonthName: json["payment_month_name"] == null ? null : json["payment_month_name"],
        name: json["name"] == null ? null : json["name"],
        type: json["type"] == null ? null : json["type"],
        total: json["total"] == null ? null : json["total"],
    );

    Map<String, dynamic> toJson() => {
        "date": date == null ? null : "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "date_name": dateName == null ? null : dateName,
        "cash_book_category_name": cashBookCategoryName == null ? null : cashBookCategoryName,
        "citizen_name": citizenName == null ? null : citizenName,
        "month_number": monthNumber == null ? null : monthNumber,
        "year": year == null ? null : year,
        "payment_month_name": paymentMonthName == null ? null : paymentMonthName,
        "name": name == null ? null : name,
        "type": type == null ? null : type,
        "total": total == null ? null : total,
    };
}

class Total {
    Total({
        this.income,
        this.outcome,
        this.balanceIncome,
        this.balanceOutcome,
        this.balanceCash,
        this.balanceStart,
        this.balanceEnd,
    });

    int? income;
    int? outcome;
    int? balanceIncome;
    int? balanceOutcome;
    int? balanceCash;
    int? balanceStart;
    int? balanceEnd;

    factory Total.fromJson(Map<String, dynamic> json) => Total(
        income: json["income"] == null ? null : json["income"],
        outcome: json["outcome"] == null ? null : json["outcome"],
        balanceIncome: json["balance_income"] == null ? null : json["balance_income"],
        balanceOutcome: json["balance_outcome"] == null ? null : json["balance_outcome"],
        balanceCash: json["balance_cash"] == null ? null : json["balance_cash"],
        balanceStart: json["balance_start"] == null ? null : json["balance_start"],
        balanceEnd: json["balance_end"] == null ? null : json["balance_end"],
    );

    Map<String, dynamic> toJson() => {
        "income": income == null ? null : income,
        "outcome": outcome == null ? null : outcome,
        "balance_income": balanceIncome == null ? null : balanceIncome,
        "balance_outcome": balanceOutcome == null ? null : balanceOutcome,
        "balance_cash": balanceCash == null ? null : balanceCash,
        "balance_start": balanceStart == null ? null : balanceStart,
        "balance_end": balanceEnd == null ? null : balanceEnd,
    };
}
