part of 'order_cubit.dart';

@immutable
abstract class OrderState {}

class OrderInitial extends OrderState {}
class IncreaseState extends OrderState{}
class decrementState extends OrderState{}

