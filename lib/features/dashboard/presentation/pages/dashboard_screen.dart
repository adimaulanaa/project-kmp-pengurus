import 'package:after_layout/after_layout.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kmp_pengurus_app/env.dart';
import 'package:kmp_pengurus_app/features/bendahara/bendahara_screen.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/domain/entities/month.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/dashboard_chart_model.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/guest_book_model.dart';
import 'package:kmp_pengurus_app/features/dashboard/presentation/pages/guest_book_page.dart';
import 'package:kmp_pengurus_app/features/dues/presentation/pages/dues_page.dart';
import 'package:kmp_pengurus_app/features/master/master_page.dart';
import 'package:kmp_pengurus_app/features/profile/data/models/profile_model.dart';
import 'package:kmp_pengurus_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:kmp_pengurus_app/config/global_vars.dart';
import 'package:kmp_pengurus_app/config/string_resources.dart';
import 'package:kmp_pengurus_app/features/dashboard/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/framework/blocs/messaging/index.dart';
import 'package:kmp_pengurus_app/framework/managers/helper.dart';
import 'package:kmp_pengurus_app/theme/size.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with AfterLayoutMixin<DashboardScreen> {
  String message = '';
  bool isInternetConnected = true;
  String clientName = '';

  int? bulan;
  int? tahun;

  double rumahLunas = 0;
  double rumahBelumLunas = 0;

  List<MonthData> listMonth = [
    MonthData(name: 'Januari', value: 1),
    MonthData(name: 'Febuari', value: 2),
    MonthData(name: 'Maret', value: 3),
    MonthData(name: 'April', value: 4),
    MonthData(name: 'Mei', value: 5),
    MonthData(name: 'Juni', value: 6),
    MonthData(name: 'Juli', value: 7),
    MonthData(name: 'Agustus', value: 8),
    MonthData(name: 'September', value: 9),
    MonthData(name: 'Oktober', value: 10),
    MonthData(name: 'November', value: 11),
    MonthData(name: 'Desember', value: 12)
  ];

  List<DashboardChart> dataChart = [];
  Overall? dataSemua;

  List<Visitor> listDataGuest = [];

  TextEditingController editingController = TextEditingController();

  bool isSearch = false;
  List<Visitor> dummySearchList = [];
  List<Visitor> searchList = [];

  bool? isPic;
  bool? isTreasurer;
  Caretaker? caretaker;

  void searchResults(String value) {
    dummySearchList.clear();
    dummySearchList.addAll(listDataGuest);
    isSearch = true;
    if (value.isNotEmpty) {
      searchList.clear();
      dummySearchList.forEach((item) {
        if (item.name!.toString().toUpperCase().contains(value.toUpperCase())) {
          searchList.add(item);
        }
      });

      setState(() {});
      return;
    } else {
      setState(() {
        searchList.clear();
      });
    }
  }

  @override
  void initState() {
    super.initState();

    bulan = DateTime.now().month;
    tahun = DateTime.now().year;

    BlocProvider.of<MessagingBloc>(context).add(MessageLoaded());
    BlocProvider.of<DashboardBloc>(context).add(LoadDashboard());
    BlocProvider.of<DashboardBloc>(context).add(LoadGuestBook());
    BlocProvider.of<DashboardBloc>(context).add(GetUserSessionEvent());
    BlocProvider.of<DashboardBloc>(context)
        .add(GetChartDataEvent(year: tahun, month: bulan));
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      isInternetConnected =
          BlocProvider.of<MessagingBloc>(context).getConnection();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  Widget _build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DashboardBloc, DashboardState>(
            listener: (context, state) async {
          if (state is DashboardLoading) {
            final progress = ProgressHUD.of(context);
            progress?.showWithText(
                GlobalConfiguration().getValue(GlobalVars.TEXT_LOADING_TITLE) ??
                    StringResources.PLEASE_WAIT);
            setState(() {});
          } else if (state is DashboardLoaded) {
            final progress = ProgressHUD.of(context);
            if (state.data != null) {
              clientName = state.data!.client!.name!;
              setState(() {});
            }
            progress!.dismiss();
          } else if (state is UserSessionLoaded) {
            final progress = ProgressHUD.of(context);
            if (state.userSession != null) {
              caretaker = state.userSession!.caretaker;
              isPic = caretaker!.isPic!;
              isTreasurer = caretaker!.isTreasurer!;
              setState(() {});
            }
            progress!.dismiss();
          } else if (state is ChartDataLoaded) {
            final progress = ProgressHUD.of(context);
            if (state.chartData != null) {
              dataChart = state.chartData!.dashboards!;
              dataSemua = state.chartData!.overall!;
              rumahLunas =
                  dataSemua!.paid! / (dataSemua!.paid! + dataSemua!.unpaid!);
              rumahBelumLunas =
                  dataSemua!.unpaid! / (dataSemua!.paid! + dataSemua!.unpaid!);
              setState(() {});
            }
            progress!.dismiss();
          } else if (state is DashboardFailure) {
            catchAllException(context, state.error, true);
            final progress = ProgressHUD.of(context);
            progress!.dismiss();
            setState(() {});
          } else if (state is GuestBookLoaded) {
            final progress = ProgressHUD.of(context);
            if (state.data != null) {
              if (state.data!.visitors!.length > 0) {
                listDataGuest = state.data!.visitors!;
                setState(() {});
              }
              progress!.dismiss();
            }
          }
        }),
        BlocListener<MessagingBloc, MessagingState>(
            listener: (context, state) async {
          if (state is InMessagingState) {
            setState(() {
              isInternetConnected = state.isConnected;
              message = state.message;
            });
          } else if (state is InternetConnectionState) {
            setState(() {
              isInternetConnected = state.isConnected;
            });
          }
        }),
      ],
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xffF8F8F8),
          appBar: AppBar(
            backgroundColor: Color(0xffF54748),
            bottomOpacity: 0.0,
            elevation: 0.0,
            title: Text(
              clientName,
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontFamily: "Nunito"),
            ),
          ),
          body: SizedBox(
              child: Stack(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(color: Color(0xffF54748)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 25, right: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Container(),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                height: 27,
                                width: 106,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(21),
                                    color: Colors.black.withOpacity(0.1)),
                                child: Container(
                                  padding: EdgeInsets.only(left: 10),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Center(
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Theme(
                                              data: Theme.of(context).copyWith(
                                                canvasColor: Color(0xffDD4041),
                                              ),
                                              child: DropdownButton<int>(
                                                value: bulan,
                                                icon: SvgPicture.asset(
                                                    "assets/icon/arrow-down.svg"),
                                                iconSize: 24,
                                                underline: Container(
                                                  height: 2,
                                                ),
                                                onChanged: (int? newValue) {
                                                  setState(() {
                                                    bulan = newValue!;
                                                    BlocProvider.of<
                                                                DashboardBloc>(
                                                            context)
                                                        .add(GetChartDataEvent(
                                                            year: tahun,
                                                            month: bulan));
                                                  });
                                                },
                                                items: listMonth
                                                    .map(
                                                        (e) => DropdownMenuItem(
                                                            value: e.value,
                                                            child: Text(
                                                              "${e.name}",
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontFamily:
                                                                      "Nunito"),
                                                            )))
                                                    .toList(),
                                              ),
                                            ))),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          height: 200,
                          padding: EdgeInsets.only(left: 26),
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: dataChart.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                var item = dataChart[index];
                                var persenLunas = item.paid! /
                                    (item.paid! + item.unpaid!) *
                                    100;
                                var persenBelumLunas = item.unpaid! /
                                    (item.paid! + item.unpaid!) *
                                    100;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: Text(
                                                  item.unpaid.toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: "Nunito",
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 10,
                                                      color: Colors.white),
                                                ),
                                                height: persenBelumLunas,
                                                width: 38,
                                                decoration: BoxDecoration(
                                                    color: Color(0xffFFB61D),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(8),
                                                            topRight:
                                                                Radius.circular(
                                                                    8))),
                                              ),
                                              SizedBox(
                                                width: 50,
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: Text(
                                                  item.paid.toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: "Nunito",
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 10,
                                                      color: Colors.white),
                                                ),
                                                height: persenLunas,
                                                width: 38,
                                                decoration: persenLunas == 100
                                                    ? BoxDecoration(
                                                        color:
                                                            Color(0xff2FA9ED),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        8),
                                                                topRight: Radius
                                                                    .circular(
                                                                        8)))
                                                    : BoxDecoration(
                                                        color:
                                                            Color(0xff2FA9ED),
                                                      ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: Text(
                                          dataChart[index].name!,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: "Nunito"),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 23,
                                      ),
                                    ],
                                  ),
                                );
                              })),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              child: Container(
                                  height: 71,
                                  width: 157,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xffFFFFFF).withOpacity(0.2),
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: CircularPercentIndicator(
                                            radius: 50,
                                            lineWidth: 7.0,
                                            progressColor: Color(0xff2FA9ED),
                                            percent: rumahLunas,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 10, bottom: 12, top: 11),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    dataSemua != null
                                                        ? dataSemua!.paid
                                                            .toString()
                                                        : "",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontFamily: "Nunito"),
                                                  ),
                                                  Text(
                                                    "  Rumah",
                                                    style: TextStyle(
                                                        fontSize: 9,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: "Nunito"),
                                                  )
                                                ],
                                              ),
                                              Text(
                                                "Sudah Bayar",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w800,
                                                    fontFamily: "Nunito"),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ClipRRect(
                              child: Container(
                                  height: 71,
                                  width: 157,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xffFFFFFF).withOpacity(0.2),
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: CircularPercentIndicator(
                                            radius: 50,
                                            lineWidth: 7.0,
                                            progressColor: Color(0xffFFB61D),
                                            percent: rumahBelumLunas,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 10, bottom: 12, top: 11),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    dataSemua != null
                                                        ? dataSemua!.unpaid
                                                            .toString()
                                                        : "",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontFamily: "Nunito"),
                                                  ),
                                                  Text(
                                                    "  Rumah",
                                                    style: TextStyle(
                                                        fontSize: 9,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: "Nunito"),
                                                  )
                                                ],
                                              ),
                                              Text(
                                                "Belum Bayar",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w800,
                                                    fontFamily: "Nunito"),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
              SizedBox.expand(
                child: DraggableScrollableSheet(
                  initialChildSize: 0.4,
                  minChildSize: 0.4,
                  maxChildSize: 1,
                  builder: (BuildContext c, s) {
                    s.addListener(() {
                      print(s.offset.toString());
                    });
                    return Container(
                      margin: EdgeInsets.only(bottom: 53),
                      color: Color(0xffF8F8F8),
                      child: CustomScrollView(
                        controller: s,
                        slivers: <Widget>[
                          SliverAppBar(
                              bottom: PreferredSize(
                                preferredSize: Size.fromHeight(124.0),
                                child: Container(),
                              ),
                              backgroundColor: Color(0xffF8F8F8),
                              elevation: 0,
                              pinned: true,
                              automaticallyImplyLeading: false,
                              flexibleSpace: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 23),
                                    child: SvgPicture.asset(
                                        "assets/icon/line.svg"),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            pushNewScreen(
                                              context,
                                              screen: MasterPage(
                                                  isPic: isPic,
                                                  isTreasurer: isTreasurer),
                                              withNavBar: false,
                                              pageTransitionAnimation:
                                                  PageTransitionAnimation
                                                      .cupertino,
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                child: SvgPicture.asset(
                                                    "assets/icon/master.svg"),
                                                height: 57,
                                                width: 57,
                                                decoration: BoxDecoration(
                                                    color: Color(0xffF54748)
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            36)),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("Master Data",
                                                  style: TextPalette
                                                      .dashboardTextStyle)
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            pushNewScreen(
                                              context,
                                              screen: DuesPage(
                                                  isPic: isPic,
                                                  isTreasurer: isTreasurer),
                                              withNavBar: false,
                                              pageTransitionAnimation:
                                                  PageTransitionAnimation
                                                      .cupertino,
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                child: SvgPicture.asset(
                                                    "assets/icon/empty_wallet.svg"),
                                                height: 57,
                                                width: 57,
                                                decoration: BoxDecoration(
                                                    color: Color(0xff58C863)
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            36)),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("Iuran Warga",
                                                  style: TextPalette
                                                      .dashboardTextStyle)
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            pushNewScreen(
                                              context,
                                              screen: BendaharaScreen(
                                                isPic: isPic!,
                                                isTreasurer: isTreasurer!,
                                              ),
                                              withNavBar: false,
                                              pageTransitionAnimation:
                                                  PageTransitionAnimation
                                                      .cupertino,
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                child: SvgPicture.asset(
                                                    "assets/icon/wallet.svg"),
                                                height: 57,
                                                width: 57,
                                                decoration: BoxDecoration(
                                                    color: Color(0xffFFB61D)
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            36)),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("Bendahara",
                                                  style: TextPalette
                                                      .dashboardTextStyle)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 35, left: 14, right: 14),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                margin:
                                                    EdgeInsets.only(left: 15),
                                                child: Text(
                                                  "Daftar Tamu",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontFamily: "Nunito"),
                                                )),
                                            InkWell(
                                              onTap: () {
                                                pushNewScreen(
                                                  context,
                                                  screen: GuestBookPage(),
                                                  withNavBar: false,
                                                  pageTransitionAnimation:
                                                      PageTransitionAnimation
                                                          .cupertino,
                                                );
                                              },
                                              child: Container(
                                                  margin: EdgeInsets.only(
                                                      right: 15),
                                                  child: Text(
                                                    "Lihat Semua",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color:
                                                            Color(0xffF54748),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily: "Nunito"),
                                                  )),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, index) {
                              var outputFormat = DateFormat('hh:mm a');
                              var formattedTime = outputFormat.format(
                                  listDataGuest[index].acceptedAt!.toLocal());

                              DateFormat date = DateFormat.yMMMMd();
                              DateTime satDate = DateTime.parse(
                                  listDataGuest[index].acceptedAt.toString());
                              String tgl = date.format(satDate.toLocal());

                              var ktp = listDataGuest[index].idCardFile;
                              var selfi = listDataGuest[index].selfieFile;
                              // var selfi = listData[index]
                              return listDataGuest.length == 0
                                  ? Container(
                                      padding:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      child: Text(
                                        "Belum Ada Tamu Hari Ini",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Nunito"),
                                      ),
                                    )
                                  : Container(
                                      padding: EdgeInsets.only(
                                          top: 5,
                                          bottom: 10,
                                          left: 10,
                                          right: 10),
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xffFFFFFF),
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 15,
                                                    right: 15,
                                                    top: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(tgl,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Color(
                                                                0xff979797),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                "Nunito")),
                                                    Text(formattedTime,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Color(
                                                                0xff979797),
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontFamily:
                                                                "Nunito"))
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 15,
                                                    right: 15,
                                                    top: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("Nama Tamu",
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            color: Color(
                                                                0xff979797),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                "Nunito")),
                                                    Text("Rumah Tujuan",
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            color: Color(
                                                                0xff979797),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                "Nunito"))
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 15,
                                                    right: 15,
                                                    top: 7),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                      child: Text(
                                                          listDataGuest[index]
                                                              .name!,
                                                          maxLines: 2,
                                                          textAlign: TextAlign.left,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontFamily:
                                                                  "Nunito")),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                      child: Text(
                                                          listDataGuest[index]
                                                              .destinationPersonName!,
                                                          textAlign: TextAlign.right,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontFamily:
                                                                  "Nunito")),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 15,
                                                    right: 15,
                                                    top: 7),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text("Jumlah Tamu",
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Color(
                                                                    0xff979797),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    "Nunito")),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 5),
                                                          child: Text(
                                                              listDataGuest[
                                                                      index]
                                                                  .guestCount
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  fontFamily:
                                                                      "Nunito")),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                        listDataGuest[index]
                                                                .houseBlock! +
                                                            '-' +
                                                            listDataGuest[index]
                                                                .houseNumber!,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontFamily:
                                                                "Nunito"))
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    listDataGuest[index].open =
                                                        !listDataGuest[index]
                                                            .open!;
                                                  });
                                                },
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        right: 189,
                                                        left: 15,
                                                        top: 19),
                                                    child: !listDataGuest[index]
                                                            .open!
                                                        ? Text(
                                                            "Klik untuk melihat detail",
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color: Color(
                                                                    0xffF54748),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    "Nunito"))
                                                        : Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 88),
                                                            child: Text("Tutup",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: Color(
                                                                        0xffF54748),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontFamily:
                                                                        "Nunito")),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                              listDataGuest[index].open!
                                                  ? Container(
                                                      padding: EdgeInsets.only(
                                                        right: 15,
                                                        left: 15,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text("Keperluan",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: Color(
                                                                          0xff979797),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontFamily:
                                                                          "Nunito")),
                                                              Container(
                                                                width:
                                                                    Screen(size)
                                                                        .wp(60),
                                                                child: Text(
                                                                    listDataGuest[
                                                                            index]
                                                                        .necessity!,
                                                                    maxLines: 5,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color:
                                                                            Colors
                                                                                .black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontFamily:
                                                                            "Nunito")),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            children: [
                                                              Text("Foto KTP",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: Color(
                                                                          0xff979797),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontFamily:
                                                                          "Nunito")),
                                                              InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return Dialog(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          elevation:
                                                                              0.0,
                                                                          child:
                                                                              SingleChildScrollView(
                                                                            child: Container(
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(15),
                                                                                ),
                                                                                // height: 552,
                                                                                width: 300,
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    Container(
                                                                                      child: Container(
                                                                                        margin: EdgeInsets.only(top: 10, bottom: 10, right: 170),
                                                                                        child: Text("Foto KTP", style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Nunito")),
                                                                                      ),
                                                                                    ),
                                                                                    // Divider(),
                                                                                    Container(
                                                                                      child: ktp != null
                                                                                          ? Image.network(
                                                                                              '${Env().apiBaseUrl}/${ktp.url}',
                                                                                              height: 230,
                                                                                              width: 230,
                                                                                            )
                                                                                          : Container(
                                                                                              height: 180,
                                                                                              width: 180,
                                                                                              child: Image.asset(
                                                                                                "assets/images/no_ktp.png",
                                                                                              ),
                                                                                            ),
                                                                                    ),
                                                                                    Divider(),
                                                                                    Container(
                                                                                      child: Container(
                                                                                        margin: EdgeInsets.only(top: 10, bottom: 10, right: 170),
                                                                                        child: Text("Foto Selfi", style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Nunito")),
                                                                                      ),
                                                                                    ),

                                                                                    Container(
                                                                                      child: selfi != null
                                                                                          ? Image.network(
                                                                                              '${Env().apiBaseUrl}/${selfi.url}',
                                                                                              height: 230,
                                                                                              width: 230,
                                                                                            )
                                                                                          : Container(
                                                                                              height: 180,
                                                                                              width: 180,
                                                                                              child: Image.asset(
                                                                                                "assets/images/no_ktp.png",
                                                                                              ),
                                                                                            ),
                                                                                    ),
                                                                                    Divider(),
                                                                                    Container(
                                                                                      child: Container(
                                                                                        margin: EdgeInsets.only(top: 10, bottom: 10, right: 170),
                                                                                        child: Text("Keperluan", style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Nunito")),
                                                                                      ),
                                                                                    ),

                                                                                    Container(
                                                                                      width: Screen(size).wp(60),
                                                                                      child: Text(listDataGuest[index].necessity!, maxLines: 5, style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w700, fontFamily: "Nunito")),
                                                                                    ),
                                                                                    Divider(),
                                                                                    InkWell(
                                                                                      onTap: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: Container(
                                                                                        margin: EdgeInsets.only(top: 10, bottom: 10, left: 180),
                                                                                        child: Text("Close", textAlign: TextAlign.end, style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w800, fontFamily: "Nunito")),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                )),
                                                                          ),
                                                                        );
                                                                      });
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 100,
                                                                  width: 70,
                                                                  child: ktp !=
                                                                          null
                                                                      ? Image
                                                                          .network(
                                                                          '${Env().apiBaseUrl}/${ktp.url}',
                                                                          height:
                                                                              30,
                                                                        )
                                                                      : Container(
                                                                          height:
                                                                              50,
                                                                          width:
                                                                              50,
                                                                          child:
                                                                              Image.asset(
                                                                            "assets/images/no_ktp.png",
                                                                          ),
                                                                        ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ))
                                                  : Container(),
                                              SizedBox(
                                                height: 20,
                                              )
                                            ],
                                          )));
                            }, childCount: listDataGuest.length),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ))),
    );
  }
}
