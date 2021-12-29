import 'dart:io';
import 'dart:ui';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:kmp_pengurus_app/config/global_vars.dart';
import 'package:kmp_pengurus_app/config/string_resources.dart';
import 'package:kmp_pengurus_app/env.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/dashboard_model.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/region_model.dart';
import 'package:kmp_pengurus_app/features/master/officers/domain/entities/post_officers.dart';
import 'package:kmp_pengurus_app/features/master/officers/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/theme/colors.dart';
import 'package:kmp_pengurus_app/framework/managers/helper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:uuid/uuid.dart';

class AddPetugasScreen extends StatefulWidget {
  AddPetugasScreen({Key? key}) : super(key: key);

  @override
  _AddPetugasScreenState createState() => _AddPetugasScreenState();
}

class _AddPetugasScreenState extends State<AddPetugasScreen> {
  PageController pageController = PageController(initialPage: 0);
  double pagePosition = 0;
  final _formKey = GlobalKey<FormBuilderState>();
  late PostOfficers itemOfficers;

  String? noKtp;
  String? nmPetugas;
  String? gender;
  String? subDistrict;
  String? street;
  List<String> penugasan = [];
  List<Base> penugasanPetugas = [];
  String? email;
  String? telp;
  String? jabatan;

  TextEditingController noKtpCtr = TextEditingController();
  TextEditingController nmPetugasCtr = TextEditingController();
  TextEditingController deskripsiCtr = TextEditingController();
  TextEditingController noTelpCtr = TextEditingController();
  TextEditingController rtPetugasCtr = TextEditingController();
  TextEditingController rwPetugasCtr = TextEditingController();

  File? imgKtp;
  File? imgRes;
  String pathRes = '';
  String pathKtp = '';

  List<Village> listVillage = [];
  List<VillageRwRt> listRwRt = [];
  List<RegionModel> masterRegion = [];
  List<RegionModel> listProvinsi = [];
  List<RegionModel> listKoKab = [];
  List<RegionModel> listKec = [];
  List<RegionModel> listKel = [];
  List<Position> listJob = [];

  String? subDistrictId;

  final ImagePicker _picker = ImagePicker();

  Future getImageKtp(ImageSource media) async {
    var resultKtp = await _picker.pickImage(source: media);

    if (resultKtp != null) {
      setState(() {
        imgKtp = File(resultKtp.path);
      });
      final dirKtp = await path_provider.getTemporaryDirectory();
      final filenameKtp = Uuid().v4();
      final targetPathKtp = dirKtp.absolute.path + "/doc$filenameKtp.jpg";
      final int imageQualityKtp = Env().configImageCompressQuality!;

      try {
        final compressedFileKtp = await FlutterImageCompress.compressAndGetFile(
          resultKtp.path,
          targetPathKtp,
          quality: imageQualityKtp,
        );

        setState(() {
          if (compressedFileKtp != null && compressedFileKtp.lengthSync() > 0) {
            pathKtp = targetPathKtp;
          } else {
            pathKtp = resultKtp.path;
          }
        });
      } catch (e) {
        if (Env().isInDebugMode) {
          print('[pertama ] error $e');
        }
      }
    }
  }

  Future getImageRes(ImageSource media) async {
    var resultRes = await _picker.pickImage(source: media);

    if (resultRes != null) {
      setState(() {
        imgRes = File(resultRes.path);
      });
      final dirRes = await path_provider.getTemporaryDirectory();
      final filenameRes = Uuid().v4();
      final targetPathRes = dirRes.absolute.path + "/doc$filenameRes.jpg";

      final int imageQualityRes = Env().configImageCompressQuality!;

      try {
        final compressedFileRes = await FlutterImageCompress.compressAndGetFile(
          resultRes.path,
          targetPathRes,
          quality: imageQualityRes,
        );

        setState(() {
          if (compressedFileRes != null && compressedFileRes.lengthSync() > 0) {
            pathRes = targetPathRes;
          } else {
            pathRes = resultRes.path;
          }
        });
      } catch (e) {
        if (Env().isInDebugMode) {
          print('[pertama ] error $e');
        }
      }
    }
  }

  bool isMale = false;
  bool isFemale = false;
  List<Base> petugas = [];

  @override
  void initState() {
    petugas = penugasanPetugas.map((e) => Base()).toList();
    super.initState();
    BlocProvider.of<OfficersBloc>(context).add(AddLoadOfficers());
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  Widget _build(BuildContext context) {
    return BlocListener<OfficersBloc, OfficersState>(
      listener: (context, state) async {
        if (state is OfficersLoading) {
          final progress = ProgressHUD.of(context);
          progress?.showWithText(
              GlobalConfiguration().getValue(GlobalVars.TEXT_LOADING_TITLE) ??
                  StringResources.PLEASE_WAIT);
          setState(() {});
        } else if (state is AddOfficersLoaded) {
          final progress = ProgressHUD.of(context);
          if (state.listVillage!.isNotEmpty && state.listVillage!.length > 0) {
            listRwRt = state.listRwRt!;
            listVillage = state.listVillage!;
            masterRegion = state.listRegion!;
            listJob = state.listJob!;

            listProvinsi = masterRegion
                .where((element) =>
                    element.level == 2 && element.type == 'Provinsi')
                .toList();

            setState(() {});
          }
          progress!.dismiss();
        } else if (state is OfficersSuccess) {
          _thankYouPopup();
        } else if (state is OfficersFailure) {
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
              DotsIndicator(
                position: pagePosition,
                dotsCount: 5,
                decorator: DotsDecorator(
                  size: Size(10.0, 10.0),
                  color: Colors.black.withOpacity(0.4),
                  activeColor: Colors.black,
                  activeSize: Size(21.0, 10.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: FormBuilder(
        key: _formKey,
        child: Theme(
          data: ThemeData(
            inputDecorationTheme: InputDecorationTheme(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.transparent),
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
          
          child: PageView(
            scrollDirection: Axis.horizontal,
            onPageChanged: (page) {
              pagePosition = page.toDouble();
              setState(() {});
            },
            controller: pageController,
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: Column(
                    children: [
                      Container(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tambah Petugas ',
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800),
                              ),
                              Text(
                                'Masukkan Identitas Petugas',
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xff979797)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //! Status Petugas
                      Container(
                        padding: EdgeInsets.only(top: 25),
                        child: FormBuilderSwitch(
                          decoration: InputDecoration(
                              filled: true, fillColor: Colors.transparent),
                          onChanged: (val) {},
                          name: 'statusPetugas',
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
                                "Tidak Aktif",
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10,
                                    color: Color(0xff979797)),
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        color: Color(0xff979797).withOpacity(0.25),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //!  Petugas
                      FormBuilderDropdown(
                        name: 'petugasJabatan',
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            padding: EdgeInsets.all(16),
                            child: SvgPicture.asset(
                              'assets/icon/tag-user.svg',
                            ),
                          ),
                          labelStyle: TextPalette.hintTextStyle,
                        ),
                        allowClear: true,
                        hint: Text(
                          'Pilih Jabatan Petugas',
                          style: TextStyle(
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w700,
                              color: Color(0xffD1D5DB),
                              fontSize: 12,
                              fontStyle: FontStyle.normal),
                        ),
                        validator: FormBuilderValidators.compose(
                            [FormBuilderValidators.required(context)]),
                        items: listJob
                            .map((jabatan) => DropdownMenuItem(
                                  value: jabatan.id,
                                  child: Text('${jabatan.name}'),
                                ))
                            .toList(),
                        onChanged: (val) {
                          jabatan = val.toString();
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
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
                                "Penugasan",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 22,
                                    color: Colors.black),
                              ),
                              Text(
                                "Pilih Tempat Penugasan",
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
                      padding: EdgeInsets.only(left: 25, right: 25),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: GridView.builder(
                              physics: new NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      childAspectRatio: 9 / 2,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 10),
                              itemCount: listRwRt.length,
                              itemBuilder: (BuildContext context, index) {
                                var tempatTugas = listRwRt[index];
                                return Container(
                                  padding: EdgeInsets.only(bottom: 20),
                                  height: 48,
                                  decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.white),
                                  child: CheckboxListTile(
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    activeColor: Color(0xff58C863),
                                    contentPadding:
                                        EdgeInsets.only(top: 7, left: 5),
                                    value: tempatTugas.checkRtRw,
                                    onChanged: (val) {
                                      setState(() {
                                        tempatTugas.checkRtRw = val!;
                                        if (tempatTugas.checkRtRw!) {
                                          if (penugasan
                                              .contains(tempatTugas.id)) {
                                          } else {
                                            penugasan.add(tempatTugas.id!);
                                          }
                                        } else {
                                          if (penugasan
                                              .contains(tempatTugas.id)) {
                                            penugasan.remove(tempatTugas.id);
                                          }
                                        }
                                      });
                                    },
                                    title: Text(
                                      tempatTugas.displayText!,
                                      style: TextStyle(
                                          fontFamily: "Nunito",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black.withOpacity(0.8)),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: Column(
                    children: [
                      Container(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Data Petugas ',
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800),
                              ),
                              Text(
                                'Masukkan Identitas Petugas',
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xff979797)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //! KTP
                      Container(
                        padding: EdgeInsets.only(top: 25),
                        child: FormBuilderTextField(
                          name: 'noktp',
                          controller: noKtpCtr,
                          decoration: InputDecoration(
                            prefixIcon: Container(
                              padding: EdgeInsets.all(16),
                              child: SvgPicture.asset(
                                'assets/icon/id_card.svg',
                                color: Color(0xffD1D5DB),
                                height: 30,
                              ),
                            ),
                            labelText: 'Nomor KTP',
                            labelStyle: TextPalette.hintTextStyle,
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                            FormBuilderValidators.min(context, 16)
                          ]),
                          keyboardType: TextInputType.number,
                          onChanged: (val) {},
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //!  nama petugas
                      FormBuilderTextField(
                        name: 'nmpetugas',
                        controller: nmPetugasCtr,
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            padding: EdgeInsets.all(16),
                            child: SvgPicture.asset(
                              'assets/icon/user.svg',
                              color: Color(0xffD1D5DB),
                            ),
                          ),
                          labelText: 'Nama Petugas',
                          labelStyle: TextPalette.hintTextStyle,
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        keyboardType: TextInputType.text,
                        onChanged: (val) {},
                      ),
                      SizedBox(
                        height: 10,
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
                        height: 10,
                      ),
                      //! Nomer wa
                      FormBuilderTextField(
                        name: 'nowa',
                        controller: noTelpCtr,
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            padding: EdgeInsets.all(16),
                            child: SvgPicture.asset(
                              'assets/icon/phone.svg',
                              color: Color(0xffD1D5DB),
                            ),
                          ),
                          labelText: 'No Wa aktif',
                          labelStyle: TextPalette.hintTextStyle,
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: Column(
                    children: [
                      Container(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Alamat Petugas ',
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800),
                              ),
                              Text(
                                'Masukkan Alamat Petugas',
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xff979797)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //! province
                      Container(
                        padding: EdgeInsets.only(top: 25),
                        child: FormBuilderDropdown(
                          name: 'province',
                          decoration: InputDecoration(
                            prefixIcon: Container(
                              padding: EdgeInsets.all(16),
                              child: SvgPicture.asset(
                                'assets/icon/map.svg',
                                color: Color(0xffADB3BC),
                                height: 30,
                              ),
                            ),
                            labelStyle: TextPalette.hintTextStyle,
                          ),
                          allowClear: true,
                          hint: Text(
                            'Pilih Provinsi',
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w700,
                                color: Color(0xffD1D5DB),
                                fontSize: 12,
                                fontStyle: FontStyle.normal),
                          ),
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required(context)]),
                          items: listProvinsi
                              .map((e) => DropdownMenuItem(
                                  value: '${e.id}-${e.name}',
                                  child: Text(
                                    "${e.name}",
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                    ),
                                  )))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              var isi = value.toString().split('-');
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              var provinceName = isi[1];
                              var provinceId = isi[0];
                              listKoKab = masterRegion
                                  .where((element) =>
                                      element.level == 3 &&
                                      element.parent == provinceId)
                                  .toList();
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //!  Kabupaten
                      FormBuilderDropdown(
                        name: 'district',
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            padding: EdgeInsets.all(16),
                            child: SvgPicture.asset(
                              'assets/icon/building.svg',
                              color: Color(0xffADB3BC),
                            ),
                          ),
                          labelStyle: TextPalette.hintTextStyle,
                        ),
                        allowClear: true,
                        hint: Text(
                          'Pilih Kota / Kabupaten',
                          style: TextStyle(
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w700,
                              color: Color(0xffD1D5DB),
                              fontSize: 12,
                              fontStyle: FontStyle.normal),
                        ),
                        validator: FormBuilderValidators.compose(
                            [FormBuilderValidators.required(context)]),
                        items: listKoKab
                            .map((e) => DropdownMenuItem(
                                value: '${e.id}-${e.name}',
                                child: Text(
                                  "${e.name}",
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                  ),
                                )))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            var isi = value.toString().split('-');
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            var cityName = isi[1];
                            var cityId = isi[0];
                            listKec = masterRegion
                                .where((element) =>
                                    element.level == 4 &&
                                    element.parent == cityId)
                                .toList();
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //! Kecamatan
                      FormBuilderDropdown(
                        name: 'subdistrict',
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            padding: EdgeInsets.all(16),
                            child: SvgPicture.asset(
                              'assets/icon/bank.svg',
                              color: Color(0xffADB3BC),
                              height: 30,
                            ),
                          ),
                          labelStyle: TextPalette.hintTextStyle,
                        ),
                        allowClear: true,
                        hint: Text(
                          'Pilih Kecamatan',
                          style: TextStyle(
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w700,
                              color: Color(0xffD1D5DB),
                              fontSize: 12,
                              fontStyle: FontStyle.normal),
                        ),
                        validator: FormBuilderValidators.compose(
                            [FormBuilderValidators.required(context)]),
                        items: listKec
                            .map((e) => DropdownMenuItem(
                                value: '${e.id}-${e.name}',
                                child: Text(
                                  "${e.name}",
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                  ),
                                )))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            var isi = value.toString().split('-');
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            var districtName = isi[1];
                            var districtId = isi[0];
                            listKel = masterRegion
                                .where((element) =>
                                    element.level == 5 &&
                                    element.parent == districtId)
                                .toList();
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //!  Kelurahan
                      FormBuilderDropdown(
                        name: 'ward',
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            padding: EdgeInsets.all(16),
                            child: SvgPicture.asset(
                              'assets/icon/house.svg',
                              color: Color(0xffADB3BC),
                            ),
                          ),
                          labelStyle: TextPalette.hintTextStyle,
                        ),
                        allowClear: true,
                        hint: Text(
                          'Pilih Kelurahan',
                          style: TextStyle(
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w700,
                              color: Color(0xffD1D5DB),
                              fontSize: 12,
                              fontStyle: FontStyle.normal),
                        ),
                        validator: FormBuilderValidators.compose(
                            [FormBuilderValidators.required(context)]),
                        items: listKel
                            .map((e) => DropdownMenuItem(
                                value: '${e.id}-${e.name}',
                                child: Text(
                                  "${e.name}",
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                  ),
                                )))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            var isi = value.toString().split('-');
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            var subdistrictName = isi[1];
                            subDistrictId = isi[0];
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //!  Rt dan Rw
                      Row(children: [
                        Flexible(
                          //!RT
                          child: FormBuilderTextField(
                            name: 'rt',
                            controller: rtPetugasCtr,
                            decoration: InputDecoration(
                              prefixIcon: Container(
                                padding: EdgeInsets.all(16),
                                child: SvgPicture.asset(
                                  'assets/icon/location.svg',
                                  color: Color(0xffD1D5DB),
                                  height: 30,
                                ),
                              ),
                              labelText: 'RT',
                              labelStyle: TextPalette.hintTextStyle,
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context),
                            ]),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Flexible(
                          //!RW
                          child: FormBuilderTextField(
                            name: 'rw',
                            controller: rwPetugasCtr,
                            decoration: InputDecoration(
                              prefixIcon: Container(
                                padding: EdgeInsets.all(16),
                                child: SvgPicture.asset(
                                  'assets/icon/location.svg',
                                  color: Color(0xffD1D5DB),
                                  height: 30,
                                ),
                              ),
                              labelText: 'RW',
                              labelStyle: TextPalette.hintTextStyle,
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context),
                            ]),
                            keyboardType: TextInputType.number,
                          ),
                        )
                      ]),
                      SizedBox(
                        height: 10,
                      ),
                      //!  Deskripsi
                      FormBuilderTextField(
                        name: 'deskripsi',
                        controller: deskripsiCtr,
                        decoration: InputDecoration(
                          labelText: 'Deskripsi',
                          labelStyle: TextPalette.hintTextStyle,
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        maxLines: 4,
                        keyboardType: TextInputType.text,
                        onChanged: (val) {},
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
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
                                "Dokumen Petugas (KTP)",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 22,
                                    color: Colors.black),
                              ),
                              Text(
                                "Upload Dokumen Petugas",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12,
                                    color: Color(0xff979797)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: Row(
                                      children: [
                                        imgKtp == null
                                            ? DottedBorder(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                radius:
                                                    const Radius.circular(8),
                                                borderType: BorderType.RRect,
                                                strokeWidth: 0.5,
                                                color: Color(0xffC4C4C4),
                                                child: SvgPicture.asset(
                                                  "assets/icon/id_card.svg",
                                                  height: 30,
                                                ))
                                            : Container(
                                                width: 40,
                                                height: 40,
                                                child: Image.file(
                                                  imgKtp!,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Container(
                                          width: imgKtp == null ? 190 : 150,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "KTP",
                                                style: TextStyle(
                                                    fontFamily: "Nunito",
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 12,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                "Tambah Foto KTP",
                                                style: TextStyle(
                                                    fontFamily: "Nunito",
                                                    fontWeight: FontWeight.w400,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 10,
                                                    color: Color(0xffCCCED3)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        imgKtp == null
                                            ? IconButton(
                                                onPressed: () {
                                                  alertFotoKtp();
                                                },
                                                icon: Icon(Icons.add))
                                            : Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(
                                                        Icons.done,
                                                        color: Colors.green,
                                                      )),
                                                  IconButton(
                                                      onPressed: () {
                                                        alertFotoKtp();
                                                      },
                                                      icon: Icon(Icons.add)),
                                                ],
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: Row(
                                      children: [
                                        imgRes == null
                                            ? DottedBorder(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                radius:
                                                    const Radius.circular(8),
                                                borderType: BorderType.RRect,
                                                strokeWidth: 0.5,
                                                color: Color(0xffC4C4C4),
                                                child: SvgPicture.asset(
                                                  "assets/icon/person.svg",
                                                  height: 30,
                                                ))
                                            : Container(
                                                width: 40,
                                                height: 40,
                                                child: Image.file(
                                                  imgRes!,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Container(
                                          width: imgRes == null ? 190 : 150,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Foto",
                                                style: TextStyle(
                                                    fontFamily: "Nunito",
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 12,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                "Upload Foto Diri",
                                                style: TextStyle(
                                                    fontFamily: "Nunito",
                                                    fontWeight: FontWeight.w400,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 10,
                                                    color: Color(0xffCCCED3)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        imgRes == null
                                            ? IconButton(
                                                onPressed: () {
                                                  alertFotoRes();
                                                },
                                                icon: Icon(Icons.add))
                                            : Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(
                                                        Icons.done,
                                                        color: Colors.green,
                                                      )),
                                                  IconButton(
                                                      onPressed: () {
                                                        alertFotoRes();
                                                      },
                                                      icon: Icon(Icons.add)),
                                                ],
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ],
                )),
              )
            ],
          ),
        ),
      
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: pagePosition != 4.0
              ? () => pageController.nextPage(
                  duration: Duration(milliseconds: 400), curve: Curves.easeIn)
              : () {
                  if (_formKey.currentState!.validate()) {
                    final progress = ProgressHUD.of(context);

                    progress!.showWithText(GlobalConfiguration()
                            .getValue(GlobalVars.TEXT_LOADING_TITLE) ??
                        StringResources.PLEASE_WAIT);

                    FocusScope.of(context).requestFocus(new FocusNode());

                    setState(() {
                      itemOfficers = PostOfficers(
                        idCard: noKtpCtr.text,
                        street: deskripsiCtr.text,
                        gender: gender,
                        subDistrict: subDistrictId,
                        name: nmPetugasCtr.text,
                        rt: rtPetugasCtr.text,
                        rw: rwPetugasCtr.text,
                        assignments: penugasan,
                        email: '',
                        phone: noTelpCtr.text,
                        phone2: '',
                        position: jabatan,
                        pathImage: pathRes,
                        pathKtp: pathKtp
                      );
                    });

                    BlocProvider.of<OfficersBloc>(context)
                        .add(AddOfficersEvent(officers: itemOfficers));
                    progress.dismiss();
                  } else {
                    final progress = ProgressHUD.of(context);
                    progress!.showWithText(GlobalConfiguration()
                            .getValue(GlobalVars.TEXT_LOADING_TITLE) ??
                        StringResources.PLEASE_WAIT);
                    progress.dismiss();
                    FlushbarHelper.createError(
                        message: "Harap Lengkapi Form diatas",
                        title: "Warning",
                        duration: Duration(seconds: 3))
                      ..show(context);
                  }
                },
          child: pagePosition != 4.0
              ? SvgPicture.asset(
                  "assets/icon/next.svg",
                  color: Color(0xffFFFFFF),
                )
              : Icon(
                  Icons.check,
                  size: 36,
                ),
          backgroundColor: Color(0xffF54748)),
    );
  }

  void alertFotoKtp() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text(
              'Pilih Sumber Media',
              style: TextStyle(
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
            ),
            content: Container(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      getImageKtp(ImageSource.gallery);
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.image,
                          color: Color(0xffE33A4E),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Dari Gallery',
                          style: TextStyle(
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              fontStyle: FontStyle.normal,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      getImageKtp(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.camera, color: Color(0xffE33A4E)),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Dari Camera',
                          style: TextStyle(
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              fontStyle: FontStyle.normal,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void alertFotoRes() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text(
              'Pilih Sumber Media',
              style: TextStyle(
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
            ),
            content: Container(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      getImageRes(ImageSource.gallery);
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.image,
                          color: Color(0xffE33A4E),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Dari Gallery',
                          style: TextStyle(
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              fontStyle: FontStyle.normal,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      getImageRes(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.camera, color: Color(0xffE33A4E)),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Dari Camera',
                          style: TextStyle(
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              fontStyle: FontStyle.normal,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
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
