import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:graduation_project/view_model/bloc/user_cubit/user_cubit.dart';

class ShowOrderPharmacyService extends StatefulWidget {
  const ShowOrderPharmacyService({Key? key}) : super(key: key);

  @override
  State<ShowOrderPharmacyService> createState() => _ShowOrderPharmacyServiceState();
}

class _ShowOrderPharmacyServiceState extends State<ShowOrderPharmacyService> {
  @override
  void initState() {
    // TODO: implement initState
    UserCubit.get(context).getMyServiceOrder();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = UserCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('My Order'),
          ),
          body: (state is GetMyProductLoadingState)
              ? const Center(
            child: CircularProgressIndicator(),
          )
              :(cubit.myServiceOrders.isNotEmpty)?ListView.builder(
            itemCount: cubit.myServiceOrders.length,
            itemBuilder: (context, index) {
              return InkWell(

                onTap: (){

                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("total price : ${cubit.myServiceOrders[index].cost}"),
                              Text("titile : ${cubit.myServiceOrders[index].title}"),
                            ],
                          ),
                          Text("order Status: ${cubit.myServiceOrders[index].status}"),

                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ):Center(child: Text("No Order"),),
        );
      },
    );
  }
}
