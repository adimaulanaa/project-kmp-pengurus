import 'package:another_flushbar/flushbar_helper.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:intl/intl.dart';
import 'package:kmp_pengurus_app/config/global_vars.dart';
import 'package:kmp_pengurus_app/config/string_resources.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/dashboard_model.dart';
import 'package:kmp_pengurus_app/features/master/houses/domain/entities/post_houses.dart';
import 'package:kmp_pengurus_app/features/master/houses/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/framework/managers/helper.dart';
import 'package:kmp_pengurus_app/theme/colors.dart';

class AddHouse extends StatefulWidget {
  const AddHouse({Key? key}) : super(key: key);

  @override
  _AddHouseState createState() => _AddHouseState();
}

class _AddHouseState extends State<AddHouse> {
  PageController pageController = PageController(initialPage: 0);
  double pagePosition = 0;
  var rtMenu = ["001", "002", "003"];
  var rwMenu = ["01", "02", "03"];
  bool pemilik = false;
  bool kontrak = false;
  bool isMale = false;
  bool isFemale = false;

  final _formKey = GlobalKey<FormBuilderState>();

  late PostHouses itemHouses;

  bool statusRumah = false;
  bool gratisIuran = false;
  String? gender;
  String? nmKampung;
  String? rtrw;
  String? nmJalan;
  String? nmBlok;
  String? noRumah;
  bool statusPenghuni = false;
  String? noKtp;
  String? nmPenghuni;
  String? noTelp;
  List<String> jenisIuran = [];
  bool iuran = false;

  TextEditingController nmJalanCtr = TextEditingController();
  TextEditingController nmBlokCtr = TextEditingController();
  TextEditingController noRumahCtr = TextEditingController();
  TextEditingController noKtpCtr = TextEditingController();
  TextEditingController nmPenghuniCtr = TextEditingController();
  TextEditingController noTelpCtr = TextEditingController();

  List<Base> listIuran = [];
  List<Village> listVillage = [];
  List<VillageRwRt> listRwRt = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HousesBloc>(context).add(AddLoadHouses());
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  Widget _build(BuildContext context) {
    return BlocListener<HousesBloc, HousesState>(
      listener: (context, state) async {
        if (state is HousesLoading) {
          final progress = ProgressHUD.of(context);
          progress?.showWithText(
              GlobalConfiguration().getValue(GlobalVars.TEXT_LOADING_TITLE) ??
                  StringResources.PLEASE_WAIT);
          setState(() {});
        } else if (state is AddHousesLoaded) {
          final progress = ProgressHUD.of(context);
          if (state.data!.isNotEmpty && state.data!.length > 0) {
            listIuran = state.data!;
            listRwRt = state.listRwRt!;
            listVillage = state.listVillage!;
            setState(() {});
          }
          progress!.dismiss();
        } else if (state is HousesSuccess) {
          _thankYouPopup();
        } else if (state is HousesFailure) {
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
                dotsCount: 3,
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
          child: PageView(
            scrollDirection: Axis.horizontal,
            onPageChanged: (page) {
              pagePosition = page.toDouble();

              setState(() {});
            },
            controller: pageController,
            children: [
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
                                "Data Rumah",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 22,
                                    color: Colors.black),
                              ),
                              Text(
                                "Masukkan Alamat dan Identitas",
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
                    //! Status Rumah
                    FormBuilderSwitch(
                      name: 'statusRumah',
                      onChanged: (res) {
                        setState(() {
                          statusRumah = res!;
                        });
                      },
                      decoration: InputDecoration(
                          filled: true, fillColor: Colors.transparent),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Status Rumah",
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          Text(
                            statusRumah ? "Berpenghuni" : "Kosong",
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                                color: Color(0xff979797)),
                          )
                        ],
                      ),
                    ),
                    //! Gratis Iuran
                    FormBuilderSwitch(
                      name: 'gratisIuran',
                      onChanged: (res) {
                        setState(() {
                          gratisIuran = res!;
                        });
                      },
                      decoration: InputDecoration(
                          filled: true, fillColor: Colors.transparent),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Gratis Iuran",
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          Text(
                            gratisIuran ? "Ya" : "Tidak",
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                                color: Color(0xff979797)),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25, top: 0),
                      child: Column(
                        children: [
                          Divider(
                            thickness: 1,
                            color: Color(0xff979797).withOpacity(0.25),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          //!Cluster
                          FormBuilderDropdown(
                            name: 'kampung',
                            onChanged: (val) {
                              nmKampung = val.toString();
                            },
                            decoration: InputDecoration(),
                            icon: Container(
                              child: SvgPicture.asset(
                                'assets/icon/category.svg',
                                color: Colors.black,
                              ),
                            ),
                            allowClear: true,
                            hint: Text('Kampung'),
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required(context)]),
                            items: listVillage
                                .map((e) => DropdownMenuItem(
                                      value: e.id,
                                      child: Text('${e.name}'),
                                    ))
                                .toList(),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          FormBuilderDropdown(
                            name: 'rt',
                            onChanged: (value) {
                              rtrw = value.toString();
                            },
                            decoration: InputDecoration(),
                            icon: Container(
                              child: SvgPicture.asset(
                                'assets/icon/bottom.svg',
                                color: Colors.black,
                              ),
                            ),
                            allowClear: true,
                            hint: Text('RT / RW'),
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required(context)]),
                            items: listRwRt
                                .map((res) => DropdownMenuItem(
                                      value: res.id,
                                      child: Text('${res.displayText}'),
                                    ))
                                .toList(),
                          ),
                          //! Jalan
                          Padding(
                            padding: EdgeInsets.only(top: 18),
                            child: FormBuilderTextField(
                              name: 'jalan',
                              controller: nmJalanCtr,
                              decoration: InputDecoration(
                                prefixIcon: Container(
                                  padding: EdgeInsets.all(10),
                                  child: SvgPicture.asset(
                                    'assets/icon/arrow.svg',
                                    color: Color(0xffD1D5DB),
                                  ),
                                ),
                                labelText: 'Nama Jalan / Gang',
                                labelStyle: TextPalette.hintTextStyle,
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                              ]),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          //! Blok
                          FormBuilderTextField(
                            name: 'blok',
                            controller: nmBlokCtr,
                            decoration: InputDecoration(
                              prefixIcon: Container(
                                padding: EdgeInsets.all(10),
                                child: SvgPicture.asset(
                                  'assets/icon/street.svg',
                                  color: Color(0xffD1D5DB),
                                ),
                              ),
                              labelText: 'Nama Blok',
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
                          //! Nomor
                          FormBuilderTextField(
                            name: 'nomorRumah',
                            controller: noRumahCtr,
                            decoration: InputDecoration(
                              prefixIcon: Container(
                                padding: EdgeInsets.all(10),
                                child: SvgPicture.asset(
                                  'assets/icon/block.svg',
                                  color: Color(0xffD1D5DB),
                                ),
                              ),
                              labelText: 'Nomor Rumah',
                              labelStyle: TextPalette.hintTextStyle,
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context),
                            ]),
                            keyboardType: TextInputType.text,
                          ),
                        ],
                      ),
                    )
                  ],
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
                                "Data Penghuni",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 22,
                                    color: Colors.black),
                              ),
                              Text(
                                "Masukkan Identitas Penghuni",
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
                          //! Status Penghuni
                          Text(
                            "Status Penghuni",
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Color(0xffE5E5E5).withOpacity(0.5)),
                            child: Row(children: [
                              Flexible(
                                //!Pemilik
                                child: InkWell(
                                    child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: pemilik == false
                                          ? Colors.transparent
                                          : ColorPalette.primary),
                                  child: TextButton(
                                      onPressed: () {
                                        pemilik = !pemilik;
                                        if (kontrak == true) {
                                          kontrak = false;
                                        }
                                        if (pemilik) {
                                          statusPenghuni = true;
                                        } else {
                                          statusPenghuni = false;
                                        }
                                        setState(() {});
                                      },
                                      child: Text(
                                        "Pemilik",
                                        style: TextStyle(
                                            fontFamily: "Nunito",
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                            color: pemilik == false
                                                ? Colors.black
                                                : Colors.white),
                                      )),
                                )),
                              ),
                              Flexible(
                                //!Kontrak
                                child: InkWell(
                                    child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: kontrak == false
                                          ? Colors.transparent
                                          : ColorPalette.primary),
                                  child: TextButton(
                                      onPressed: () {
                                        kontrak = !kontrak;
                                        if (pemilik == true) {
                                          pemilik = false;
                                        }
                                        if (kontrak) {
                                          statusPenghuni = false;
                                        } else {
                                          statusPenghuni = true;
                                        }
                                        setState(() {});
                                      },
                                      child: Text(
                                        "Kontrak",
                                        style: TextStyle(
                                            fontFamily: "Nunito",
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                            color: kontrak == false
                                                ? Colors.black
                                                : Colors.white),
                                      )),
                                )),
                              )
                            ]),
                          ),
                          Divider(
                            thickness: 1,
                            color: Color(0xff979797).withOpacity(0.25),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          //!Ktp
                          FormBuilderTextField(
                            name: 'noKtp',
                            controller: noKtpCtr,
                            decoration: InputDecoration(
                              prefixIcon: Container(
                                padding: EdgeInsets.all(10),
                                child: SvgPicture.asset(
                                  'assets/icon/id_card.svg',
                                  color: Color(0xffD1D5DB),
                                ),
                              ),
                              labelText: 'Nomor KTP',
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
                          //!Nama Penghuni
                          FormBuilderTextField(
                            name: 'nmPenghuni',
                            controller: nmPenghuniCtr,
                            decoration: InputDecoration(
                              prefixIcon: Container(
                                padding: EdgeInsets.all(10),
                                child: SvgPicture.asset(
                                  'assets/icon/user.svg',
                                  color: Color(0xffD1D5DB),
                                ),
                              ),
                              labelText: 'Nama Penghuni',
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

                                      if (isFemale) {
                                        gender = "P";
                                      } else {
                                        gender = "L";
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
                          //! Nomor Wa
                          FormBuilderTextField(
                            name: 'nomorWa',
                            controller: noTelpCtr,
                            decoration: InputDecoration(
                              prefixIcon: Container(
                                padding: EdgeInsets.all(10),
                                child: SvgPicture.asset(
                                  'assets/icon/phone.svg',
                                  color: Color(0xffD1D5DB),
                                ),
                              ),
                              labelText: 'No WA Aktif',
                              labelStyle: TextPalette.hintTextStyle,
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context),
                            ]),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    )
                  ],
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
                                "Jenis Iuran",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 22,
                                    color: Colors.black),
                              ),
                              Text(
                                "Pilih Jenis Iuran",
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
                              itemCount: listIuran.length,
                              itemBuilder: (BuildContext context, index) {
                                var dues = listIuran[index];
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
                                    value: dues.check,
                                    onChanged: (val) {
                                      setState(() {
                                        dues.check = val!;
                                        this.onchange(dues.id.toString(), val);
                                      });
                                    },
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          dues.name!,
                                          style: TextStyle(
                                              fontFamily: "Nunito",
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black
                                                  .withOpacity(0.8)),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(right: 20),
                                          child: Text(
                                            NumberFormat.currency(
                                                    locale: 'id',
                                                    symbol: 'Rp. ',
                                                    decimalDigits: 0)
                                                .format(dues.amount),
                                            style: TextStyle(
                                                fontFamily: "Nunito",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xff58C863)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pagePosition != 2.0
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
                    itemHouses = PostHouses(
                      rtPlace: rtrw,
                      street: nmJalanCtr.text,
                      houseBlock: nmBlokCtr.text,
                      houseNumber: noRumahCtr.text,
                      isVacant: statusRumah,
                      citizenIdCard: noKtpCtr.text,
                      citizenName: nmPenghuniCtr.text,
                      citizenGender: gender,
                      citizenPhone: noTelpCtr.text,
                      isPermanentCitizen: statusPenghuni,
                      subscriptions: jenisIuran,
                      isFree: gratisIuran,
                    );
                  });

                  BlocProvider.of<HousesBloc>(context)
                      .add(AddHousesEvent(houses: itemHouses));
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
        backgroundColor: ColorPalette.primary,
        child: pagePosition != 2.0
            ? SvgPicture.asset(
                "assets/icon/next.svg",
                color: Color(0xffFFFFFF),
              )
            : Icon(
                Icons.check,
                size: 36,
              ),
      ),
    );
  }

  void onchange(String id, bool isCheck) {
    setState(() {
      if (isCheck) {
        if (jenisIuran.contains(id)) {
        } else {
          jenisIuran.add(id.toString());
        }
      } else {
        if (jenisIuran.contains(id)) {
          jenisIuran.remove(id);
        }
      }
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
