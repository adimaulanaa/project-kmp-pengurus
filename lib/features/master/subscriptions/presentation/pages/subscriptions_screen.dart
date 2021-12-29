import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:kmp_pengurus_app/features/master/master_screen.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/presentation/pages/add_subscription.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/data/models/subscriptions_model.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/presentation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/presentation/pages/edit_subscription.dart';
import 'package:kmp_pengurus_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:kmp_pengurus_app/framework/managers/helper.dart';
import 'package:kmp_pengurus_app/framework/widgets/loading_indicator.dart';
import 'package:kmp_pengurus_app/service_locator.dart';
import 'package:kmp_pengurus_app/theme/button.dart';
import 'package:kmp_pengurus_app/theme/colors.dart';
import 'package:kmp_pengurus_app/theme/enum.dart';

class SubscriptionsScreen extends StatefulWidget {
  final bool? isPic;
  final bool? isTreasurer;
  SubscriptionsScreen(
      {Key? key, required this.isPic, required this.isTreasurer})
      : super(key: key);

  @override
  _SubscriptionsScreenState createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  String message = '';
  bool isInternetConnected = true;
  List<Subscription> listData = [];
  bool isLoading = false;
  String tanggalAktif = '';

  TextEditingController editingController = TextEditingController();
  bool isSearch = false;
  List<Subscription> dummySearchList = [];
  List<Subscription> searchList = [];

  bool? isPic;
  bool? isTreasurer;

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
    BlocProvider.of<SubscriptionsBloc>(context).add(LoadSubscriptions());
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
    return BlocListener<SubscriptionsBloc, SubscriptionsState>(
      listener: (context, state) async {
        if (state is SubscriptionsLoading) {
          isLoading = false;
          setState(() {});
        } else if (state is SubscriptionsLoaded) {
          if (state.data != null && state.data!.paginate!.docs!.length > 0) {
            listData = state.data!.paginate!.docs!;
          }
          isLoading = true;
          setState(() {});
        } else if (state is SubscriptionsFailure) {
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
                    // Navigator.pop(context);
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
                "Iuran",
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
                        "Kelola Data Iuran",
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
                        child: customListIuran(context, index),
                      )),
                ],
              );
            }, childCount: listData.length),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isPic!
            ? isTreasurer!
                ? () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider(
                                  create: (context) =>
                                      serviceLocator.get<SubscriptionsBloc>(),
                                  child: ProgressHUD(child: AddIuranScreen()),
                                )));
                    BlocProvider.of<SubscriptionsBloc>(context)
                        .add(LoadSubscriptions());
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                            borderRadius:
                                                BorderRadius.circular(14),
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
                      child: customListIuranSearch(context, index),
                    )),
              ],
            );
          }, childCount: searchList.length),
        )
      ]),
    );
  }

  Widget customListIuran(BuildContext context, int index) {
    return InkWell(
      onTap: isPic!
          ? isTreasurer!
              ? () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BlocProvider(
                                create: (context) =>
                                    serviceLocator.get<SubscriptionsBloc>(),
                                child: ProgressHUD(
                                    child: EditSubscription(
                                  data: listData[index],
                                )),
                              )));
                  BlocProvider.of<SubscriptionsBloc>(context)
                      .add(LoadSubscriptions());
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          borderRadius:
                                              BorderRadius.circular(14),
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
                            listData[index].amount == null
                                ? "0"
                                : NumberFormat.currency(
                                        locale: 'id',
                                        symbol: 'Rp. ',
                                        decimalDigits: 0)
                                    .format(listData[index].amount),
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

  Widget customListIuranSearch(BuildContext context, int index) {
    return InkWell(
      onTap: isPic!
          ? isTreasurer!
              ? () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BlocProvider(
                                create: (context) =>
                                    serviceLocator.get<SubscriptionsBloc>(),
                                child: ProgressHUD(
                                    child: EditSubscription(
                                  data: searchList[index],
                                )),
                              )));
                  BlocProvider.of<SubscriptionsBloc>(context)
                      .add(LoadSubscriptions());
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          borderRadius:
                                              BorderRadius.circular(14),
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
                            "Rp. " + searchList[index].amount.toString(),
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
