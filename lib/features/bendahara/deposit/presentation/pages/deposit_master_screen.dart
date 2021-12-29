import 'dart:ui';

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:intl/intl.dart';
import 'package:kmp_pengurus_app/config/global_vars.dart';
import 'package:kmp_pengurus_app/config/string_resources.dart';
import 'package:kmp_pengurus_app/features/bendahara/bendahara_screen.dart';
import 'package:kmp_pengurus_app/features/bendahara/deposit/data/models/deposit_model.dart';
import 'package:kmp_pengurus_app/features/bendahara/deposit/domain/entities/post_deposit.dart';
import 'package:kmp_pengurus_app/features/bendahara/deposit/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/service_locator.dart';
import 'package:kmp_pengurus_app/theme/button.dart';
import 'package:kmp_pengurus_app/theme/enum.dart';
import 'package:kmp_pengurus_app/framework/managers/helper.dart';

class DepositScreen extends StatefulWidget {
  final bool? isPic;
  final bool? isTreasurer;
  DepositScreen({Key? key, required this.isPic, required this.isTreasurer})
      : super(key: key);

  @override
  _DepositScreenState createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  List<Option> listPetugas = [];
  bool isLoading = false;

  String? nmPetugas;
  String? _addby;

  List<Option> items = [];
  List<Option> listRumah = [];
  List<Transaction>? trans;
  Option? selectedCaretacer;
  late PostDeposit itemDeposit;
  List<String> listTransaction = [];
  bool? isPic;
  bool? isTreasurer;

  @override
  void initState() {
    super.initState();
    isPic = widget.isPic;
    isTreasurer = widget.isTreasurer;
    BlocProvider.of<DepositBloc>(context).add(LoadDeposit());
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
    return BlocListener<DepositBloc, DepositState>(
      listener: (context, state) async {
        if (state is DepositLoading) {
          final progress = ProgressHUD.of(context);
          progress?.showWithText(
              GlobalConfiguration().getValue(GlobalVars.TEXT_LOADING_TITLE) ??
                  StringResources.PLEASE_WAIT);
          setState(() {});
        } else if (state is DepositLoaded) {
          final progress = ProgressHUD.of(context);
          if (state.data! != null && state.data!.options!.length > 0) {
            listPetugas = state.data!.options!;
            isLoading = true;
            setState(() {});
          }
          progress!.dismiss();
        } else if (state is DepositSuccess) {
          _thankYouPopup();
        } else if (state is DepositFailure) {
          catchAllException(context, state.error, true);
          final progress = ProgressHUD.of(context);
          progress!.dismiss();
          setState(() {});
          FlushbarHelper.createError(
            message: state.error,
            title: "Error",
          )..show(context);
        }
      },
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Color(0xffF8F8F8),
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(
            left: 5,
            right: 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BlocProvider(
                                create: (context) =>
                                    serviceLocator.get<DepositBloc>(),
                                child: ProgressHUD(
                                  child: BendaharaScreen(
                                      isPic: isPic!, isTreasurer: isTreasurer!),
                                ),
                              )));
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 33,
                  width: 33,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 1.5,
                          blurRadius: 15,
                          offset: Offset(0, 1),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white),
                  child: SvgPicture.asset(
                    "assets/icon/back.svg",
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Setoran',
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Masukan Setoran Petugas",
                style: TextStyle(fontSize: 12, color: Color(0xff979797)),
              ),
            ),
          ),
          SizedBox(
            width: 190,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 25),
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        height: 300,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 24, right: 24, top: 20, bottom: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        child: Text("Petugas",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18))),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 28,
                                        width: 28,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.05),
                                                spreadRadius: 1.5,
                                                blurRadius: 15,
                                                offset: Offset(0, 1),
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            color: Colors.white),
                                        child: Icon(Icons.close),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              GridView.builder(
                                  physics: new NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 5 / 2,
                                          crossAxisSpacing: 2,
                                          mainAxisSpacing: 2),
                                  itemCount: listPetugas.length,
                                  itemBuilder: (BuildContext ctx, index) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedCaretacer =
                                              listPetugas[index];
                                          listTransaction.clear();
                                          selectedCaretacer!.transactions!
                                              .forEach((element) {
                                            listTransaction.add(element.id!);
                                            nmPetugas =
                                                selectedCaretacer!.label!;
                                          });

                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5, bottom: 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Center(
                                            child: Text(
                                              listPetugas[index]
                                                  .label
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: Column(
                children: <Widget>[
                  Container(
                    height: 68,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)),
                    padding: EdgeInsets.only(left: 22, right: 22),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        nmPetugas == null
                            ? Text(
                                "Pilih Penerima Setoran",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            : Text(
                                nmPetugas.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                        SvgPicture.asset(
                          "assets/icon/bottom.svg",
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 190,
          ),
          Padding(
            padding: EdgeInsets.only(top: 25),
            child: Divider(
              thickness: 1,
              color: Color(0xff979797),
            ),
          ),
          Expanded(
            child: selectedCaretacer == null
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Silahkan pilih penerima setoran terlebih dahulu",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: ListView.builder(
                        itemCount: selectedCaretacer!.transactions!.length,
                        itemBuilder: (BuildContext context, index) {
                          var item = selectedCaretacer!.transactions![index];
                          _addby = selectedCaretacer!.value;

                          return Container(
                            padding:
                                EdgeInsets.only(left: 15, right: 15, top: 10),
                            width: double.infinity,
                            height: 96,
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 5,
                                  height: 75,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Color(0xffF54748)),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    height: 96,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(5),
                                            topLeft: Radius.circular(6),
                                            topRight: Radius.circular(16),
                                            bottomRight: Radius.circular(16))),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: 17,
                                        right: 20,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  padding:
                                                      EdgeInsets.only(top: 18),
                                                  child: Text(
                                                    item.citizenSubscriptions!
                                                            .first.houseBlock! +
                                                        ' - ' +
                                                        item.citizenSubscriptions!
                                                            .first.houseNumber!,
                                                    style: TextStyle(
                                                        fontFamily: "Nunito",
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Colors.black
                                                            .withOpacity(0.8),
                                                        fontSize: 18,
                                                        fontStyle:
                                                            FontStyle.normal),
                                                  )),
                                              Container(
                                                  child: Text(
                                                item.citizenSubscriptions!.first
                                                    .citizenName!,
                                                style: TextStyle(
                                                    fontFamily: "Nunito",
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0XFF121212),
                                                    fontSize: 12,
                                                    fontStyle:
                                                        FontStyle.normal),
                                              )),
                                            ],
                                          ),
                                          Text(
                                            NumberFormat.currency(
                                                    locale: 'id',
                                                    symbol: 'Rp. ',
                                                    decimalDigits: 0)
                                                .format(item.total),
                                            style: TextStyle(
                                                fontFamily: "Nunito",
                                                fontWeight: FontWeight.w800,
                                                color: Color(0XFF58C863),
                                                fontSize: 13,
                                                fontStyle: FontStyle.normal),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
          ),
          selectedCaretacer == null
              ? Container()
              : Container(
                  padding: EdgeInsets.only(left: 23, top: 16, right: 23),
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Color(0XFFFFFFFF)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Deposit",
                        style: TextStyle(
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w600,
                            color: Colors.black.withOpacity(0.8),
                            fontSize: 16,
                            fontStyle: FontStyle.normal),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          NumberFormat.currency(
                                  locale: 'id',
                                  symbol: 'Rp. ',
                                  decimalDigits: 0)
                              .format(selectedCaretacer!.hasCashDepositTotal),
                          style: TextStyle(
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w800,
                              color: Color(0XFF58C863),
                              fontSize: 24,
                              fontStyle: FontStyle.normal),
                        ),
                      ),
                      KmpFlatButton(
                        fullWidth: true,
                        buttonType: ButtonType.primary,
                        onPressed: () {
                          setState(() {
                            final progress = ProgressHUD.of(context);

                            progress!.showWithText(GlobalConfiguration()
                                    .getValue(GlobalVars.TEXT_LOADING_TITLE) ??
                                StringResources.PLEASE_WAIT);

                            FocusScope.of(context)
                                .requestFocus(new FocusNode());

                            itemDeposit = PostDeposit(
                                addBy: _addby, transactions: listTransaction);
                            BlocProvider.of<DepositBloc>(context)
                                .add(AddDepositEvent(deposit: itemDeposit));

                            progress.dismiss();
                          });
                        },
                        title: 'Diterima',
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }

  Future<void> _thankYouPopup() {
    return CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: "Data berhasil dikirim",
        confirmBtnText: 'Ok',
        onConfirmBtnTap: () async {
          int count = 0;
          Navigator.of(context).popUntil((_) => count++ >= 2);
        });
  }
}
