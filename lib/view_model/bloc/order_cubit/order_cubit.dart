import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../model/order_model_data.dart';
import '../../database/local/sql_lite.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());
  static OrderCubit get(context)=>BlocProvider.of<OrderCubit>(context);
  int ?  count ;
  List<OrderModelData>orderList = [];
  Future<List<OrderModelData>>getOrderData()async {
    SQLHelper.getCard().then((value) {
      value.forEach((element) {
        orderList.add(OrderModelData.fromMap(element));
      });
    });

    return orderList;
  }
  void increase(int count)
  {
    count =  count+1;
    print(count);
    emit(IncreaseState());
  }
  void decrement({required int count})
  {
    count++;
    emit(decrementState());
  }
}
