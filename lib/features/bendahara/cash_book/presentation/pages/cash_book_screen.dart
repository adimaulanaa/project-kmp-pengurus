import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:kmp_pengurus_app/config/global_vars.dart';
import 'package:kmp_pengurus_app/config/string_resources.dart';
import 'package:kmp_pengurus_app/features/bendahara/bendahara_screen.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/data/models/cash_book_model.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/domain/entities/month.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/presentation/pages/add_cash_screen.dart';
import 'package:kmp_pengurus_app/framework/managers/helper.dart';
import 'package:kmp_pengurus_app/framework/widgets/loading_indicator.dart';
import 'package:kmp_pengurus_app/service_locator.dart';
import 'package:kmp_pengurus_app/theme/button.dart';
import 'package:kmp_pengurus_app/theme/colors.dart';
import 'package:kmp_pengurus_app/theme/enum.dart';
import 'package:kmp_pengurus_app/theme/size.dart';

class CashBookScreen extends StatefulWidget {
  final int? month;
  final int? year;
  final bool isPic;
  final bool isTreasurer;

  const CashBookScreen(
      {Key? key,
      this.month,
      this.year,
      required this.isPic,
      required this.isTreasurer})
      : super(key: key);

  @override
  _CashBookScreenState createState() => _CashBookScreenState();
}

class _CashBookScreenState extends State<CashBookScreen> {
  bool isLoading = false;
  bool semua = true;
  bool pemasukan = false;
  bool pengeluaran = false;

  int? month;
  int? year;
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
  Total? listTotal;
  List<CashBook> listCashbook = [];
  List<CashBook> listPemasukan = [];
  List<CashBook> listPengeluaran = [];

  int? bulan;
  int? tahun;
  bool? isPic;
  bool? isTreasurer;

  @override
  void initState() {
    super.initState();

    month = widget.month;
    year = widget.year;
    isPic = widget.isPic;
    isTreasurer = widget.isTreasurer;

    bulan = DateTime.now().month;
    tahun = DateTime.now().year;

    listCashbook.clear();
    listPemasukan.clear();
    listPengeluaran.clear();

    BlocProvider.of<CashBookBloc>(context)
        .add(GetCashBookDataEvent(year: year, month: month));
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  Widget _build(BuildContext context) {
    return BlocListener<CashBookBloc, CashBookState>(
      listener: (context, state) async {
        if (state is CashBookLoading) {
          final progress = ProgressHUD.of(context);
          progress?.showWithText(
              GlobalConfiguration().getValue(GlobalVars.TEXT_LOADING_TITLE) ??
                  StringResources.PLEASE_WAIT);
          setState(() {});
        } else if (state is CashBookDataLoaded) {
          final progress = ProgressHUD.of(context);
          if (state.data != null && state.data!.total != null) {
            if (state.data!.cashBooks!.length > 0) {
              listCashbook.clear();
              listPemasukan.clear();
              listPengeluaran.clear();

              listCashbook = state.data!.cashBooks!;
              listCashbook.forEach((element) {
                if (element.type == "PEMASUKAN") {
                  listPemasukan.add(element);
                } else if (element.type == "PENGELUARAN") {
                  listPengeluaran.add(element);
                }
              });
            } else {
              listCashbook = [];
              listPemasukan = [];
              listPengeluaran = [];
            }

            listTotal = state.data!.total!;

            isLoading = true;
            setState(() {});
          }
          progress!.dismiss();
        } else if (state is CashBookFailure) {
          catchAllException(context, state.error, true);
          setState(() {});
        }
      },
      child: isLoading ? _buildBody(context) : LoadingIndicator(),
    );
  }

  Widget _buildBody(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool small = false;
    if (size.width <= 320) {
      small = true;
    }
    return Scaffold(
      backgroundColor: Color(0xffF54748),
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Color(0xffF54748),
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(
            left: 5,
            right: 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider(
                                  create: (context) =>
                                      serviceLocator.get<CashBookBloc>(),
                                  child: ProgressHUD(
                                    child: BendaharaScreen(
                                        isPic: isPic!,
                                        isTreasurer: isTreasurer!),
                                  ),
                                )));
                  },
                  child: Container(
                    padding: EdgeInsets.all(7),
                    height: 33,
                    width: 33,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 1.5,
                            blurRadius: 15,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(16),
                        color: Color(0xffF54748)),
                    child: SvgPicture.asset(
                      "assets/icon/back.svg",
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Buku Kas",
                  style: TextStyle(
                      fontFamily: "Nunito",
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: Colors.white),
                )
              ]),
              Container(
                height: 27,
                width: 106,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21),
                    color: Colors.black.withOpacity(0.1)),
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Center(
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
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

                                  listCashbook.clear();
                                  listPemasukan.clear();
                                  listPengeluaran.clear();

                                  final progress = ProgressHUD.of(context);

                                  progress!.showWithText(GlobalConfiguration()
                                          .getValue(
                                              GlobalVars.TEXT_LOADING_TITLE) ??
                                      StringResources.PLEASE_WAIT);

                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());

                                  BlocProvider.of<CashBookBloc>(context).add(
                                      GetCashBookDataEvent(
                                          year: tahun, month: bulan));
                                  progress.dismiss();
                                });
                              },
                              items: listMonth
                                  .map((e) => DropdownMenuItem(
                                      value: e.value,
                                      child: Text(
                                        "${e.name}",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Nunito"),
                                      )))
                                  .toList(),
                            ),
                          ))),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SizedBox(
          child: Stack(
        children: <Widget>[
          // bagian atas
          Column(
            children: [
              Text(
                "Saldo Kas",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Nunito"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: listTotal == null
                    ? Text(
                        NumberFormat.currency(
                                locale: 'id', symbol: 'Rp. ', decimalDigits: 0)
                            .format(0),
                        style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontFamily: "Nunito"),
                      )
                    : Text(
                        NumberFormat.currency(
                                locale: 'id', symbol: 'Rp. ', decimalDigits: 0)
                            .format(listTotal!.balanceCash),
                        style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontFamily: "Nunito"),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.2), width: 2)),
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/icon/income.svg"),
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Column(
                              children: [
                                Text(
                                  "Pemasukan",
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Nunito"),
                                ),
                                listTotal!.income == null
                                    ? Text(
                                        NumberFormat.currency(
                                                locale: 'id',
                                                symbol: 'Rp. ',
                                                decimalDigits: 0)
                                            .format(0),
                                        style: TextStyle(
                                            fontSize: 28,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: "Nunito"),
                                      )
                                    : Text(
                                        NumberFormat.currency(
                                                locale: 'id',
                                                symbol: 'Rp. ',
                                                decimalDigits: 0)
                                            .format(listTotal!.income),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Nunito"),
                                      )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.2), width: 2)),
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/icon/expenditure.svg"),
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Column(
                              children: [
                                Text(
                                  "Pengeluaran",
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Nunito"),
                                ),
                                listTotal!.outcome == null
                                    ? Text(
                                        NumberFormat.currency(
                                                locale: 'id',
                                                symbol: 'Rp. ',
                                                decimalDigits: 0)
                                            .format(0),
                                        style: TextStyle(
                                            fontSize: 28,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: "Nunito"),
                                      )
                                    : Text(
                                        NumberFormat.currency(
                                                locale: 'id',
                                                symbol: 'Rp. ',
                                                decimalDigits: 0)
                                            .format(listTotal!.outcome),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Nunito"),
                                      )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          // bagian bawah
          SizedBox.expand(
            child: DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.7,
              maxChildSize: 1,
              builder: (BuildContext c, s) {
                return Container(
                  color: Color(0xffF8F8F8),
                  child: CustomScrollView(
                    controller: s,
                    slivers: <Widget>[
                      SliverAppBar(
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(20.0),
                          child: Container(),
                        ),
                        backgroundColor: Color(0xffF8F8F8),
                        elevation: 0,
                        pinned: true,
                        automaticallyImplyLeading: false,
                        flexibleSpace: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 5, bottom: 10),
                              child: SvgPicture.asset("assets/icon/line.svg"),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                left: 20,
                                right: 20,
                              ),
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffE5E5E5).withOpacity(0.5)),
                              child: Row(children: [
                                Flexible(
                                  //!Semua
                                  child: InkWell(
                                      child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: semua == false
                                            ? Colors.transparent
                                            : ColorPalette.primary),
                                    child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            semua = true;
                                            pemasukan = false;
                                            pengeluaran = false;
                                          });
                                        },
                                        child: Text(
                                          "Semua",
                                          style: TextStyle(
                                              fontFamily: "Nunito",
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                              color: semua == false
                                                  ? Color(0xffC4C4C4)
                                                  : Colors.white),
                                        )),
                                  )),
                                ),
                                Flexible(
                                  //!Pemasukan
                                  child: InkWell(
                                      child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: pemasukan == false
                                            ? Colors.transparent
                                            : ColorPalette.primary),
                                    child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            semua = false;
                                            pemasukan = true;
                                            pengeluaran = false;
                                          });
                                        },
                                        child: Text(
                                          "Pemasukan",
                                          style: TextStyle(
                                              fontFamily: "Nunito",
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                              color: pemasukan == false
                                                  ? Color(0xffC4C4C4)
                                                  : Colors.white),
                                        )),
                                  )),
                                ),
                                Flexible(
                                  //!Pengeluaran
                                  child: InkWell(
                                      child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: pengeluaran == false
                                            ? Colors.transparent
                                            : ColorPalette.primary),
                                    child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            semua = false;
                                            pemasukan = false;
                                            pengeluaran = true;
                                          });
                                        },
                                        child: Text(
                                          "Pengeluaran",
                                          style: TextStyle(
                                              fontFamily: "Nunito",
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                              color: pengeluaran == false
                                                  ? Color(0xffC4C4C4)
                                                  : Colors.white),
                                        )),
                                  )),
                                )
                              ]),
                            ),
                          ],
                        ),
                      ),
                      semua
                          ? SliverGroupedListView<dynamic, String>(
                              elements: listCashbook,
                              groupBy: (element) => element.dateName,
                              groupComparator: (value1, value2) =>
                                  value2.compareTo(value1),
                              itemComparator: (item1, item2) =>
                                  item1.name.compareTo(item2.name),
                              order: GroupedListOrder.DESC,
                              groupSeparatorBuilder: (String value) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  value,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Nunito"),
                                ),
                              ),
                              itemBuilder: (c, element) {
                                return InkWell(
                                  onTap: () {},
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 60,
                                            child: listCashbook.length <= 0
                                                ? Container(
                                                    child: Text(
                                                      "Tidak Ada Data",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily: "Nunito",
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontSize:
                                                              small ? 10 : 12,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.8)),
                                                    ),
                                                  )
                                                : Card(
                                                    elevation: 1,
                                                    shadowColor: Colors.black38,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
                                                    ),
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: 18, right: 16),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(3),
                                                                height: 23,
                                                                width: 23,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        width:
                                                                            1.5,
                                                                        color: element.type ==
                                                                                "PEMASUKAN"
                                                                            ? Color(
                                                                                0xff58C863)
                                                                            : ColorPalette
                                                                                .primary),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16)),
                                                                child: element
                                                                            .type ==
                                                                        "PEMASUKAN"
                                                                    ? SvgPicture
                                                                        .asset(
                                                                            "assets/icon/arrow_down.svg")
                                                                    : SvgPicture
                                                                        .asset(
                                                                            "assets/icon/arrow-up.svg"),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Container(
                                                                width:
                                                                    Screen(size)
                                                                        .wp(40),
                                                                child: Text(
                                                                  element.name!,
                                                                  maxLines: 3,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "Nunito",
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                      fontSize: small
                                                                          ? 10
                                                                          : 12,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.8)),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          Text(
                                                            element.type ==
                                                                    "PEMASUKAN"
                                                                ? "+ " +
                                                                    NumberFormat.currency(
                                                                            locale:
                                                                                'id',
                                                                            symbol:
                                                                                'Rp. ',
                                                                            decimalDigits:
                                                                                0)
                                                                        .format(element
                                                                            .total)
                                                                : "- " +
                                                                    NumberFormat.currency(
                                                                            locale:
                                                                                'id',
                                                                            symbol:
                                                                                'Rp. ',
                                                                            decimalDigits:
                                                                                0)
                                                                        .format(
                                                                            element.total)
                                                                        .toString(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Nunito",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                fontSize: small
                                                                    ? 10
                                                                    : 12,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                color: element
                                                                            .type ==
                                                                        "PEMASUKAN"
                                                                    ? Color(
                                                                        0xff58C863)
                                                                    : ColorPalette
                                                                        .primary),
                                                          )
                                                        ],
                                                      ),
                                                    )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : pemasukan
                              ? SliverGroupedListView<dynamic, String>(
                                  elements: listPemasukan,
                                  groupBy: (element) => element.dateName,
                                  groupComparator: (value1, value2) =>
                                      value2.compareTo(value1),
                                  itemComparator: (item1, item2) =>
                                      item1.name.compareTo(item2.name),
                                  order: GroupedListOrder.DESC,
                                  groupSeparatorBuilder: (String value) =>
                                      Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      value,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Nunito"),
                                    ),
                                  ),
                                  itemBuilder: (c, element) {
                                    return InkWell(
                                      onTap: () {},
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15),
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 60,
                                                child: listPemasukan.length <= 0
                                                    ? Container(
                                                        child: Text(
                                                          "Tidak Ada Data",
                                                          maxLines: 3,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Nunito",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: small
                                                                  ? 10
                                                                  : 12,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.8)),
                                                        ),
                                                      )
                                                    : Card(
                                                        elevation: 1,
                                                        shadowColor:
                                                            Colors.black38,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16.0),
                                                        ),
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 18,
                                                                  right: 16),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(3),
                                                                    height: 23,
                                                                    width: 23,
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                            width:
                                                                                1.5,
                                                                            color: Color(
                                                                                0xff58C863)),
                                                                        borderRadius:
                                                                            BorderRadius.circular(16)),
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            "assets/icon/arrow_down.svg"),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Container(
                                                                    width: Screen(
                                                                            size)
                                                                        .wp(40),
                                                                    child: Text(
                                                                      element
                                                                          .name!,
                                                                      maxLines:
                                                                          3,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "Nunito",
                                                                          fontWeight: FontWeight
                                                                              .w800,
                                                                          fontSize: small
                                                                              ? 10
                                                                              : 12,
                                                                          fontStyle: FontStyle
                                                                              .normal,
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0.8)),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              Text(
                                                                "+ " +
                                                                    NumberFormat.currency(
                                                                            locale:
                                                                                'id',
                                                                            symbol:
                                                                                'Rp. ',
                                                                            decimalDigits:
                                                                                0)
                                                                        .format(
                                                                            element.total),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Nunito",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    fontSize:
                                                                        small
                                                                            ? 10
                                                                            : 12,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    color: element.type ==
                                                                            "PEMASUKAN"
                                                                        ? Color(
                                                                            0xff58C863)
                                                                        : ColorPalette
                                                                            .primary),
                                                              )
                                                            ],
                                                          ),
                                                        )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : pengeluaran
                                  ? SliverGroupedListView<dynamic, String>(
                                      elements: listPengeluaran,
                                      groupBy: (element) => element.dateName,
                                      groupComparator: (value1, value2) =>
                                          value2.compareTo(value1),
                                      itemComparator: (item1, item2) =>
                                          item1.name.compareTo(item2.name),
                                      order: GroupedListOrder.DESC,
                                      groupSeparatorBuilder: (String value) =>
                                          Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          value,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "Nunito"),
                                        ),
                                      ),
                                      itemBuilder: (c, element) {
                                        return InkWell(
                                          onTap: () {},
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15, right: 15),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 60,
                                                    child: listPengeluaran
                                                                .length <=
                                                            0
                                                        ? Container(
                                                            child: Text(
                                                              "Tidak Ada Data",
                                                              maxLines: 3,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Nunito",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  fontSize:
                                                                      small
                                                                          ? 10
                                                                          : 12,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.8)),
                                                            ),
                                                          )
                                                        : Card(
                                                            elevation: 1,
                                                            shadowColor:
                                                                Colors.black38,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16.0),
                                                            ),
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 18,
                                                                      right:
                                                                          16),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.all(3),
                                                                        height:
                                                                            23,
                                                                        width:
                                                                            23,
                                                                        decoration: BoxDecoration(
                                                                            border:
                                                                                Border.all(width: 1.5, color: ColorPalette.primary),
                                                                            borderRadius: BorderRadius.circular(16)),
                                                                        child: element.type ==
                                                                                "PEMASUKAN"
                                                                            ? SvgPicture.asset("assets/icon/arrow_down.svg")
                                                                            : SvgPicture.asset("assets/icon/arrow-up.svg"),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Container(
                                                                        width: Screen(size)
                                                                            .wp(40),
                                                                        child:
                                                                            Text(
                                                                          element
                                                                              .name!,
                                                                          maxLines:
                                                                              3,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: TextStyle(
                                                                              fontFamily: "Nunito",
                                                                              fontWeight: FontWeight.w800,
                                                                              fontSize: small ? 10 : 12,
                                                                              fontStyle: FontStyle.normal,
                                                                              color: Colors.black.withOpacity(0.8)),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Text(
                                                                    element.type ==
                                                                            "PEMASUKAN"
                                                                        ? "+ " +
                                                                            NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0).format(element
                                                                                .total)
                                                                        : "- " +
                                                                            NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0).format(element.total).toString(),
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "Nunito",
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w800,
                                                                        fontSize: small
                                                                            ? 10
                                                                            : 12,
                                                                        fontStyle:
                                                                            FontStyle
                                                                                .normal,
                                                                        color: element.type ==
                                                                                "PEMASUKAN"
                                                                            ? Color(0xff58C863)
                                                                            : ColorPalette.primary),
                                                                  )
                                                                ],
                                                              ),
                                                            )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Container()
                    ],
                  ),
                );
              },
            ),
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: isTreasurer!
            ? () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlocProvider(
                              create: (context) =>
                                  serviceLocator.get<CashBookBloc>(),
                              child: ProgressHUD(
                                  child: AddCashScreen(
                                isPic: isPic!,
                                isTreasurer: isTreasurer!,
                              )),
                            )));
                BlocProvider.of<CashBookBloc>(context)
                    .add(GetCashBookDataEvent(year: year, month: month));
              }
            : () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 340,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Informasi',
                                    style: TextStyle(
                                        fontFamily: "Nunito",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.black)),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 28,
                                    width: 28,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: Colors.white),
                                    child: Icon(Icons.close),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            Image.asset(
                              'assets/images/denied.png',
                              height: 90,
                            ),
                            SizedBox(height: 30),
                            Text(
                              'Maaf, Anda Tidak Memiliki Akses Untuk Fitur Ini',
                              textAlign: TextAlign.center,
                              style: TextPalette.txt14.copyWith(
                                  color: ColorPalette.black,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: 30),
                            KmpFlatButton(
                              fullWidth: true,
                              buttonType: ButtonType.primary,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              title: 'OK',
                            ),
                          ],
                        ),
                      );
                    });
              },
        backgroundColor: ColorPalette.primary,
        child: Icon(
          Icons.add,
          size: 36,
        ),
      ),
    );
  }
}
