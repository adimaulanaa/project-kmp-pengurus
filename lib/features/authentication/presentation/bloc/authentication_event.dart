import 'package:kmp_pengurus_app/features/authentication/data/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class ShowLogin extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  const LoggedIn({
    required this.loggedInData,
  });

  final UserModel loggedInData;

  @override
  List<Object> get props => [loggedInData];

  @override
  String toString() => 'LoggedIn { loggedInData: $loggedInData }';
}

class LoggedOut extends AuthenticationEvent {}
