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
  bool ban;
  LoginSuccessfulState({required this.message,required this.role , required this.ban});
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
//
class UploadImageStateSuccessful extends AuthState{
  String message;
  UploadImageStateSuccessful(this.message);
}
class UploadImageStateError extends AuthState{
  String message;
  UploadImageStateError(this.message);
}
class UploadImageStateLoading extends AuthState{
  String message;
  UploadImageStateLoading(this.message);
}
//end image state
// start get Admin
class GetAdminsStateSuccessful extends AuthState{
  String message;
  GetAdminsStateSuccessful(this.message);
}
class GetAdminsStateError extends AuthState{
  String message;
  GetAdminsStateError(this.message);
}
class GetAdminsStateLoading extends AuthState{
  String message;
  GetAdminsStateLoading(this.message);
}
// end admin
class SendMessageStateLoading extends AuthState{
  String message;
  SendMessageStateLoading(this.message);
}
class SendMessageStateError extends AuthState{
  String message;
  SendMessageStateError(this.message);
}
class SendMessageStateSuccessful extends AuthState{
  String message;
  SendMessageStateSuccessful(this.message);
}