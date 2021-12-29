import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:kmp_pengurus_app/config/string_resources.dart';
import 'package:kmp_pengurus_app/env.dart';
import 'package:kmp_pengurus_app/features/home/presentation/pages/home_page.dart';
import 'package:kmp_pengurus_app/features/login/presentation/pages/login_page.dart';
import 'package:kmp_pengurus_app/features/walkthrough/presentation/pages/walkthrough_page.dart';
import 'package:kmp_pengurus_app/framework/core/network/network_info.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';
import 'package:kmp_pengurus_app/framework/widgets/loading_indicator.dart';
import 'package:kmp_pengurus_app/service_locator.dart';
import 'package:kmp_pengurus_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'features/authentication/presentation/bloc/bloc.dart';
import 'framework/blocs/messaging/index.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (Env().isInDebugMode) {
      print(event);
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (Env().isInDebugMode) {
      print(transition);
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (Env().isInDebugMode) {
      print(error);
    }
    super.onError(bloc, error, stackTrace);
  }
}

void main() async {
  await Hive.initFlutter();
  Hive.openBox(HiveDbServices.boxLoggedInUser);
  // Hive
  //* Multi regesiter adapter
  // ..registerAdapter(QuestionnaireDatumAdapter())
  //
  // ;

  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp();
  // check apakah aplikasi baru di install/reinstall
  final prefs = await SharedPreferences.getInstance();
  GlobalConfiguration().loadFromAsset("app_settings");
  await dotenv.load(fileName: ".env");

  //  load static environment wrapper
  Env();
  if (prefs.getBool('first_run') ?? true) {
    await Hive.deleteFromDisk();
    debugPrint("=====Aplikasi baru di install hapus local storage=====");
    prefs.setBool('first_run', false);
  }

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initDependencyInjection();

  Bloc.observer = SimpleBlocObserver();

  if (Env().value.isInDebugMode) {
    print('app: ${Env().value.appName}');
    print('API Base Url: ${Env().value.apiBaseUrl}');
    print("API Config Url: ${Env().apiConfigUrl}${Env().apiConfigPath}");
  }

  HttpOverrides.global = MyHttpOverrides();

  runZonedGuarded<Future<void>>(() async {
    if (Env().value.isInDebugMode) {
    } else {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }

    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (BuildContext context) =>
                serviceLocator.get<AuthenticationBloc>()..add(AppStarted()),
          ),
          BlocProvider<MessagingBloc>(
            create: (BuildContext context) =>
                serviceLocator.get<MessagingBloc>()..add(MessagingStarted()),
          ),
        ],
        child: App(),
      ),
    );
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class App extends StatefulWidget {
  App({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  StreamSubscription<InternetConnectionStatus> _connection =
      InternetConnectionChecker().onStatusChange.listen((event) {});

  @override
  void initState() {
    super.initState();
    bool isConnected = false;
    _connection =
        serviceLocator<NetworkInfo>().onInternetStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          isConnected = true;
          break;
        case InternetConnectionStatus.disconnected:
          isConnected = false;
          break;
      }

      BlocProvider.of<MessagingBloc>(context)
          .add(InternetConnectionChanged(connected: isConnected));
    });
  }

  @override
  void dispose() {
    _connection.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: StringResources.APLICATION_TITLE,
      theme: appTheme,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (Env().value.isInDebugMode) {
            print('state $state');
          }
          if (state is ViewWalkthrough) {
            return WalkthroughPage();
          } else if (state is ViewLogin) {
            return LoginPage();
          } else if (state is AuthenticationAuthenticated) {
            return HomePage();
          } else if (state is AuthenticationUnauthenticated) {
            return LoginPage();
          } else if (state is AuthenticationLoading) {
            return LoadingIndicator();
          }
          return LoadingIndicator();
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
