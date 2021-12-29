import 'package:another_flushbar/flushbar_helper.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:kmp_pengurus_app/config/global_vars.dart';
import 'package:kmp_pengurus_app/config/string_resources.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/dashboard_model.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/domain/entities/post_subscriptions.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/presentation/bloc/subscriptions_bloc.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/presentation/bloc/subscriptions_event.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/presentation/bloc/subscriptions_state.dart';
import 'package:kmp_pengurus_app/framework/managers/helper.dart';
import 'package:kmp_pengurus_app/theme/colors.dart';

class AddIuranScreen extends StatefulWidget {
  const AddIuranScreen({Key? key}) : super(key: key);

  @override
  _AddIuranScreenState createState() => _AddIuranScreenState();
}

class _AddIuranScreenState extends State<AddIuranScreen> {
  List<Base> listKategori = [];

  late PostSubscriptions itemSubscription;

  final _formKey = GlobalKey<FormBuilderState>();

  TextEditingController judulController = new TextEditingController();
  TextEditingController nominalController = new TextEditingController();
  TextEditingController deskripsiController = new TextEditingController();
  TextEditingController tanggalController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SubscriptionsBloc>(context).add(AddLoadSubscriptions());
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? idIuran;
  String? nmIuran;
  bool isActive = true;
  DateTime? tanggalAktif;

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  Widget _build(BuildContext context) {
    return BlocListener<SubscriptionsBloc, SubscriptionsState>(
      listener: (context, state) async {
        if (state is SubscriptionsLoading) {
          final progress = ProgressHUD.of(context);
          progress?.showWithText(
              GlobalConfiguration().getValue(GlobalVars.TEXT_LOADING_TITLE) ??
                  StringResources.PLEASE_WAIT);
          setState(() {});
        } else if (state is AddSubscriptionsLoaded) {
          final progress = ProgressHUD.of(context);
          if (state.data!.isNotEmpty && state.data!.length > 0) {
            listKategori = state.data!;
            setState(() {});
          }
          progress!.dismiss();
        } else if (state is SubscriptionsSuccess) {
          _thankYouPopup();
        } else if (state is SubscriptionsFailure) {
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
                  Navigator.pop(context);
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
                          offset: Offset(0, 1), // changes position of shadow
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
      body: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Theme(
            data: ThemeData(
              inputDecorationTheme: InputDecorationTheme(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Color(0xffCCCED3)),
                    borderRadius: BorderRadius.circular(16)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 3,
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 3,
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 3,
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                hintStyle: TextStyle(color: Color(0xffD1D5DB)),
                labelStyle: TextStyle(color: Color(0xffD1D5DB)),
                errorStyle: TextStyle(color: ColorPalette.primary),
                filled: true,
                fillColor: Color(0xffE5E5E5).withOpacity(0.5),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            child: Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 25, top: 15),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tambah Iuran",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w800,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 22,
                                  color: Colors.black),
                            ),
                            Text(
                              "Masukkan Data Iuran",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,
                                  color: Color(0xff979797)),
                            ),
                          ]),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 25, right: 25, top: 35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //! Status Iuran
                        FormBuilderSwitch(
                          onChanged: (val) {
                            isActive = val!;
                          },
                          decoration: InputDecoration(
                              filled: true, fillColor: Colors.transparent),
                          name: 'statusiuran',
                          initialValue: isActive,
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Status Iuran",
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Colors.black),
                              ),
                              Text(
                                isActive == true ? "Aktif" : "Tidak Aktif",
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10,
                                    color: Color(0xff979797)),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: Color(0xff979797).withOpacity(0.25),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    padding:
                                        EdgeInsets.only(left: 15, right: 15),
                                    height: 300,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 24,
                                                right: 24,
                                                top: 20,
                                                bottom: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                    child: Text("Kategori",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                                .withOpacity(
                                                                    0.05),
                                                            spreadRadius: 1.5,
                                                            blurRadius: 15,
                                                            offset: Offset(0,
                                                                1),
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                        color: Colors.white),
                                                    child: Icon(Icons.close),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          GridView.builder(
                                              physics:
                                                  new NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2,
                                                      childAspectRatio: 5 / 2,
                                                      crossAxisSpacing: 2,
                                                      mainAxisSpacing: 2),
                                              itemCount: listKategori.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      index) {
                                                return InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      nmIuran =
                                                          listKategori[index]
                                                              .name;
                                                      idIuran =
                                                          listKategori[index]
                                                              .id;
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5,
                                                            right: 5,
                                                            bottom: 10),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12)),
                                                      child: Center(
                                                        child: Text(
                                                          listKategori[index]
                                                              .name!,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14),
                                                          textAlign:
                                                              TextAlign.center,
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
                          child: Container(
                            height: 68,
                            decoration: BoxDecoration(
                                color: Color(0xffE5E5E5).withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16)),
                            padding: EdgeInsets.only(left: 22, right: 22),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset("assets/icon/home.svg"),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      nmIuran == null ? "Kategori" : nmIuran!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: nmIuran == null
                                              ? Color(0xffD1D5DB)
                                              : Colors.black.withOpacity(0.8),
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                SvgPicture.asset(
                                  "assets/icon/bottom.svg",
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        //!Judul
                        FormBuilderTextField(
                          controller: judulController,
                          name: 'judul',
                          decoration: InputDecoration(
                            prefixIcon: Container(
                              padding: EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                'assets/icon/note.svg',
                                color: Color(0xffD1D5DB),
                              ),
                            ),
                            labelText: 'Judul',
                            hintStyle: TextStyle(
                                fontFamily: "Nunito",
                                fontSize: 10,
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                            labelStyle: TextPalette.hintTextStyle,
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                          ]),
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        //!Tanggal
                        FormBuilderDateTimePicker(
                          onChanged: (value) {
                            tanggalAktif = value;
                          },
                          name: 'date',
                          inputType: InputType.date,
                          decoration: new InputDecoration(
                            suffixIcon: Container(
                                padding: EdgeInsets.all(10),
                                child:
                                    SvgPicture.asset("assets/icon/date.svg")),
                            fillColor: Color(0xffE5E5E5).withOpacity(0.5),
                            filled: true,
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        //! Nominal
                        FormBuilderTextField(
                          controller: nominalController,
                          name: 'nominal',
                          decoration: InputDecoration(
                            prefixIcon: Container(
                              padding: EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                'assets/icon/dollar.svg',
                                color: Color(0xffD1D5DB),
                              ),
                            ),
                            labelText: 'Nominal',
                            labelStyle: TextPalette.hintTextStyle,
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                          ]),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //!  Deskripsi
                        FormBuilderTextField(
                          controller: deskripsiController,
                          name: 'deskripsiIuran',
                          decoration: InputDecoration(
                            labelText: 'Deskripsi',
                            labelStyle: TextPalette.hintTextStyle,
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                          ]),
                          maxLines: 4,
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final progress = ProgressHUD.of(context);

            progress!.showWithText(
                GlobalConfiguration().getValue(GlobalVars.TEXT_LOADING_TITLE) ??
                    StringResources.PLEASE_WAIT);

            FocusScope.of(context).requestFocus(new FocusNode());

            setState(() {
              itemSubscription = PostSubscriptions(
                id: '',
                subscriptionCategory: idIuran,
                name: judulController.text,
                description: deskripsiController.text,
                effectiveDateString: tanggalAktif.toString(),
                amount: int.parse(nominalController.text),
              );
            });

            BlocProvider.of<SubscriptionsBloc>(context)
                .add(AddSubscriptionsEvent(subscriptions: itemSubscription));
            progress.dismiss();
          } else {
            final progress = ProgressHUD.of(context);
            progress!.showWithText(
                GlobalConfiguration().getValue(GlobalVars.TEXT_LOADING_TITLE) ??
                    StringResources.PLEASE_WAIT);
            progress.dismiss();
            FlushbarHelper.createError(
                message: "Harap Lengkapi Form diatas",
                title: "Warning",
                duration: Duration(seconds: 3))
              ..show(context);
          }
        },
        backgroundColor: ColorPalette.primary,
        child: Icon(
          Icons.check,
          size: 36,
        ),
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
