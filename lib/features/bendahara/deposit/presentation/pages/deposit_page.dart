import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:kmp_pengurus_app/features/bendahara/deposit/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/features/bendahara/deposit/presentation/pages/deposit_master_screen.dart';
import 'package:kmp_pengurus_app/service_locator.dart';
import 'package:kmp_pengurus_app/theme/colors.dart';

class DepositPage extends StatefulWidget {
  static const routeName = '/deposit';
  final bool? isPic;
  final bool? isTreasurer;
  DepositPage(
      {Key? key, required this.isPic, required this.isTreasurer})
      : super(key: key);

  @override
  _DepositPageState createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  bool? isPic;
  bool? isTreasurer;
  @override
  void initState() {
    super.initState();
    isPic = widget.isPic;
    isTreasurer = widget.isTreasurer;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        backgroundColor: ColorPalette.primary,
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => serviceLocator.get<DepositBloc>(),
            ),
          ],
          child: ProgressHUD(child: DepositScreen(isPic: isPic, isTreasurer: isTreasurer,)),
        ),
      ),
    );
  }
}
