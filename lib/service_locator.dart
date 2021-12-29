import 'package:kmp_pengurus_app/features/authentication/data/datasources/index.dart';
import 'package:kmp_pengurus_app/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:kmp_pengurus_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:kmp_pengurus_app/features/authentication/domain/usecases/get_all_to_cache_token_usecase.dart';
import 'package:kmp_pengurus_app/features/authentication/domain/usecases/index.dart';
import 'package:kmp_pengurus_app/features/authentication/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/data/datasources/cash_book_local_datasource.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/data/datasources/cash_book_remote_datasource.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/data/repositories/cash_book_repository_impl.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/domain/repositories/cash_book_repository.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/domain/usecases/cash_book_usecase.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/features/bendahara/deposit/data/datasources/Deposit_local_datasource.dart';
import 'package:kmp_pengurus_app/features/bendahara/deposit/data/datasources/deposit_remote_datasource.dart';
import 'package:kmp_pengurus_app/features/bendahara/deposit/data/repositories/deposit_repository_impl.dart';
import 'package:kmp_pengurus_app/features/bendahara/deposit/domain/repositories/deposit_repository.dart';
import 'package:kmp_pengurus_app/features/bendahara/deposit/domain/usecases/deposit_usecase.dart';
import 'package:kmp_pengurus_app/features/bendahara/deposit/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:kmp_pengurus_app/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:kmp_pengurus_app/features/dashboard/domain/usecases/dashboard_usecase.dart';
import 'package:kmp_pengurus_app/features/dues/data/datasources/dues_local_datasource.dart';
import 'package:kmp_pengurus_app/features/dues/data/datasources/dues_remote_datasource.dart';
import 'package:kmp_pengurus_app/features/dues/data/repositories/dues_repository_impl.dart';
import 'package:kmp_pengurus_app/features/dues/domain/repositories/dues_repository.dart';
import 'package:kmp_pengurus_app/features/dues/domain/usecases/dues_usecase.dart';
import 'package:kmp_pengurus_app/features/financial/data/datasources/financial_statement_local_datasource.dart';
import 'package:kmp_pengurus_app/features/financial/data/datasources/financial_statement_remote_datasource.dart';
import 'package:kmp_pengurus_app/features/financial/data/repositories/financial_statement_repository_impl.dart';
import 'package:kmp_pengurus_app/features/financial/domain/repositories/financial_statement_repository.dart';
import 'package:kmp_pengurus_app/features/financial/domain/usecases/financial_statement_usecase.dart';
import 'package:kmp_pengurus_app/features/financial/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/data/datasources/caretaker_local_datasource.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/data/datasources/caretaker_remote_datasource.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/data/repositories/caretaker_repository_impl.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/domain/repositories/caretaker_repository.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/domain/usecases/caretaker_usecase.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/features/master/houses/data/datasources/house_local_datasource.dart';
import 'package:kmp_pengurus_app/features/master/houses/data/datasources/house_remote_datasource.dart';
import 'package:kmp_pengurus_app/features/master/houses/data/repositories/house_repository_impl.dart';
import 'package:kmp_pengurus_app/features/master/houses/domain/repositories/house_repository.dart';
import 'package:kmp_pengurus_app/features/master/houses/domain/usecases/house_usecase.dart';
import 'package:kmp_pengurus_app/features/master/houses/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/features/master/officers/data/datasources/officer_local_datasource.dart';
import 'package:kmp_pengurus_app/features/master/officers/data/datasources/officer_remote_datasource.dart';
import 'package:kmp_pengurus_app/features/master/officers/data/repositories/officers_repository_impl.dart';
import 'package:kmp_pengurus_app/features/master/officers/domain/repositories/officers_repository.dart';
import 'package:kmp_pengurus_app/features/master/officers/domain/usecases/officers_usecase.dart';
import 'package:kmp_pengurus_app/features/master/officers/presentation/bloc/officers_bloc.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/data/datasources/subscriptions_local_datasource.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/data/datasources/subscriptions_remote_datasource.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/data/repositories/subscriptions_repository_impl.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/domain/repositories/subscriptions_repository.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/domain/usecases/subscriptions_usecase.dart';
import 'package:kmp_pengurus_app/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:kmp_pengurus_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:kmp_pengurus_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:kmp_pengurus_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:kmp_pengurus_app/features/profile/domain/usecases/profile_usecase.dart';
import 'package:kmp_pengurus_app/features/profile/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/framework/blocs/messaging/index.dart';
import 'package:kmp_pengurus_app/framework/core/network/network_info.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';
import 'package:kmp_pengurus_app/framework/managers/http_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'features/dashboard/presentation/bloc/bloc.dart';
import 'features/dues/presentation/bloc/dues_bloc.dart';
import 'features/login/presentation/bloc/bloc.dart';
import 'features/master/category/data/datasources/category_local_datasource.dart';
import 'features/master/category/data/datasources/category_remote_datasource.dart';
import 'features/master/category/data/repositories/category_repository_impl.dart';
import 'features/master/category/domain/repositories/category_repository.dart';
import 'features/master/category/domain/usecases/category_usecase.dart';
import 'features/master/category/presentation/bloc/category_bloc.dart';
import 'features/master/subscriptions/presentation/bloc/subscriptions_bloc.dart';

GetIt serviceLocator = GetIt.instance;

Future<void> initDependencyInjection() async {
  // ************************************************ //
  //! Features - Authentication
  // Bloc
  // Authentication Bloc
  serviceLocator.registerFactory<AuthenticationBloc>(() => AuthenticationBloc(
        checkSignIn: serviceLocator(),
        getAllToCache: serviceLocator(),
        signOut: serviceLocator(),
        prefs: serviceLocator(),
        dbServices: serviceLocator(),
        persistToken: serviceLocator(),
      ));
  // Login Bloc
  serviceLocator.registerFactory<LoginBloc>(() => LoginBloc(
        prefs: serviceLocator(),
        signIn: serviceLocator(),
        dbServices: serviceLocator(),
      ));
  // Messaging Bloc
  serviceLocator.registerFactory<MessagingBloc>(() => MessagingBloc());

  // Use Cases
  serviceLocator
      .registerLazySingleton(() => CheckSigninUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => PersistTokenUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetAllToCacheUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => SigninUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => SignOutUseCase(serviceLocator()));

  // Repository
  serviceLocator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: serviceLocator(),
        localDataSource: serviceLocator(),
        networkInfo: serviceLocator(),
      ));

  // Data Sources
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
            httpManager: serviceLocator(),
            dbService: serviceLocator(),
          ));
  serviceLocator
      .registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(
            sharedPreferences: serviceLocator(),
            dbService: serviceLocator(),
          ));

  // ************************************************ //
  //! Features - Dashboard
  // Bloc
  // Dashboard Bloc
  serviceLocator.registerFactory<DashboardBloc>(() => DashboardBloc(
        dashboard: serviceLocator(),
        dashboardFromCache: serviceLocator(),
        dashboardChart: serviceLocator(),
        guestBook: serviceLocator(),
        allGuestBook: serviceLocator(),
        session: serviceLocator(),
      ));

  // Use Cases
  serviceLocator
      .registerLazySingleton(() => DashboardUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => DashboardFromCacheUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => DashboardChartUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => DashboardChartFromCache(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GuestBookUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => AllGuestBookUseCase(serviceLocator()));

  // Repository
  serviceLocator
      .registerLazySingleton<DashboardRepository>(() => DashboardRepositoryImpl(
            remoteDataSource: serviceLocator(),
            localDataSource: serviceLocator(),
            networkInfo: serviceLocator(),
          ));

  // Data Sources
  serviceLocator.registerLazySingleton<DashboardRemoteDataSource>(
      () => DashboardRemoteDataSourceImpl(
            httpManager: serviceLocator(),
            dbServices: serviceLocator(),
          ));
  serviceLocator.registerLazySingleton<DashboardLocalDataSource>(
      () => DashboardLocalDataSourceImpl(
            sharedPreferences: serviceLocator(),
            dbServices: serviceLocator(),
          ));
  // ************************************************ //
  //! Features - Subscriptions
  // Bloc
  // Subscriptions Bloc
  serviceLocator.registerFactory<SubscriptionsBloc>(() => SubscriptionsBloc(
      dbServices: serviceLocator(),
      subscriptions: serviceLocator(),
      subscriptionsFromCache: serviceLocator(),
      addSubscriptions: serviceLocator(),
      editSubscriptions: serviceLocator(),
      deleteSubscriptions: serviceLocator()));

  // Use Cases
  serviceLocator
      .registerLazySingleton(() => SubscriptionsUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => PostSubscriptionUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => EditSubscriptionUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => DeleteSubscriptionUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => SubscriptionsFromCacheUseCase(serviceLocator()));

  // Repository
  serviceLocator.registerLazySingleton<SubscriptionsRepository>(
      () => SubscriptionsRepositoryImpl(
            remoteDataSource: serviceLocator(),
            localDataSource: serviceLocator(),
            networkInfo: serviceLocator(),
          ));

  // Data Sources
  serviceLocator.registerLazySingleton<SubscriptionsRemoteDataSource>(
      () => SubscriptionsRemoteDataSourceImpl(
            httpManager: serviceLocator(),
            dbServices: serviceLocator(),
          ));
  serviceLocator.registerLazySingleton<SubscriptionsLocalDataSource>(
      () => SubscriptionsLocalDataSourceImpl(
            sharedPreferences: serviceLocator(),
            dbServices: serviceLocator(),
          ));

  // ************************************************ //
  //! Features - Officer
  // Bloc
  // Subscriptions Bloc
  serviceLocator.registerFactory<OfficersBloc>(() => OfficersBloc(
      dbServices: serviceLocator(),
      officers: serviceLocator(),
      addOfficers: serviceLocator(),
      editOfficers: serviceLocator(),
      deleteOfficers: serviceLocator()));

  // Use Cases
  serviceLocator.registerLazySingleton(() => OfficersUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => PostOfficerUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => EditOfficerUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => DeleteOfficerUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => OfficersFromCacheUseCase(serviceLocator()));

  // Repository
  serviceLocator
      .registerLazySingleton<OfficersRepository>(() => OfficersRepositoryImpl(
            remoteDataSource: serviceLocator(),
            localDataSource: serviceLocator(),
            networkInfo: serviceLocator(),
          ));

  // Data Sources
  serviceLocator.registerLazySingleton<OfficersRemoteDataSource>(
      () => OfficersRemoteDataSourceImpl(
            httpManager: serviceLocator(),
            dbServices: serviceLocator(),
          ));
  serviceLocator.registerLazySingleton<OfficersLocalDataSource>(
      () => OfficersLocalDataSourceImpl(
            sharedPreferences: serviceLocator(),
            dbServices: serviceLocator(),
          ));

  // ************************************************ //
  //! Features - Caretaker
  // Bloc
  // Subscriptions Bloc
  serviceLocator.registerFactory<CaretakerBloc>(() => CaretakerBloc(
        dbServices: serviceLocator(),
        caretaker: serviceLocator(),
        caretakerFromCache: serviceLocator(),
        addCaretaker: serviceLocator(),
        editCaretaker: serviceLocator(),
      ));

  // Use Cases
  serviceLocator
      .registerLazySingleton(() => CaretakerUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => PostCaretakerUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => EditCaretakerUseCase(serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => CaretakerFromCacheUseCase(serviceLocator()));

  // Repository
  serviceLocator
      .registerLazySingleton<CaretakerRepository>(() => CaretakerRepositoryImpl(
            remoteDataSource: serviceLocator(),
            localDataSource: serviceLocator(),
            networkInfo: serviceLocator(),
          ));

  // Data Sources
  serviceLocator.registerLazySingleton<CaretakerRemoteDataSource>(
      () => CaretakerRemoteDataSourceImpl(
            httpManager: serviceLocator(),
            dbServices: serviceLocator(),
          ));
  serviceLocator.registerLazySingleton<CaretakerLocalDataSource>(
      () => CaretakerLocalDataSourceImpl(
            sharedPreferences: serviceLocator(),
            dbServices: serviceLocator(),
          ));

  // ************************************************ //
  //! Features - Category
  // Bloc
  // Subscriptions Bloc
  serviceLocator.registerFactory<CategoryBloc>(() => CategoryBloc(
        dbServices: serviceLocator(),
        category: serviceLocator(),
        categoryFromCache: serviceLocator(),
        addCategory: serviceLocator(),
        deleteCategory: serviceLocator(),
        editCategory: serviceLocator(),
      ));

  // Use Cases
  serviceLocator.registerLazySingleton(() => CategoryUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => PostCategoryUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => EditCategoryUseCase(serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => CategoryFromCacheUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => DeleteCategoryUseCase(serviceLocator()));

  // Repository
  serviceLocator
      .registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(
            remoteDataSource: serviceLocator(),
            localDataSource: serviceLocator(),
            networkInfo: serviceLocator(),
          ));

  // Data Sources
  serviceLocator.registerLazySingleton<CategoryRemoteDataSource>(
      () => CategoryRemoteDataSourceImpl(
            httpManager: serviceLocator(),
            dbServices: serviceLocator(),
          ));
  serviceLocator.registerLazySingleton<CategoryLocalDataSource>(
      () => CategoryLocalDataSourceImpl(
            sharedPreferences: serviceLocator(),
            dbServices: serviceLocator(),
          ));

  // ************************************************ //
  //! Features - House
  // Bloc
  // Subscriptions Bloc
  serviceLocator.registerFactory<HousesBloc>(() => HousesBloc(
      dbServices: serviceLocator(),
      houses: serviceLocator(),
      housesFromCache: serviceLocator(),
      addHouses: serviceLocator(),
      editHouses: serviceLocator(),
      deleteHouses: serviceLocator()));

  // Use Cases
  serviceLocator.registerLazySingleton(() => HousesUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => PostHouseUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => EditHouseUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => DeleteHouseUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => HousesFromCacheUseCase(serviceLocator()));

  // Repository
  serviceLocator
      .registerLazySingleton<HousesRepository>(() => HousesRepositoryImpl(
            remoteDataSource: serviceLocator(),
            localDataSource: serviceLocator(),
            networkInfo: serviceLocator(),
          ));

  // Data Sources
  serviceLocator.registerLazySingleton<HouseRemoteDataSource>(
      () => HouseRemoteDataSourceImpl(
            httpManager: serviceLocator(),
            dbServices: serviceLocator(),
          ));
  serviceLocator.registerLazySingleton<HouseLocalDataSource>(
      () => HouseLocalDataSourceImpl(
            sharedPreferences: serviceLocator(),
            dbServices: serviceLocator(),
          ));

  // ************************************************ //
  //! Features - Dues
  // Bloc
  // Dues Bloc
  serviceLocator.registerFactory<DuesBloc>(() => DuesBloc(
      duesFromCache: serviceLocator(),
      getDataHouses: serviceLocator(),
      getListHouse: serviceLocator(),
      houseList: serviceLocator(),
      addDues: serviceLocator()));

  // Use Cases
  serviceLocator.registerLazySingleton(() => PostDuesUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => DuesFromCacheUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetMonthYearUsecase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => LoadHouseListUsecase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => ListHousesUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => ListHousesFromCacheUseCase(serviceLocator()));

  // Repository
  serviceLocator.registerLazySingleton<DuesRepository>(() => DuesRepositoryImpl(
        remoteDataSource: serviceLocator(),
        localDataSource: serviceLocator(),
        networkInfo: serviceLocator(),
      ));

  // Data Sources
  serviceLocator.registerLazySingleton<DuesRemoteDataSource>(
      () => DuesRemoteDataSourceImpl(
            httpManager: serviceLocator(),
            dbServices: serviceLocator(),
          ));
  serviceLocator
      .registerLazySingleton<DuesLocalDataSource>(() => DuesLocalDataSourceImpl(
            sharedPreferences: serviceLocator(),
            dbServices: serviceLocator(),
          ));

  // ************************************************ //
  //! Features - Cash Book
  // Bloc
  // CashBook Bloc
  serviceLocator.registerFactory<CashBookBloc>(() => CashBookBloc(
        cashBook: serviceLocator(),
        cashBookFromCache: serviceLocator(),
        addCashBook: serviceLocator(),
        category: serviceLocator(),
        categoryFromCache: serviceLocator(),
      ));

  // Use Cases
  serviceLocator.registerLazySingleton(() => CashBookUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => PostCashBookUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => CashBookFromCacheUseCase(serviceLocator()));

  // Repository
  serviceLocator.registerLazySingleton<CashBookRepository>(() =>
      CashBookRepositoryImpl(
          remoteDataSource: serviceLocator(),
          localDataSource: serviceLocator(),
          networkInfo: serviceLocator()));

  // Data Sources
  serviceLocator.registerLazySingleton<CashBookRemoteDataSource>(
      () => CashBookRemoteDataSourceImpl(
            httpManager: serviceLocator(),
            dbServices: serviceLocator(),
          ));
  serviceLocator.registerLazySingleton<CashBookLocalDataSource>(
      () => CashBookLocalDataSourceImpl(
            sharedPreferences: serviceLocator(),
            dbServices: serviceLocator(),
          ));

  // ************************************************ //

  // ************************************************ //
  //! Features - Deposit
  // Bloc
  // Deposit Bloc
  serviceLocator.registerFactory<DepositBloc>(() => DepositBloc(
        dbServices: serviceLocator(),
        deposit: serviceLocator(),
        // depositFromCache: serviceLocator(),
        addDeposit: serviceLocator(),
      ));

  // Use Cases
  serviceLocator.registerLazySingleton(() => DepositUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => PostDepositUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => DepositFromCacheUseCase(serviceLocator()));

  // Repository
  serviceLocator.registerLazySingleton<DepositRepository>(() =>
      DepositRepositoryImpl(
          remoteDataSource: serviceLocator(),
          localDataSource: serviceLocator(),
          networkInfo: serviceLocator()));

  // Data Sources
  serviceLocator.registerLazySingleton<DepositRemoteDataSource>(
      () => DepositRemoteDataSourceImpl(
            httpManager: serviceLocator(),
            dbServices: serviceLocator(),
          ));
  serviceLocator.registerLazySingleton<DepositLocalDataSource>(
      () => DepositLocalDataSourceImpl(
            sharedPreferences: serviceLocator(),
            dbServices: serviceLocator(),
          ));

  // ************************************************ //

  //! Features - Profile
  //Profile
  serviceLocator.registerFactory(() => ProfileBloc(
        profile: serviceLocator(),
        editProfile: serviceLocator(),
        dbServices: serviceLocator(),
        changePassword: serviceLocator(),
      ));

  // Use Cases
  serviceLocator.registerLazySingleton(() => ProfileUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => ChangePasswordUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => EditProfileUseCase(serviceLocator()));

  // // Repository
  serviceLocator
      .registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(
            remoteDataSource: serviceLocator(),
            localDataSource: serviceLocator(),
            networkInfo: serviceLocator(),
          ));

  // // Data Sources
  serviceLocator.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(
            httpManager: serviceLocator(),
            dbServices: serviceLocator(),
          ));
  serviceLocator.registerLazySingleton<ProfileLocalDataSource>(
      () => ProfileLocalDataSourceImpl(
            sharedPreferences: serviceLocator(),
            dbServices: serviceLocator(),
          ));

  // ************************************************ //

  //! Features - Financial Statement
  // Bloc
  serviceLocator
      .registerFactory<FinancialStatementBloc>(() => FinancialStatementBloc(
            cashBookFinancial: serviceLocator(),
            cashBookFinancialFromCache: serviceLocator(),
            pdfReport: serviceLocator(),
          ));

  // Use Cases
  serviceLocator
      .registerLazySingleton(() => FinancialStatementUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => PdfReportUseCase(serviceLocator()));

  serviceLocator.registerLazySingleton(
      () => FinancialStatementFromCacheUseCase(serviceLocator()));

  // Repository
  serviceLocator.registerLazySingleton<FinancialStatementRepository>(() =>
      FinancialStatementRepositoryImpl(
          remoteDataSource: serviceLocator(),
          localDataSource: serviceLocator(),
          networkInfo: serviceLocator()));

  // Data Sources
  serviceLocator.registerLazySingleton<FinancialStatementRemoteDataSource>(
      () => FinancialStatementRemoteDataSourceImpl(
            httpManager: serviceLocator(),
            dbServices: serviceLocator(),
          ));
  serviceLocator.registerLazySingleton<FinancialStatementLocalDataSource>(
      () => FinancialStatementLocalDataSourceImpl(
            sharedPreferences: serviceLocator(),
            dbServices: serviceLocator(),
          ));

  // ************************************************ //

  //! Core
  serviceLocator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(serviceLocator()));
  serviceLocator.registerLazySingleton(() => InternetConnectionChecker());

  //! Managers
  final sharedPreferences = await SharedPreferences.getInstance();
  //
  serviceLocator.registerSingleton<SharedPreferences>(sharedPreferences);
  serviceLocator.registerSingleton<HiveDbServices>(HiveDbServices());
  serviceLocator.registerLazySingleton<HttpManager>(() => AppHttpManager());
  //
}
