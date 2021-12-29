import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/presentation/pages/caretaker_screen.dart';
import 'package:kmp_pengurus_app/service_locator.dart';
import 'package:kmp_pengurus_app/theme/colors.dart';

class CaretakerPage extends StatefulWidget {
  static const routeName = '/subscriptions';
  final bool? isPic;
  final bool? isTreasurer;
  CaretakerPage(
      {Key? key, required this.isPic, required this.isTreasurer})
      : super(key: key);

  @override
  _CaretakerPageState createState() => _CaretakerPageState();
}

class _CaretakerPageState extends State<CaretakerPage> {
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
              create: (_) => serviceLocator.get<CaretakerBloc>(),
            ),
          ],
          child: ProgressHUD(child: CaretakerScreen(isPic: isPic, isTreasurer: isTreasurer,)),
        ),
      ),
    );
  }
}
