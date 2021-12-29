import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:kmp_pengurus_app/config/global_vars.dart';
import 'package:kmp_pengurus_app/config/string_resources.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/domain/entities/post_cash_book.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/presentation/pages/cash_book_screen.dart';
import 'package:kmp_pengurus_app/features/master/category/data/models/category_model.dart';
import 'package:kmp_pengurus_app/framework/managers/helper.dart';
import 'package:kmp_pengurus_app/framework/widgets/loading_indicator.dart';
import 'package:kmp_pengurus_app/service_locator.dart';
import 'package:kmp_pengurus_app/theme/colors.dart';

class AddCashScreen extends StatefulWidget {
  final bool isPic;
  final bool isTreasurer;
  const AddCashScreen(
      {Key? key, required this.isPic, required this.isTreasurer})
      : super(key: key);

  @override
  _AddCashScreenState createState() => _AddCashScreenState();
}

class _AddCashScreenState extends State<AddCashScreen> {
  bool pemasukan = false;
  bool pengeluaran = false;
  bool isLoading = false;
  bool? isPic;
  bool? isTreasurer;

  String? kategoriKas;
  String? nama;
  int? nominal;
  String? tipe;
  DateTime tanggal = DateTime.now();

  late PostCashBook itemCashBook;
  final _formKey = GlobalKey<FormBuilderState>();

  List<AccountCategory> listData = [];

  @override
  void initState() {
    super.initState();
    isPic = widget.isPic;
    isTreasurer = widget.isTreasurer;
    BlocProvider.of<CashBookBloc>(context).add(AddLoadCashBook());
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  Widget _build(BuildContext context) {
    return BlocListener<CashBookBloc, CashBookState>(
      listener: (context, state) async {
        if (state is AddLoadCashBook) {
          isLoading = false;
          setState(() {});
        } else if (state is AddCashBookLoaded) {
          if (state.data != null && state.data!.paginate!.docs!.length > 0) {
            listData = state.data!.paginate!.docs!;
          }
          isLoading = true;
          setState(() {});
        } else if (state is CashBookFailure) {
          catchAllException(context, state.error, true);
          setState(() {});
        }
         else if (state is CashBookSuccess) {
          _thankYouPopup();
        }
      },
      child: isLoading ? _buildBody(context) : LoadingIndicator(),
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
                                    serviceLocator.get<CashBookBloc>(),
                                child: ProgressHUD(
                                  child: CashBookScreen(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 25),
            child: Text(
              "Buat Catatan Kas",
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
              "Buat Catatan Laporan Kas Keuangan",
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
          Container(
            padding: EdgeInsets.only(left: 25, right: 25),
            child: FormBuilder(
                key: _formKey,
                child: Theme(
                    data: ThemeData(
                      inputDecorationTheme: InputDecorationTheme(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Color(0xffCCCED3)),
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
                    child: Column(
                      children: [
                        //! Jenis Catatan
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Color(0xffE5E5E5).withOpacity(0.5)),
                          child: Row(children: [
                            Flexible(
                              //!Pemasukan
                              child: InkWell(
                                  child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: pemasukan == false
                                        ? Colors.transparent
                                        : ColorPalette.primary),
                                child: TextButton(
                                    onPressed: () {
                                      pemasukan = !pemasukan;
                                      if (pengeluaran == true) {
                                        pengeluaran = false;
                                      }
                                      setState(() {});
                                    },
                                    child: Text(
                                      "Pemasukan",
                                      style: TextStyle(
                                          fontFamily: "Nunito",
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: pemasukan == false
                                              ? Colors.black
                                              : Colors.white),
                                    )),
                              )),
                            ),
                            Flexible(
                              //!Pengeluaran
                              child: InkWell(
                                  child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: pengeluaran == false
                                        ? Colors.transparent
                                        : ColorPalette.primary),
                                child: TextButton(
                                    onPressed: () {
                                      pengeluaran = !pengeluaran;
                                      if (pemasukan == true) {
                                        pemasukan = false;
                                      }
                                      setState(() {});
                                    },
                                    child: Text(
                                      "Pengeluaran",
                                      style: TextStyle(
                                          fontFamily: "Nunito",
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: pengeluaran == false
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
                        //!Tanggal
                        FormBuilderDateTimePicker(
                          initialValue: DateTime.now(),
                          name: 'date',
                          inputType: InputType.date,
                          onChanged: (dateVal) {
                            tanggal = dateVal!;
                          },
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
                        //!Judul
                        FormBuilderTextField(
                          name: 'judul',
                          onChanged: (nameVal) {
                            nama = nameVal!;
                          },
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
                        //!Nominal
                        FormBuilderTextField(
                          name: 'nominal',
                          onChanged: (priceVal) {
                            nominal = int.parse(priceVal!);
                          },
                          decoration: InputDecoration(
                            prefixIcon: Container(
                              padding: EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                'assets/icon/dollar.svg',
                                color: Color(0xffD1D5DB),
                              ),
                            ),
                            labelText: 'Nominal',
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
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        //!Kategori
                        FormBuilderDropdown(
                          name: 'kategori',
                          onChanged: (val) {
                            setState(() {
                              kategoriKas = val.toString();
                            });
                          },
                          decoration: InputDecoration(),
                          icon: Container(
                            child: SvgPicture.asset(
                              'assets/icon/category.svg',
                              color: Colors.black,
                            ),
                          ),
                          allowClear: true,
                          hint: Text(
                            'Kategori',
                            style: TextPalette.hintTextStyle,
                          ),
                          style: TextStyle(
                              fontFamily: "Nunito",
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required(context)]),
                          items: listData
                              .map((e) => DropdownMenuItem(
                                    value: e.id,
                                    child: Text('${e.name}'),
                                  ))
                              .toList(),
                        ),
                      ],
                    ))),
          )
        ],
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
              if (pemasukan) {
                tipe = 'PEMASUKAN';
              } else if (pengeluaran) {
                tipe = 'PENGELUARAN';
              }
              var dateCash = DateFormat('yyyy-MM-dd').format(tanggal);
              itemCashBook = PostCashBook(
                  name: nama,
                  price: nominal,
                  dateString: dateCash,
                  account: kategoriKas,
                  type: tipe);
            });
            BlocProvider.of<CashBookBloc>(context)
                .add(AddCashBookEvent(cashBook: itemCashBook));
            progress.dismiss();
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
