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

// delete state start
class DeleteProductLoading extends PharmacyState {}
class DeleteProductSuccessful extends PharmacyState {
  final String message;
  DeleteProductSuccessful(this.message);
}
class DeleteProductError extends PharmacyState {
  final String message;
  DeleteProductError(this.message);
}
// delete state end

// get product
class GetOrderLoading extends PharmacyState {}
class GetOrderSuccessful extends PharmacyState {
  final String message;
  GetOrderSuccessful(this.message);
}
class GetOrderError extends PharmacyState {
  final String message;
  GetOrderError(this.message);
}
// delete product
class AcceptOrderLoading extends PharmacyState {}
class AcceptOrderSuccessful extends PharmacyState {
  final String message;
  AcceptOrderSuccessful(this.message);
}
class AcceptOrderError extends PharmacyState {
  final String message;
  AcceptOrderError(this.message);
}