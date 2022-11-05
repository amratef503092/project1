import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../model/service_model.dart';

part 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  ServicesCubit() : super(ServicesInitial());
  List<ServiceModel> serviceModel = [];
  Future<void> getServices() async{

  }
}
