import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/presentation/pages/cash_book_screen.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/service_locator.dart';
import 'package:kmp_pengurus_app/theme/colors.dart';

class CashBookPage extends StatefulWidget {
  static const routeName = '/cashbook';
  final bool isPic;
  final bool isTreasurer;

  CashBookPage({Key? key, required this.isPic, required this.isTreasurer})
      : super(key: key);

  @override
  _CashBookPageState createState() => _CashBookPageState();
}

class _CashBookPageState extends State<CashBookPage> {
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
              create: (_) => serviceLocator.get<SubscriptionsBloc>(),
            ),
          ],
          child: ProgressHUD(
              child: CashBookScreen(isPic: isPic!, isTreasurer: isTreasurer!)),
        ),
      ),
    );
  }
}
