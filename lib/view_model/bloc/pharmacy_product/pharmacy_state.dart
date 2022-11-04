part of 'pharmacy_cubit.dart';

@immutable
abstract class PharmacyState {}

class PharmacyInitial extends PharmacyState {}
class GetProductLodaing extends PharmacyState {}
class GetProductSuccsseful extends PharmacyState {
  final String message;
  GetProductSuccsseful(this.message);
}
class GetProductError extends PharmacyState {
  final String message;
  GetProductError(this.message);
}
