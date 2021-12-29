import 'package:another_flushbar/flushbar_helper.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:kmp_pengurus_app/config/global_vars.dart';
import 'package:kmp_pengurus_app/config/string_resources.dart';
import 'package:kmp_pengurus_app/features/master/category/data/models/category_model.dart';
import 'package:kmp_pengurus_app/features/master/category/domain/entities/post_category.dart';
import 'package:kmp_pengurus_app/features/master/category/presentation/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmp_pengurus_app/framework/managers/helper.dart';
import 'package:kmp_pengurus_app/theme/colors.dart';

class EditCategory extends StatefulWidget {
  final AccountCategory? data;
  const EditCategory({Key? key, this.data}) : super(key: key);

  @override
  _EditCategoryState createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  String id = '';
  bool? isActive;

  TextEditingController nameCtr = new TextEditingController();
  TextEditingController descriptionCtr = new TextEditingController();

  @override
  void initState() {
    super.initState();
    id = widget.data!.id!;
    nameCtr.text = widget.data!.name!;
    descriptionCtr.text = widget.data!.description!;
    isActive = widget.data!.isActive;

    setState(() {});
    BlocProvider.of<CategoryBloc>(context).add(EditLoadCategory());
  }

  late PostCategory itemCategory;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  Widget _build(BuildContext context) {
    return BlocListener<CategoryBloc, CategoryState>(
      listener: (context, state) async {
        if (state is CategoryLoading) {
          final progress = ProgressHUD.of(context);
          progress?.showWithText(
              GlobalConfiguration().getValue(GlobalVars.TEXT_LOADING_TITLE) ??
                  StringResources.PLEASE_WAIT);
          setState(() {});
        } else if (state is EditCategoryLoaded) {
          final progress = ProgressHUD.of(context);
          progress!.dismiss();
        } else if (state is CategorySuccess) {
          _thankYouPopup();
        } else if (state is DeleteCategorySuccess) {
          _deletePopup();
        } else if (state is CategoryFailure) {
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
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              height: 33,
              width: 33,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1.5,
                  blurRadius: 15,
                  offset: Offset(0, 1),
                ),
              ], borderRadius: BorderRadius.circular(16), color: Colors.white),
              child: SvgPicture.asset(
                "assets/icon/back.svg",
                color: Colors.black,
              ),
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              final progress = ProgressHUD.of(context);

              progress!.showWithText(GlobalConfiguration()
                      .getValue(GlobalVars.TEXT_LOADING_TITLE) ??
                  StringResources.PLEASE_WAIT);

              FocusScope.of(context).requestFocus(new FocusNode());

              BlocProvider.of<CategoryBloc>(context)
                  .add(DeleteCategoryEvent(idCategory: widget.data!.id!));
              progress.dismiss();
            },
            child: Container(
                margin: EdgeInsets.only(top: 29, right: 27),
                child: Text("Hapus",
                    style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        fontStyle: FontStyle.normal,
                        color: Color(0xffF54748)))),
          ),
        ],
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
                disabledBorder: OutlineInputBorder(
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
                              "Edit Kategori",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w800,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 22,
                                  color: Colors.black),
                            ),
                            Text(
                              "Masukkan Data Kategori",
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
                        //!Nama
                        FormBuilderTextField(
                          controller: nameCtr,
                          name: 'name',
                          decoration: InputDecoration(
                            prefixIcon: Container(
                              padding: EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                'assets/icon/id_card.svg',
                                color: Color(0xffD1D5DB),
                              ),
                            ),
                            labelText: 'Nama Kategori',
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
                        //!Description
                        FormBuilderTextField(
                          controller: descriptionCtr,
                          name: 'description',
                          decoration: InputDecoration(
                            prefixIcon: Container(
                              padding: EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                'assets/icon/user.svg',
                                color: Color(0xffD1D5DB),
                              ),
                            ),
                            labelText: 'Description',
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
              itemCategory = PostCategory(
                  id: widget.data!.id,
                  name: nameCtr.text,
                  description: descriptionCtr.text,
                  isActive: isActive);
            });

            BlocProvider.of<CategoryBloc>(context)
                .add(EditCategoryEvent(categoryEdit: itemCategory));
            progress.dismiss();
          } else {
            final progress = ProgressHUD.of(context);
            progress!.showWithText(
                GlobalConfiguration().getValue(GlobalVars.TEXT_LOADING_TITLE) ??
                    StringResources.PLEASE_WAIT);
            progress.dismiss();
            FlushbarHelper.createError(
                message: "Harap Memasukkan Data Valid",
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

  Future<void> _deletePopup() {
    return CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: "Data berhasil dihapus",
        confirmBtnText: 'Ok',
        onConfirmBtnTap: () async {
          int count = 0;
          Navigator.of(context).popUntil((_) => count++ >= 2);
        });
  }
}
