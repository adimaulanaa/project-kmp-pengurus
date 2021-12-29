import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:kmp_pengurus_app/features/dashboard/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/features/dashboard/presentation/pages/guest_book_all.dart';
import 'package:kmp_pengurus_app/service_locator.dart';
import 'package:kmp_pengurus_app/theme/colors.dart';

class GuestBookPage extends StatefulWidget {

  GuestBookPage({Key? key}) : super(key: key);

  @override
  _GuestBookPageState createState() => _GuestBookPageState();
}

class _GuestBookPageState extends State<GuestBookPage> {

  @override
  void initState() {
    super.initState();
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
              create: (_) => serviceLocator.get<DashboardBloc>(),
            ),
          ],
          child: ProgressHUD(child: GuestBookScreen()),
        ),
      ),
    );
  }
}
