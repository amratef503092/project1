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
// delete product
class GetMessageLoading extends PharmacyState {}
class GetMessageSuccessful extends PharmacyState {
  final String message;
  GetMessageSuccessful(this.message);
}
class GetMessageError extends PharmacyState {
  final String message;
  GetMessageError(this.message);
}
// delete product
class GetUsersMessageLoading extends PharmacyState {}
class GetUsersMessageSuccessful extends PharmacyState {
  final String message;
  GetUsersMessageSuccessful(this.message);
}
class GetUsersMessageError extends PharmacyState {
  final String message;
  GetUsersMessageError(this.message);
}
// delete product
class PostRateLoading  extends PharmacyState {

}
class PostRateSuccessful extends PharmacyState {
  final String message;
  PostRateSuccessful(this.message);
}
class PostRateError extends PharmacyState {
  final String message;
  PostRateError(this.message);
}
class GetCurrentRateLoading extends PharmacyState {
  final String message;
  GetCurrentRateLoading(this.message);
}
class GetCurrentRateSuccessful extends PharmacyState {
  final String message;
  GetCurrentRateSuccessful(this.message);
}
class GetCurrentRateError extends PharmacyState {
  final String message;
  GetCurrentRateError(this.message);
}

class GetUserRateLoading extends PharmacyState {
  final String message;
  GetUserRateLoading(this.message);
}
class GetUserRateSuccessful extends PharmacyState {
  final String message;
  GetUserRateSuccessful(this.message);
}
class GetUserRateError extends PharmacyState {
  final String message;
  GetUserRateError(this.message);
}
class GetServiceSuccsseful extends PharmacyState {
  final String message;
  GetServiceSuccsseful(this.message);
}
class GetServiceLoading extends PharmacyState {
  final String message;
  GetServiceLoading(this.message);
}
class GetServiceError extends PharmacyState {
  final String message;
  GetServiceError(this.message);
}

class BuyServiceSuccessful extends PharmacyState {
  final String message;
  BuyServiceSuccessful(this.message);
}
class BuyServiceError extends PharmacyState {
  final String message;
  BuyServiceError(this.message);
}
class BuyServiceLoading extends PharmacyState {
  final String message;
  BuyServiceLoading(this.message);
}