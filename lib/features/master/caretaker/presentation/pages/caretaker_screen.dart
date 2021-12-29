import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/data/models/caretaker_model.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/presentation/bloc/caretaker_bloc.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/presentation/pages/add_caretaker.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/presentation/pages/edit_caretaker.dart';
import 'package:kmp_pengurus_app/features/master/master_screen.dart';
import 'package:kmp_pengurus_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:kmp_pengurus_app/framework/managers/helper.dart';
import 'package:kmp_pengurus_app/framework/widgets/loading_indicator.dart';
import 'package:kmp_pengurus_app/service_locator.dart';
import 'package:kmp_pengurus_app/theme/button.dart';
import 'package:kmp_pengurus_app/theme/colors.dart';
import 'package:kmp_pengurus_app/theme/enum.dart';

class CaretakerScreen extends StatefulWidget {
  final bool? isPic;
  final bool? isTreasurer;
  CaretakerScreen({Key? key, required this.isPic, required this.isTreasurer})
      : super(key: key);

  @override
  _CaretakerScreenState createState() => _CaretakerScreenState();
}

class _CaretakerScreenState extends State<CaretakerScreen> {
  String message = '';
  bool isInternetConnected = true;
  List<Caretakers> listData = [];
  bool isLoading = false;
  bool? isPic;
  bool? isTreasurer;

  TextEditingController editingController = TextEditingController();
  bool isSearch = false;
  List<Caretakers> dummySearchList = [];
  List<Caretakers> searchList = [];

  void searchResults(String value) {
    dummySearchList.clear();
    dummySearchList.addAll(listData);
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
    isPic = widget.isPic;
    isTreasurer = widget.isTreasurer;
    BlocProvider.of<CaretakerBloc>(context).add(LoadCaretaker());
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
          isLoading = false;
          setState(() {});
        } else if (state is CaretakerLoaded) {
          if (state.data != null && state.data!.paginate!.docs!.length > 0) {
            listData = state.data!.paginate!.docs!;
          }
          isLoading = true;
          setState(() {});
        } else if (state is CaretakerFailure) {
          catchAllException(context, state.error, true);
          setState(() {});
        }
      },
      child: isLoading
          ? isSearch
              ? _buildBodySearch(context)
              : _buildBody(context)
          : LoadingIndicator(),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            leading: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider(
                                  create: (context) =>
                                      serviceLocator.get<ProfileBloc>(),
                                  child: ProgressHUD(
                                    child: MasterScreen(
                                        isPic: isPic, isTreasurer: isTreasurer),
                                  ),
                                )));
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
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
            actions: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isSearch = true;
                      });
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
                        "assets/icon/search.svg",
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                ],
              )
            ],
            automaticallyImplyLeading: false,
            pinned: true,
            expandedHeight: 110,
            backgroundColor: Color(0xffF8F8F8),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              title: Text(
                "Pengurus",
                style: TextStyle(
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    fontSize: 22,
                    fontStyle: FontStyle.normal),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 30,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        "Kelola Data Pengurus",
                        style: TextStyle(
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w400,
                            color: Color(0xff979797),
                            fontSize: 12,
                            fontStyle: FontStyle.normal),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ]),
            ),
          ),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: customListPengurus(context, index),
                      )),
                ],
              );
            }, childCount: listData.length),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isPic!
            ? () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlocProvider(
                              create: (context) =>
                                  serviceLocator.get<CaretakerBloc>(),
                              child: ProgressHUD(child: AddCaretakerScreen()),
                            )));
                BlocProvider.of<CaretakerBloc>(context).add(LoadCaretaker());
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

  Widget _buildBodySearch(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          elevation: 0,
          leading: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20),
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
          actions: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10),
                  height: 50,
                  width: 200,
                  child: TextField(
                      style: TextStyle(
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w700,
                          color: Color(0XFF121212).withOpacity(0.8),
                          fontSize: 16,
                          fontStyle: FontStyle.normal),
                      onChanged: (value) {
                        searchResults(value);
                      },
                      controller: editingController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Cari...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w700,
                            color: Color(0XFF121212).withOpacity(0.38),
                            fontSize: 16,
                            fontStyle: FontStyle.normal),
                      )),
                ),
                SizedBox(
                  width: 25,
                ),
                Container(
                  margin: EdgeInsets.only(right: 20, top: 6),
                  padding: EdgeInsets.all(10),
                  height: 33,
                  width: 33,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isSearch = false;
                        editingController.text = '';
                        searchList.clear();
                      });
                    },
                    child: SvgPicture.asset(
                      "assets/icon/close.svg",
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            )
          ],
          automaticallyImplyLeading: false,
          pinned: true,
          expandedHeight: 110,
          backgroundColor: Color(0xffF8F8F8),
        ),
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return Column(
              children: [
                Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: customListPengurusSearch(context, index),
                    )),
              ],
            );
          }, childCount: searchList.length),
        )
      ]),
    );
  }

  Widget customListPengurus(BuildContext context, int index) {
    return InkWell(
      onTap: isPic!
          ? () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            create: (context) =>
                                serviceLocator.get<CaretakerBloc>(),
                            child: ProgressHUD(
                                child: EditCaretaker(
                              data: listData[index],
                            )),
                          )));
              BlocProvider.of<CaretakerBloc>(context).add(LoadCaretaker());
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
      child: Container(
        width: double.infinity,
        height: 68,
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: 5,
              height: 62,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: listData[index].isActive!
                      ? Color(0xffF54748)
                      : Color(0xffC4C4C4)),
            ),
            SizedBox(
              width: 2,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: 68,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.only(top: 18),
                              child: Text(
                                listData[index].name == null
                                    ? ""
                                    : listData[index].name!,
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black.withOpacity(0.8),
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal),
                              )),
                          Container(
                              child: Text(
                            listData[index].phone == null
                                ? ""
                                : listData[index].phone!,
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w700,
                                color: Color(0XFF121212),
                                fontSize: 12,
                                fontStyle: FontStyle.normal),
                          )),
                        ],
                      ),
                      Icon(Icons.chevron_right)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget customListPengurusSearch(BuildContext context, int index) {
    return InkWell(
      onTap: isPic!
          ? () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            create: (context) =>
                                serviceLocator.get<CaretakerBloc>(),
                            child: ProgressHUD(
                                child: EditCaretaker(
                              data: searchList[index],
                            )),
                          )));
              BlocProvider.of<CaretakerBloc>(context).add(LoadCaretaker());
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
      child: Container(
        width: double.infinity,
        height: 68,
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: 5,
              height: 62,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: searchList[index].isActive!
                      ? Color(0xffF54748)
                      : Color(0xffC4C4C4)),
            ),
            SizedBox(
              width: 2,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: 68,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.only(top: 18),
                              child: Text(
                                searchList[index].name!,
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black.withOpacity(0.8),
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal),
                              )),
                          Container(
                              child: Text(
                            searchList[index].phone!,
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w700,
                                color: Color(0XFF121212),
                                fontSize: 12,
                                fontStyle: FontStyle.normal),
                          )),
                        ],
                      ),
                      Icon(Icons.chevron_right)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
