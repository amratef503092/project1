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
// update state start
class UpdateProductLodaing extends PharmacyState {}
class UpdateProductSuccsseful extends PharmacyState {
  final String message;
  UpdateProductSuccsseful(this.message);
}
class UpdateProductError extends PharmacyState {
  final String message;
  UpdateProductError(this.message);
}
class UploadImageLoadingState extends PharmacyState {}
class UploadImageSuccessfulState extends PharmacyState {
  final String message;
  UploadImageSuccessfulState(this.message);
}
class UploadImageErrorState extends PharmacyState {
  final String message;
  UploadImageErrorState(this.message);
}
// update state end