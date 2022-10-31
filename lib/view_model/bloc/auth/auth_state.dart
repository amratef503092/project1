part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}
// login state start
class LoginLoadingState extends AuthState{
  LoginLoadingState();
}
class LoginSuccessfulState extends AuthState{
  String message;
  String role;
  LoginSuccessfulState({required this.message,required this.role});
}
class LoginErrorState extends AuthState{
  String message;
  LoginErrorState(this.message);
}
// login state end

// start Register state
class RegisterLoadingState extends AuthState{
  RegisterLoadingState();
}
class RegisterSuccessfulState extends AuthState{
  String message;
  RegisterSuccessfulState(this.message);
}
class RegisterErrorState extends AuthState{
  String message;
  RegisterErrorState(this.message);
}
// start Register state
// start Register state
class GetUserDataLoadingState extends AuthState{
  GetUserDataLoadingState();
}
class GetUserDataSuccessfulState extends AuthState{
  String message;
  GetUserDataSuccessfulState(this.message);
}
class GetUserDataErrorState extends AuthState{
  String message;
  GetUserDataErrorState(this.message);
}
// start Register state
// start Register state
class UpdateDataLoadingState extends AuthState{
  UpdateDataLoadingState();
}
class UpdateDataSuccessfulState extends AuthState{
  String message;
  UpdateDataSuccessfulState(this.message);
}
class UpdateDataErrorState extends AuthState{
  String message;
  UpdateDataErrorState(this.message);
}
// start Register state