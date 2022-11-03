part of 'approve_cubit.dart';

@immutable
abstract class ApproveState {}

class ApproveInitial extends ApproveState {}
class GetDataToApprovedStateSuccessful extends ApproveState{
  String message;
  GetDataToApprovedStateSuccessful(this.message);
}
class GetDataToApprovedStateSuccessfulEmpty extends ApproveState{
  String message;
  GetDataToApprovedStateSuccessfulEmpty(this.message);
}
class GetDataToApprovedStateError extends ApproveState{
  String message;
  GetDataToApprovedStateError(this.message);
}
class GetDataToApprovedStateLoading extends ApproveState{
  String message;
  GetDataToApprovedStateLoading(this.message);
}

class GetMoreInfoPharmacyStateLoading extends ApproveState{

}
class GetMoreInfoPharmacyStateSuccessful extends ApproveState{

}
class GetMoreInfoPharmacyStateError extends ApproveState{}

class ApprovePharmacyStateLoading extends ApproveState{}
class ApprovePharmacyStateSuccessful extends ApproveState{}
class ApprovePharmacyStateError extends ApproveState{}

class UploadImageStateLoading extends ApproveState{}
class UploadImageStateSuccessful extends ApproveState{}
class pickImageGallaryStateSuccessful extends ApproveState{}
class pickImageCameraStateSuccessful extends ApproveState{}
class RemoveImageStateSuccessful extends ApproveState{}