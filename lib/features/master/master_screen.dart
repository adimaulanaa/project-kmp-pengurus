import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kmp_pengurus_app/features/home/presentation/pages/home_page.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/presentation/pages/caretaker_page.dart';
import 'package:kmp_pengurus_app/features/master/category/presentation/pages/category_page.dart';
import 'package:kmp_pengurus_app/features/master/houses/presentation/pages/house_page.dart';
import 'package:kmp_pengurus_app/features/master/officers/presentation/pages/officers_page.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/presentation/pages/subscriptions_page.dart';
import 'package:kmp_pengurus_app/features/profile/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/framework/managers/helper.dart';

class MasterScreen extends StatefulWidget {
  final bool? isPic;
  final bool? isTreasurer;
  MasterScreen(
      {Key? key, required this.isPic, required this.isTreasurer})
      : super(key: key);

  @override
  _MasterScreenState createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {

  bool? isPic;
  bool? isTreasurer;

  @override
  void initState() {
    super.initState();
    isPic = widget.isPic;
    isTreasurer = widget.isTreasurer;
    BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  Widget _build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) async {
        if (state is ProfileLoading) {
        } else if (state is ProfileLoaded) {
          if (state.data != null) {
            isPic = state.data!.isPic!;
            isTreasurer = state.data!.isTreasurer;
            setState(() {});
          }
        } else if (state is ProfileFailure) {
          catchAllException(context, state.error, true);
          setState(() {});
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
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 25),
            child: Text(
              "Master Data",
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontFamily: "Nunito"),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 25),
            child: Text(
              "Kelola Data Apapun",
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xff979797),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Nunito"),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SubscriptionsPage(isPic: isPic, isTreasurer: isTreasurer,)));
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Container(
                padding: EdgeInsets.only(left: 15, right: 21),
                height: 68,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          height: 46,
                          width: 46,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Color(0xff58C863).withOpacity(0.1)),
                          child:
                              SvgPicture.asset("assets/icon/empty_wallet.svg"),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Iuran",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: "Nunito"),
                            ),
                            Text(
                              "Kelola Jenis Iuran",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xff121212),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Nunito"),
                            )
                          ],
                        )
                      ],
                    ),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HousesPage(isPic: isPic, isTreasurer: isTreasurer,)));
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Container(
                padding: EdgeInsets.only(left: 15, right: 21),
                height: 68,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          height: 46,
                          width: 46,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Color(0xffF54748).withOpacity(0.1)),
                          child:
                              SvgPicture.asset("assets/icon/home_master.svg"),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Rumah",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: "Nunito"),
                            ),
                            Text(
                              "Kelola Rumah Warga",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xff121212),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Nunito"),
                            )
                          ],
                        )
                      ],
                    ),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CaretakerPage(isPic: isPic, isTreasurer: isTreasurer,)));
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Container(
                padding: EdgeInsets.only(left: 15, right: 21),
                height: 68,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          height: 46,
                          width: 46,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Color(0xff2FA9ED).withOpacity(0.1)),
                          child: SvgPicture.asset("assets/icon/pengurus.svg"),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Pengurus",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: "Nunito"),
                            ),
                            Text(
                              "Kelola Pengurus",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xff121212),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Nunito"),
                            )
                          ],
                        )
                      ],
                    ),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OfficersPage(isPic: isPic, isTreasurer: isTreasurer,)));
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Container(
                padding: EdgeInsets.only(left: 15, right: 21),
                height: 68,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          height: 46,
                          width: 46,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Color(0xffAB58C8).withOpacity(0.1)),
                          child: SvgPicture.asset("assets/icon/officer.svg"),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Petugas",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: "Nunito"),
                            ),
                            Text(
                              "Kelola Petugas",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xff121212),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Nunito"),
                            )
                          ],
                        )
                      ],
                    ),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CategoryPage(isPic: isPic, isTreasurer: isTreasurer,)));
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Container(
                padding: EdgeInsets.only(left: 15, right: 21),
                height: 68,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          height: 46,
                          width: 46,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Color(0xffFFB61D).withOpacity(0.1)),
                          child:
                              SvgPicture.asset("assets/icon/category_data.svg"),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Kategori Keuangan",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: "Nunito"),
                            ),
                            Text(
                              "Kelola Jenis Kategori",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xff121212),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Nunito"),
                            )
                          ],
                        )
                      ],
                    ),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
