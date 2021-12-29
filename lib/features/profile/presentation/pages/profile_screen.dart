import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kmp_pengurus_app/env.dart';
import 'package:kmp_pengurus_app/features/profile/data/models/profile_model.dart';
import 'package:kmp_pengurus_app/features/profile/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/features/profile/presentation/pages/edit_password_screen.dart';
import 'package:kmp_pengurus_app/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:kmp_pengurus_app/framework/managers/helper.dart';
import 'package:kmp_pengurus_app/framework/widgets/loading_indicator.dart';
import 'package:kmp_pengurus_app/service_locator.dart';
import 'package:kmp_pengurus_app/theme/colors.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool info = true;
  bool infoKampung = false;
  final List<Map<String, dynamic>> daftar = [
    {
      "nama": "RT 01",
      "ketua": "Pak maul",
    },
    {
      "nama": "RT 02",
      "ketua": "Pak Davit",
    },
    {
      "nama": "RT 04",
      "ketua": "Pak Ardy",
    },
    {
      "nama": "RT 03",
      "ketua": "Pak amir",
    },
    {
      "nama": "RT 05",
      "ketua": "Ibu Alfi",
    },
    {
      "nama": "RT 08",
      "ketua": "Pak Ardy",
    },
    {
      "nama": "RT 07",
      "ketua": "Pak amir",
    },
    {
      "nama": "RT 09",
      "ketua": "Ibu Alfi",
    },
  ];

  bool isLoading = false;
  Caretaker? dataProfile;
  ProfileModel? profileModel;
  String namaPetugas = "";
  String posisi = "Pengurus";
  String provinsi = '';
  String kabupaten = '';
  String kecamatan = '';
  String kelurahan = '';
  String jalan = '';

  @override
  void initState() {
    BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  Widget _build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) async {
        if (state is ProfileLoading) {
          isLoading = false;
          setState(() {});
        } else if (state is ProfileLoaded) {
          if (state.data != null) {
            dataProfile = state.data;
            profileModel = state.profile;
            namaPetugas = state.data!.userName!;
            provinsi = state.data!.provinceName!;
            kabupaten = state.data!.cityName!;
            kecamatan = state.data!.districtName!;
            kelurahan = state.data!.subDistrictName!;
            jalan = state.data!.street!;

            isLoading = true;
            setState(() {});
          }
        } else if (state is ProfileFailure) {
          catchAllException(context, state.error, true);
          setState(() {});
        } else if (state is EditProfileSuccess) {
          BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
          setState(() {});
        }
      },
      child: isLoading ? _buildBody(context) : LoadingIndicator(),
    );
  }

  Widget _buildBody(BuildContext context) {
    var foto = profileModel!.avatar;
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
                Text(
                  "Profil",
                  style: TextStyle(
                      fontFamily: "Nunito",
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: Colors.white),
                )
              ]),
              InkWell(
                onTap: () async {
                  await pushNewScreen(
                    context,
                    screen: BlocProvider(
                      create: (context) => serviceLocator.get<ProfileBloc>(),
                      child: ProgressHUD(
                        child: EditProfile(
                          data: dataProfile,
                        ),
                      ),
                    ),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );

                  BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  height: 33,
                  width: 33,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(16)),
                  child: SvgPicture.asset("assets/icon/edit-user.svg"),
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
              Center(
                child: profileModel!.avatar!.isNotEmpty
                    ? CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(
                          '${Env().apiBaseUrl}/${foto!}',
                        ))
                    : CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          "assets/images/profile.png",
                          height: 136,
                        ),
                      ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                namaPetugas,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 18,
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 9),
                  height: 36,
                  width: 224,
                  decoration: BoxDecoration(
                    color: Color(0xffDD4041),
                    borderRadius: BorderRadius.circular(39),
                  ),
                  child: Center(
                    child: Text(
                      posisi,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        fontSize: 13,
                      ),
                    ),
                  ))
            ],
          ),
          // bagian bawah
          SizedBox.expand(
            child: DraggableScrollableSheet(
              initialChildSize: 0.54,
              minChildSize: 0.54,
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
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: SvgPicture.asset("assets/icon/line.svg"),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 48,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffE5E5E5).withOpacity(0.5)),
                              child: Row(children: [
                                Flexible(
                                  //!Info
                                  child: InkWell(
                                      child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    height: 48,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: info == false
                                            ? Colors.transparent
                                            : ColorPalette.primary),
                                    child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            info = true;
                                            infoKampung = false;
                                          });
                                        },
                                        child: Text(
                                          "Info",
                                          style: TextStyle(
                                              fontFamily: "Nunito",
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: info == false
                                                  ? Color(0xffC4C4C4)
                                                  : Colors.white),
                                        )),
                                  )),
                                ),
                                Flexible(
                                  //!Info Kampung
                                  child: InkWell(
                                      child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    height: 48,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: infoKampung == false
                                            ? Colors.transparent
                                            : ColorPalette.primary),
                                    child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            info = false;
                                            infoKampung = true;
                                          });
                                        },
                                        child: Text(
                                          "Info Kampung",
                                          style: TextStyle(
                                              fontFamily: "Nunito",
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: infoKampung == false
                                                  ? Color(0xffC4C4C4)
                                                  : Colors.white),
                                        )),
                                  )),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                      SliverList(
                          delegate: SliverChildListDelegate([
                        info
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(top: 19),
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Nomor Whatsapp",
                                            style: TextStyle(
                                                fontFamily: "Nunito",
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                color: Color(0xffBEC2C9)),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 4),
                                            child: Text(
                                              dataProfile!.phone! == ""
                                                  ? " - "
                                                  : dataProfile!.phone!,
                                              style: TextStyle(
                                                  fontFamily: "Nunito",
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                            "Email",
                                            style: TextStyle(
                                                fontFamily: "Nunito",
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                color: Color(0xffBEC2C9)),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 4),
                                            child: Text(
                                              dataProfile!.email! == ""
                                                  ? " - "
                                                  : dataProfile!.email!,
                                              style: TextStyle(
                                                  fontFamily: "Nunito",
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 17, bottom: 17),
                                            child: Divider(
                                              color: Color(0xff979797)
                                                  .withOpacity(0.25),
                                              thickness: 2,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              await pushNewScreen(
                                                context,
                                                screen: BlocProvider(
                                                  create: (context) =>
                                                      serviceLocator
                                                          .get<ProfileBloc>(),
                                                  child: ProgressHUD(
                                                      child:
                                                          EditPasswordScreen()),
                                                ),
                                                withNavBar: false,
                                                pageTransitionAnimation:
                                                    PageTransitionAnimation
                                                        .cupertino,
                                              );
                                              BlocProvider.of<ProfileBloc>(
                                                      context)
                                                  .add(GetProfileEvent());
                                            },
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(right: 17),
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Ubah Password",
                                                    style: TextStyle(
                                                        fontFamily: "Nunito",
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 15,
                                                        color: Colors.black
                                                            .withOpacity(0.8)),
                                                  ),
                                                  SvgPicture.asset(
                                                    "assets/icon/arrow-right.svg",
                                                    color: Colors.black
                                                        .withOpacity(0.8),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              logout(context);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(top: 22),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              height: 49,
                                              decoration: BoxDecoration(
                                                color: Color(0xffF54748),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 20),
                                                    child: Text(
                                                      'Logout',
                                                      style: TextStyle(
                                                        fontFamily: "Nunito",
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        right: 20),
                                                    child: SvgPicture.asset(
                                                        "assets/icon/logout.svg"),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                ],
                              )
                            : SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 21),
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        color: Color(0xffF54748),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 16),
                                            child: Center(
                                              child: Text(
                                                jalan,
                                                style: TextStyle(
                                                    fontFamily: "Nunito",
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 13,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 15),
                                            child: Text(
                                              kelurahan +
                                                  ", " +
                                                  kecamatan +
                                                  ", " +
                                                  kabupaten +
                                                  ", " +
                                                  provinsi,
                                              style: TextStyle(
                                                  fontFamily: "Nunito",
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                      ]))
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
}
