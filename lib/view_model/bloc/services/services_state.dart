part of 'services_cubit.dart';

@immutable
abstract class ServicesState {}

class ServicesInitial extends ServicesState {}
class GetServiceLoading extends ServicesState{}
class GetServiceSuccessful extends ServicesState{}
class GetServiceError extends ServicesState{}

