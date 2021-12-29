import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:kmp_pengurus_app/features/master/houses/presentation/bloc/house_bloc.dart';
import 'package:kmp_pengurus_app/features/master/houses/presentation/pages/house_master_screen.dart';
import 'package:kmp_pengurus_app/service_locator.dart';
import 'package:kmp_pengurus_app/theme/colors.dart';

class HousesPage extends StatefulWidget {
  static const routeName = '/houses';
  final bool? isPic;
  final bool? isTreasurer;
  HousesPage(
      {Key? key, required this.isPic, required this.isTreasurer})
      : super(key: key);

  @override
  _HousesPageState createState() => _HousesPageState();
}

class _HousesPageState extends State<HousesPage> {
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
              create: (_) => serviceLocator.get<HousesBloc>(),
            ),
          ],
          child: ProgressHUD(child: HouseMasterScreen(isPic: isPic, isTreasurer: isTreasurer,)),
        ),
      ),
    );
  }
}
