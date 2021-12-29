import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/presentation/pages/subscriptions_screen.dart';
import 'package:kmp_pengurus_app/service_locator.dart';
import 'package:kmp_pengurus_app/theme/colors.dart';

class SubscriptionsPage extends StatefulWidget {
  static const routeName = '/subscriptions';
  final bool? isPic;
  final bool? isTreasurer;

  SubscriptionsPage({Key? key, required this.isPic, required this.isTreasurer}) : super(key: key);

  @override
  _SubscriptionsPageState createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
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
          child: ProgressHUD(child: SubscriptionsScreen(isPic: isPic, isTreasurer: isTreasurer)),
        ),
      ),
    );
  }
}
