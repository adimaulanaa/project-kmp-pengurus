import 'package:another_flushbar/flushbar_helper.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:kmp_pengurus_app/config/global_vars.dart';
import 'package:kmp_pengurus_app/config/string_resources.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/domain/entities/post_caretaker.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/framework/managers/helper.dart';
import 'package:kmp_pengurus_app/theme/colors.dart';

class AddCaretakerScreen extends StatefulWidget {
  const AddCaretakerScreen({Key? key}) : super(key: key);

  @override
  _AddCaretakerScreenState createState() => _AddCaretakerScreenState();
}

class _AddCaretakerScreenState extends State<AddCaretakerScreen> {
  late PostCaretaker itemCaretaker;

  final _formKey = GlobalKey<FormBuilderState>();

  TextEditingController noKtpCtr = new TextEditingController();
  TextEditingController namaCtr = new TextEditingController();
  TextEditingController emailCtr = new TextEditingController();
  TextEditingController telpCtr = new TextEditingController();
  String gender = '';
  bool isTreasurer = false;
  bool isMale = false;
  bool isFemale = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CaretakerBloc>(context).add(AddLoadCaretaker());
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
    return BlocListener<CaretakerBloc, CaretakerState>(
      listener: (context, state) async {
        if (state is CaretakerLoading) {
          final progress = ProgressHUD.of(context);
          progress?.showWithText(
              GlobalConfiguration().getValue(GlobalVars.TEXT_LOADING_TITLE) ??
                  StringResources.PLEASE_WAIT);
          setState(() {});
        } else if (state is AddCaretakerLoaded) {
          final progress = ProgressHUD.of(context);
          progress!.dismiss();
        } else if (state is CaretakerSuccess) {
          _thankYouPopup();
        } else if (state is CaretakerFailure) {
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
                              "Tambah Pengurus",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w800,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 22,
                                  color: Colors.black),
                            ),
                            Text(
                              "Masukkan Data Pengurus",
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
                        //! Status Pengurus
                        FormBuilderSwitch(
                          onChanged: (val) {
                            setState(() {
                              isTreasurer = val!;
                            });
                          },
                          decoration: InputDecoration(
                              filled: true, fillColor: Colors.transparent),
                          name: 'statuspengurus',
                          initialValue: isTreasurer,
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Status Petugas",
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Colors.black),
                              ),
                              Text(
                                isTreasurer == true ? "Bendahara" : "Bukan Bendahara",
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

                        //!No Ktp
                        FormBuilderTextField(
                          controller: noKtpCtr,
                          name: 'noKtp',
                          decoration: InputDecoration(
                            prefixIcon: Container(
                              padding: EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                'assets/icon/id_card.svg',
                                color: Color(0xffD1D5DB),
                              ),
                            ),
                            labelText: 'No KTP',
                            hintStyle: TextStyle(
                                fontFamily: "Nunito",
                                fontSize: 10,
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                            labelStyle: TextPalette.hintTextStyle,
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                            FormBuilderValidators.min(context, 16),
                          ]),
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        //!Nama
                        FormBuilderTextField(
                          controller: namaCtr,
                          name: 'nama',
                          decoration: InputDecoration(
                            prefixIcon: Container(
                              padding: EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                'assets/icon/user.svg',
                                color: Color(0xffD1D5DB),
                              ),
                            ),
                            labelText: 'Nama',
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
                        //!  jenis kelamin
                        Row(children: [
                          Flexible(
                            //!Laki Laki
                            child: InkWell(
                                child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: isMale == false
                                      ? Color(0xffE5E5E5).withOpacity(0.5)
                                      : Color(0xff58C863).withOpacity(0.5)),
                              child: TextButton.icon(
                                  onPressed: () {
                                    isMale = !isMale;
                                    if (isFemale == true) {
                                      isFemale = false;
                                    }
                                    if (isMale) {
                                      gender = "L";
                                    } else {
                                      gender = "P";
                                    }
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.male,
                                    color: isMale == false
                                        ? Color(0xffD1D5DB)
                                        : Colors.white,
                                  ),
                                  label: Text(
                                    "Laki-Laki",
                                    style: TextStyle(
                                        fontFamily: "Nunito",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: isMale == false
                                            ? Color(0xffD1D5DB)
                                            : Colors.white),
                                  )),
                            )),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Flexible(
                            //!Perempuan
                            child: InkWell(
                                child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: isFemale == false
                                      ? Color(0xffE5E5E5).withOpacity(0.5)
                                      : Color(0xffE33A4E).withOpacity(0.5)),
                              child: TextButton.icon(
                                  onPressed: () {
                                    isFemale = !isFemale;
                                    if (isMale == true) {
                                      isMale = false;
                                    }
                                    if (isMale) {
                                      gender = "L";
                                    } else {
                                      gender = "P";
                                    }
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.female,
                                    color: isFemale == false
                                        ? Color(0xffD1D5DB)
                                        : Colors.white,
                                  ),
                                  label: Text(
                                    "Perempuan",
                                    style: TextStyle(
                                        fontFamily: "Nunito",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: isFemale == false
                                            ? Color(0xffD1D5DB)
                                            : Colors.white),
                                  )),
                            )),
                          )
                        ]),
                        SizedBox(
                          height: 18,
                        ),
                        //! Email
                        FormBuilderTextField(
                          controller: emailCtr,
                          name: 'email',
                          decoration: InputDecoration(
                            prefixIcon: Container(
                              padding: EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                'assets/icon/news.svg',
                                color: Color(0xffD1D5DB),
                              ),
                            ),
                            labelText: 'Email',
                            labelStyle: TextPalette.hintTextStyle,
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                          ]),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        //!  Telepon
                        FormBuilderTextField(
                          controller: telpCtr,
                          name: 'telepon',
                          decoration: InputDecoration(
                            labelText: 'Telepon',
                            labelStyle: TextPalette.hintTextStyle,
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                          ]),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(
                          height: 18,
                        ),
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
              if (isMale) {
                gender = "L";
              } else if (isFemale) {
                gender = "P";
              } else {
                gender = "";
              }
              itemCaretaker = PostCaretaker(
                  idCard: noKtpCtr.text,
                  name: namaCtr.text,
                  gender: gender,
                  isTreasurer: isTreasurer,
                  email: emailCtr.text,
                  phone: telpCtr.text,
                  );
            });

            BlocProvider.of<CaretakerBloc>(context)
                .add(AddCaretakerEvent(caretaker: itemCaretaker));
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
