import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:kmp_pengurus_app/features/master/master_screen.dart';
import 'package:kmp_pengurus_app/features/profile/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/service_locator.dart';
import 'package:kmp_pengurus_app/theme/colors.dart';

class MasterPage extends StatefulWidget {
  final bool? isPic;
  final bool? isTreasurer;
  MasterPage(
      {Key? key, required this.isPic, required this.isTreasurer})
      : super(key: key);

  @override
  _MasterPageState createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
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
              create: (_) => serviceLocator.get<ProfileBloc>(),
            ),
          ],
          child: ProgressHUD(child: MasterScreen(isPic: isPic, isTreasurer: isTreasurer),),
        ),
      ),
    );
  }
}
