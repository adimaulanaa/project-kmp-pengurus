// To parse this JSON data, do
//
//     final dashboardChartModel = dashboardChartModelFromJson(jsonString);

import 'dart:convert';

DashboardChartModel dashboardChartModelFromJson(String str) => DashboardChartModel.fromJson(json.decode(str));

String dashboardChartModelToJson(DashboardChartModel data) => json.encode(data.toJson());

class DashboardChartModel {
    DashboardChartModel({
        this.result,
        this.timestamp,
        this.dashboards,
        this.overall,
    });

    bool? result;
    int? timestamp;
    List<DashboardChart>? dashboards;
    Overall? overall;

    factory DashboardChartModel.fromJson(Map<String, dynamic> json) => DashboardChartModel(
        result: json["result"] == null ? null : json["result"],
        timestamp: json["timestamp"] == null ? null : json["timestamp"],
        dashboards: json["dashboards"] == null ? null : List<DashboardChart>.from(json["dashboards"].map((x) => DashboardChart.fromJson(x))),
        overall: json["overall"] == null ? null : Overall.fromJson(json["overall"]),
    );

    Map<String, dynamic> toJson() => {
        "result": result == null ? null : result,
        "timestamp": timestamp == null ? null : timestamp,
        "dashboards": dashboards == null ? null : List<dynamic>.from(dashboards!.map((x) => x.toJson())),
        "overall": overall == null ? null : overall!.toJson(),
    };
}

class DashboardChart {
    DashboardChart({
        this.name,
        this.rwRtName,
        this.paid,
        this.unpaid,
        this.total,
        this.percentage,
        this.percentageString,
    });

    String? name;
    String? rwRtName;
    int? paid;
    int? unpaid;
    int? total;
    num? percentage;
    String? percentageString;

    factory DashboardChart.fromJson(Map<String, dynamic> json) => DashboardChart(
        name: json["name"] == null ? null : json["name"],
        rwRtName: json["rw_rt_name"] == null ? null : json["rw_rt_name"],
        paid: json["paid"] == null ? null : json["paid"],
        unpaid: json["unpaid"] == null ? null : json["unpaid"],
        total: json["total"] == null ? null : json["total"],
        percentage: json["percentage"] == null ? null : json["percentage"],
        percentageString: json["percentage_string"] == null ? null : json["percentage_string"],
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "rw_rt_name": rwRtName == null ? null : rwRtName,
        "paid": paid == null ? null : paid,
        "unpaid": unpaid == null ? null : unpaid,
        "total": total == null ? null : total,
        "percentage": percentage == null ? null : percentage,
        "percentage_string": percentageString == null ? null : percentageString,
    };
}

class Overall {
    Overall({
        this.paid,
        this.unpaid,
        this.total,
        this.percentage,
        this.percentageString,
    });

    int? paid;
    int? unpaid;
    int? total;
    num? percentage;
    String? percentageString;

    factory Overall.fromJson(Map<String, dynamic> json) => Overall(
        paid: json["paid"] == null ? null : json["paid"],
        unpaid: json["unpaid"] == null ? null : json["unpaid"],
        total: json["total"] == null ? null : json["total"],
        percentage: json["percentage"] == null ? null : json["percentage"],
        percentageString: json["percentage_string"] == null ? null : json["percentage_string"],
    );

    Map<String, dynamic> toJson() => {
        "paid": paid == null ? null : paid,
        "unpaid": unpaid == null ? null : unpaid,
        "total": total == null ? null : total,
        "percentage": percentage == null ? null : percentage,
        "percentage_string": percentageString == null ? null : percentageString,
    };
}
