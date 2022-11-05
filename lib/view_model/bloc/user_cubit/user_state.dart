part of 'user_cubit.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}
// getMedicine state start
class GetMedicineLoadingState extends UserState {}
class GetMedicineSuccessfulState extends UserState {}
class GetMedicineErrorState extends UserState {
  final String error;
  GetMedicineErrorState(this.error);
}
// getMedicine state end
// getPharmacy state start
class GetPharmacyLoadingState extends UserState {}
class GetPharmacySuccessfulState extends UserState {}
class GetPharmacyErrorState extends UserState {
  final String error;
  GetPharmacyErrorState(this.error);
}

