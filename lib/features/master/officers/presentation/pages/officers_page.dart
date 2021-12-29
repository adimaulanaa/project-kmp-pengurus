import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:kmp_pengurus_app/features/master/officers/presentation/bloc/officers_bloc.dart';
import 'package:kmp_pengurus_app/features/master/officers/presentation/pages/officer_master_screen.dart';
import 'package:kmp_pengurus_app/service_locator.dart';
import 'package:kmp_pengurus_app/theme/colors.dart';

class OfficersPage extends StatefulWidget {
  static const routeName = '/officers';
  final bool? isPic;
  final bool? isTreasurer;
  OfficersPage(
      {Key? key, required this.isPic, required this.isTreasurer})
      : super(key: key);

  @override
  _OfficersPageState createState() => _OfficersPageState();
}

class _OfficersPageState extends State<OfficersPage> {
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
              create: (_) => serviceLocator.get<OfficersBloc>(),
            ),
          ],
          child: ProgressHUD(child: PetugasScreen(isPic: isPic, isTreasurer: isTreasurer,)),
        ),
      ),
    );
  }
}
