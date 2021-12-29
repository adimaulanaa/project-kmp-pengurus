import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:kmp_pengurus_app/config/global_vars.dart';
import 'package:kmp_pengurus_app/config/string_resources.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/data/models/cash_book_model.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/domain/entities/month.dart';
import 'package:kmp_pengurus_app/features/financial/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/framework/managers/helper.dart';
import 'package:kmp_pengurus_app/framework/widgets/loading_indicator.dart';
import 'package:kmp_pengurus_app/theme/button.dart';
import 'package:kmp_pengurus_app/theme/colors.dart';
import 'package:kmp_pengurus_app/theme/enum.dart';
import 'package:kmp_pengurus_app/theme/size.dart';
import 'package:open_file/open_file.dart';

class DuesReportScreen extends StatefulWidget {
  final int? month;
  final int? year;

  const DuesReportScreen({Key? key, this.month, this.year}) : super(key: key);

  @override
  _DuesReportScreenState createState() => _DuesReportScreenState();
}

class _DuesReportScreenState extends State<DuesReportScreen> {
  bool isLoading = false;
  bool lunas = false;
  bool belumLunas = false;

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

  List<String> listNama = [];
  final List<Map<String, dynamic>> daftar = [
    {"nama": "RT 01", "ketua": "Pak Maulana", "isChecked": false},
    {"nama": "RT 02", "ketua": "Pak Davit", "isChecked": false},
    {"nama": "RT 04", "ketua": "Pak Ardy", "isChecked": false},
    {"nama": "RT 03", "ketua": "Pak Amir", "isChecked": false},
    {"nama": "RT 05", "ketua": "Ibu Alfi", "isChecked": false},
    {"nama": "RT 08", "ketua": "Pak Joko", "isChecked": false},
    {"nama": "RT 07", "ketua": "Pak Andri", "isChecked": false},
    {"nama": "RT 09", "ketua": "Ibu Zahra", "isChecked": false},
  ];

  int? bulan;
  int? tahun;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();

    month = widget.month;
    year = widget.year;

    bulan = DateTime.now().month;
    tahun = DateTime.now().year;

    listCashbook.clear();
    listPemasukan.clear();
    listPengeluaran.clear();

    BlocProvider.of<FinancialStatementBloc>(context)
        .add(GetCashBookFinancialEvent(year: tahun, month: bulan));
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  Widget _build(BuildContext context) {
    return BlocListener<FinancialStatementBloc, FinancialStatementState>(
      listener: (context, state) async {
        if (state is CashBookFinancialLoading) {
          final progress = ProgressHUD.of(context);
          progress?.showWithText(
              GlobalConfiguration().getValue(GlobalVars.TEXT_LOADING_TITLE) ??
                  StringResources.PLEASE_WAIT);
          setState(() {});
        } else if (state is CashBookFinancialLoaded) {
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
        } else if (state is GetPdfReportLoaded) {
          OpenFile.open(state.data);
        } else if (state is FinancialStatementFailure) {
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
              Text(
                "Laporan Iuran",
                style: TextStyle(
                    fontFamily: "Nunito",
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Colors.white),
              ),
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

                                  BlocProvider.of<FinancialStatementBloc>(
                                          context)
                                      .add(GetCashBookFinancialEvent(
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
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Iuran Lunas",
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Nunito"),
                    ),
                    Container(
                      child: listTotal == null
                          ? Text(
                              NumberFormat.currency(
                                      locale: 'id',
                                      symbol: 'Rp. ',
                                      decimalDigits: 0)
                                  .format(0),
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: "Nunito"),
                            )
                          : Text(
                              NumberFormat.currency(
                                      locale: 'id',
                                      symbol: 'Rp. ',
                                      decimalDigits: 0)
                                  .format(listTotal!.balanceStart),
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: "Nunito"),
                            ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Iuran Belum Lunas",
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Nunito"),
                    ),
                    Container(
                      child: listTotal == null
                          ? Text(
                              NumberFormat.currency(
                                      locale: 'id',
                                      symbol: 'Rp. ',
                                      decimalDigits: 0)
                                  .format(0),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: "Nunito"),
                            )
                          : Text(
                              NumberFormat.currency(
                                      locale: 'id',
                                      symbol: 'Rp. ',
                                      decimalDigits: 0)
                                  .format(listTotal!.balanceEnd),
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: "Nunito"),
                            ),
                    )
                  ],
                ),
              ),
              Container(
                // height: MediaQuery.of(context).size.height * 0.8,
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 10),
                child: KmpFlatButton(
                    onPressed: () async {
                      // var status = await Permission.storage.status;

                      // if (!status.isGranted) {
                      //   await Permission.storage.request();
                      // }
                      // BlocProvider.of<FinancialStatementBloc>(context).add(
                      //     GetPdfReportEvent(
                      //         year: tahun,
                      //         month: bulan,
                      //         type: 'financial_statement'));
                      showModalBottomSheet(
                          useRootNavigator: true,
                          isScrollControlled: true,
                          context: context,
                          // builder:
                          builder: (context) {
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Download Laporan',
                                            style: TextStyle(
                                                fontFamily: "Nunito",
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18,
                                                fontStyle: FontStyle.normal,
                                                color: Colors.black)),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              lunas = false;
                                              belumLunas = false;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            height: 28,
                                            width: 28,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                color: Colors.white),
                                            child: Icon(Icons.close),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    FormBuilder(
                                        key: _formKey,
                                        child: Theme(
                                            data: ThemeData(
                                              inputDecorationTheme:
                                                  InputDecorationTheme(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 10),
                                                errorBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color:
                                                            Colors.transparent),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    width: 3,
                                                    color: Colors.transparent,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    width: 3,
                                                    color: Colors.transparent,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    width: 3,
                                                    color: Colors.transparent,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                hintStyle: TextStyle(
                                                    color: Color(0xffD1D5DB)),
                                                labelStyle: TextStyle(
                                                    color: Color(0xffD1D5DB)),
                                                errorStyle: TextStyle(
                                                    color:
                                                        ColorPalette.primary),
                                                filled: true,
                                                fillColor: Color(0xffE5E5E5)
                                                    .withOpacity(0.5),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.never,
                                              ),
                                            ),
                                            child: Row(children: [
                                              Flexible(
                                                //!RT
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Dari Bulan',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Nunito",
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 13,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            color:
                                                                Colors.black)),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    FormBuilderDropdown(
                                                      name: 'monthStart',
                                                      onChanged: (val) {
                                                        // setState(() {
                                                        //   kategoriKas = val.toString();
                                                        // });
                                                      },
                                                      decoration:
                                                          InputDecoration(),
                                                      style: TextStyle(
                                                          fontFamily: "Nunito",
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                      validator:
                                                          FormBuilderValidators
                                                              .compose([
                                                        FormBuilderValidators
                                                            .required(context)
                                                      ]),
                                                      items: listMonth
                                                          .map((e) =>
                                                              DropdownMenuItem(
                                                                  value:
                                                                      e.value,
                                                                  child: Text(
                                                                    "${e.name}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontFamily:
                                                                            "Nunito"),
                                                                  )))
                                                          .toList(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Flexible(
                                                //!RW
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Sampai Bulan',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Nunito",
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 13,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            color:
                                                                Colors.black)),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    FormBuilderDropdown(
                                                      name: 'monthEnd',
                                                      onChanged: (val) {
                                                        // setState(() {
                                                        //   kategoriKas = val.toString();
                                                        // });
                                                      },
                                                      decoration:
                                                          InputDecoration(),
                                                      style: TextStyle(
                                                          fontFamily: "Nunito",
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                      validator:
                                                          FormBuilderValidators
                                                              .compose([
                                                        FormBuilderValidators
                                                            .required(context)
                                                      ]),
                                                      items: listMonth
                                                          .map((e) =>
                                                              DropdownMenuItem(
                                                                  value:
                                                                      e.value,
                                                                  child: Text(
                                                                    "${e.name}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontFamily:
                                                                            "Nunito"),
                                                                  )))
                                                          .toList(),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ]))),
                                    SizedBox(height: 10),
                                    Divider(),
                                    SizedBox(height: 10),
                                    Text('Status Iuran',
                                        style: TextStyle(
                                            fontFamily: "Nunito",
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.black)),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(children: [
                                      Flexible(
                                        //!Lunas
                                        child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                lunas = !lunas;
                                                if (belumLunas == true) {
                                                  belumLunas = false;
                                                }
                                              });
                                            },
                                            child: Container(
                                                height: 50,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    color: lunas == false
                                                        ? Color(0xffE5E5E5)
                                                            .withOpacity(0.5)
                                                        : Color(0xff58C863)
                                                            .withOpacity(0.5)),
                                                child: Center(
                                                  child: Text(
                                                    "Lunas",
                                                    style: TextStyle(
                                                        fontFamily: "Nunito",
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 14,
                                                        color: lunas == false
                                                            ? Colors.black
                                                                .withOpacity(
                                                                    0.8)
                                                            : Colors.white),
                                                  ),
                                                ))),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Flexible(
                                        //!Belum Lunas
                                        child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                belumLunas = !belumLunas;
                                                if (lunas == true) {
                                                  lunas = false;
                                                }
                                              });
                                            },
                                            child: Container(
                                                height: 50,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    color: belumLunas == false
                                                        ? Color(0xffE5E5E5)
                                                            .withOpacity(0.5)
                                                        : Color(0xffE33A4E)
                                                            .withOpacity(0.5)),
                                                child: Center(
                                                  child: Text(
                                                    "Belum Lunas",
                                                    style: TextStyle(
                                                        fontFamily: "Nunito",
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 14,
                                                        color: belumLunas ==
                                                                false
                                                            ? Colors.black
                                                                .withOpacity(
                                                                    0.8)
                                                            : Colors.white),
                                                  ),
                                                ))),
                                      )
                                    ]),
                                    SizedBox(height: 10),
                                    Divider(),
                                    SizedBox(height: 10),
                                    Text("Pilih RT",
                                        style: TextStyle(
                                            fontFamily: "Nunito",
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.black)),
                                    SizedBox(height: 10),
                                    Expanded(
                                      child: Container(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: daftar.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            final item = daftar[index];

                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  item['isChecked'] =
                                                      !item['isChecked'];
                                                  this.onchange(item['nama'],
                                                      item['isChecked']);
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 8, right: 8),
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color: item['isChecked'] ==
                                                            true
                                                        ? Color(0xff58C863)
                                                            .withOpacity(0.5)
                                                        : Color(0xffE5E5E5)),
                                                child: Center(
                                                  child: Text(
                                                    item['nama'],
                                                    style: TextStyle(
                                                      fontFamily: "Nunito",
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 13,
                                                      color:
                                                          item['isChecked'] ==
                                                                  true
                                                              ? Colors.white
                                                              : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(child: SizedBox()),
                                    KmpFlatButton(
                                      fullWidth: true,
                                      buttonType: ButtonType.primary,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      title: 'Download',
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              );
                            });
                          });
                    },
                    fullWidth: true,
                    buttonType: ButtonType.secondary,
                    title: "Unduh Laporan"),
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
                  padding: EdgeInsets.only(bottom: 65),
                  color: Color(0xffF8F8F8),
                  child: CustomScrollView(
                    controller: s,
                    slivers: <Widget>[
                      SliverAppBar(
                        // bottom: PreferredSize(
                        //   preferredSize: Size.fromHeight(10.0),
                        //   child: Container(),
                        // ),
                        backgroundColor: Color(0xffF8F8F8),
                        elevation: 0,
                        pinned: true,
                        automaticallyImplyLeading: false,
                        flexibleSpace: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: SvgPicture.asset("assets/icon/line.svg"),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                padding: EdgeInsets.only(left: 25, top: 15),
                                child: Text(
                                  "Daftar Transaksi Iuran",
                                  style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.black.withOpacity(0.8)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SliverGroupedListView<dynamic, String>(
                        elements: listPemasukan,
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
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 60,
                                      child: listPemasukan.length <= 0
                                          ? Container(
                                              child: Text(
                                                "Tidak Ada Data",
                                                maxLines: 3,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: "Nunito",
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: small ? 10 : 12,
                                                    fontStyle: FontStyle.normal,
                                                    color: Colors.black
                                                        .withOpacity(0.8)),
                                              ),
                                            )
                                          : Card(
                                              elevation: 1,
                                              shadowColor: Colors.black38,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
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
                                                              EdgeInsets.all(3),
                                                          height: 23,
                                                          width: 23,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  width: 1.5,
                                                                  color: Color(
                                                                      0xff58C863)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16)),
                                                          child: SvgPicture.asset(
                                                              "assets/icon/arrow_down.svg"),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          width: Screen(size)
                                                              .wp(40),
                                                          child: Text(
                                                            element.name!,
                                                            maxLines: 3,
                                                            textAlign: TextAlign
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
                                                      "+ " +
                                                          NumberFormat.currency(
                                                                  locale: 'id',
                                                                  symbol:
                                                                      'Rp. ',
                                                                  decimalDigits:
                                                                      0)
                                                              .format(element
                                                                  .total),
                                                      style: TextStyle(
                                                          fontFamily: "Nunito",
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontSize:
                                                              small ? 10 : 12,
                                                          fontStyle:
                                                              FontStyle.normal,
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
                    ],
                  ),
                );
              },
            ),
          )
        ],
      )),
    );
  }

  void onchange(String nama, bool isCheck) {
    setState(() {
      if (isCheck) {
        if (listNama.contains(nama)) {
        } else {
          listNama.add(nama.toString());
        }
      } else {
        if (listNama.contains(nama)) {
          listNama.remove(nama);
        }
      }
      print(listNama.toString());
    });
  }
}
