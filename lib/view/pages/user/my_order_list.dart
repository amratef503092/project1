import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/view_model/bloc/order_cubit/order_cubit.dart';

import '../../../view_model/bloc/edit_cubit/edit_cubit.dart';

class MyOrderList extends StatefulWidget {
  const MyOrderList({Key? key}) : super(key: key);

  @override
  State<MyOrderList> createState() => _MyOrderListState();
}

class _MyOrderListState extends State<MyOrderList> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Order List"),
        ),
        body: BlocConsumer<OrderCubit, OrderState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return FutureBuilder(
              future: OrderCubit.get(context).getOrderData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      print('Amr');
                      return Padding(
                        padding: EdgeInsets.all(14),
                        child: Card(
                          child: SizedBox(
                            height: 90,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: NetworkImage(snapshot
                                          .data![index].image
                                          .toString()),
                                      width: 100.w,
                                      height: 50.h,
                                      fit: BoxFit.cover,
                                    ),
                                    BlocProvider(
                                      create: (context) => EditCubit(),
                                      child: BlocConsumer<EditCubit, EditState>(
                                        listener: (context, state) {
                                          // TODO: implement listener
                                        },
                                        builder: (context, state) {
                                          var cubit = EditCubit.get(context);

                                          return Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    // cubit.decrement(
                                                    //     count: snapshot.data![index]
                                                    //         ['quantity']);

                                                    // SQLHelper.updateCardOrder(
                                                    //   quantity: quantity,
                                                    //   idProduct: snapshot.data![index]
                                                    //   ['idProduct'],
                                                    // );
                                                  },
                                                  icon:
                                                      const Icon(Icons.remove)),
                                              Text(snapshot
                                                  .data![index].quantity
                                                  .toString()),
                                              IconButton(
                                                  onPressed: () {
                                                    cubit.increase(snapshot
                                                        .data![index]
                                                        .quantity++);
                                                  },
                                                  icon: const Icon(Icons.add)),
                                            ],
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                Text(snapshot.data![index].title),
                                Text(snapshot.data![index].price.toString()),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: snapshot.data!.length,
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  return const CircularProgressIndicator();
                }
              },
            );
          },
        ),
      ),
    );
  }
}
