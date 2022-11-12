import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/view_model/bloc/pharmacy_product/pharmacy_cubit.dart';

import '../../components/custom_button.dart';

class ShowAllServiceOrder extends StatefulWidget {
  const ShowAllServiceOrder({Key? key}) : super(key: key);

  @override
  State<ShowAllServiceOrder> createState() => _ShowAllServiceOrderState();
}

class _ShowAllServiceOrderState extends State<ShowAllServiceOrder> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PharmacyCubit, PharmacyState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Orders"),
                bottom: const TabBar(
                  tabs: [
                    Tab(text: "Pending"),
                    Tab(text: "Accepted"),
                    Tab(text: "Rejected"),
                  ],
                ),
              ),
              body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Pending(data: 'pending'),
                  Pending(data: 'Accepted'),
                  Pending(data: 'Reject'),
                ],
              ),
            ));
      },
    );
  }
}

class Pending extends StatefulWidget {
  String data;

  Pending({Key? key, required this.data}) : super(key: key);

  @override
  State<Pending> createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  @override
  void initState() {
    // TODO: implement initState
    PharmacyCubit.get(context).getOrdersService(widget.data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PharmacyCubit, PharmacyState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return (state is GetOrderLoading)
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : (PharmacyCubit.get(context).services.isNotEmpty)
            ? Padding(
          padding: const EdgeInsets.all(20),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
              mainAxisExtent:
              (widget.data == 'pending') ? 450.h : 350.h,
            ),
            itemCount: PharmacyCubit.get(context).services.length,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        PharmacyCubit.get(context)
                            .services[index]
                            .title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w900),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "${PharmacyCubit.get(context).services[index].cost.toString()} SAR ",
                        style: TextStyle(fontSize: 24.sp),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),

                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "Address : ${PharmacyCubit.get(context).services[index].address.toString()}  ",
                        style: TextStyle(fontSize: 24.sp),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      (widget.data == 'pending')
                          ? Column(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                        children: [
                          CustomButton(
                            disable: true,
                            color: Colors.red,
                            radius: 0,
                            size: const Size(200, 20),
                            function: () {
                              PharmacyCubit.get(context).rejectService(
                                  index: index,
                                  orderID:
                                  PharmacyCubit.get(context)
                                      .services[index]
                                      .id,
                                  productID:
                                  PharmacyCubit.get(context)
                                      .services[index].serviceID);
                            },
                            widget: SizedBox(
                              height: 40.h,
                              width: 200,
                              child: const Center(
                                  child: Text("Delete")),
                            ),
                          ),
                          CustomButton(
                            disable: true,
                            radius: 0,
                            color: Colors.blueAccent,
                            size: const Size(200, 20),
                            function: () {
                              PharmacyCubit.get(context)
                                  .acceptOrderService(
                                  orderID:
                                  PharmacyCubit.get(
                                      context)
                                      .services[index]
                                      .id,
                                  productID:
                                  PharmacyCubit.get(
                                      context)
                                      .services[index]
                                      .serviceID,
                                  index: index);
                            },
                            widget: SizedBox(
                              height: 40.h,
                              width: 200.w,
                              child: Center(
                                  child: Text("Accepted")),
                            ),
                          )
                        ],
                      )
                          : SizedBox()
                    ],
                  ),
                ),
              );
            },
          ),
        )
            : Center(
          child: Text("No Data"),
        );
      },
    );
  }
}
// Expanded(
// child: ListView.separated(
// itemBuilder: (context, index) {
// return InkWell(
// onTap: () {

// child: ListTile(
// leading: Image(
// image: NetworkImage(
// PharmacyCubit.get(context).productsOrder[index].image),
// ),
// title: Text(
// "Title ${PharmacyCubit.get(context).productsOrder[index].title}"),
// subtitle: Text(
// "Price${PharmacyCubit.get(context).productsOrder[index].price}"),
// trailing: Text(
// 'Total Price: ${PharmacyCubit.get(context).orders[index].totalPrice}'),
// ),
// );
// },
// separatorBuilder: (context, index) {
// return const Divider();
// },
// itemCount: PharmacyCubit.get(context).orders.length),
// ),
Widget accepted({required BuildContext context}) {
  return BlocConsumer<PharmacyCubit, PharmacyState>(
    listener: (context, state) {
      // TODO: implement listener
    },
    builder: (context, state) {
      print(PharmacyCubit.get(context).orders.length);
      return (state is GetOrderLoading)
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : (PharmacyCubit.get(context).orders.isNotEmpty)
          ? ListView.separated(
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Accept Order'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              "Title ${PharmacyCubit.get(context).productsOrder[index].title}"),
                          Text(
                              'Address : ${PharmacyCubit.get(context).orders[index].address}'),
                          Text(
                              'Total Price: ${PharmacyCubit.get(context).orders[index].totalPrice}'),
                        ],
                      ),
                      actions: [],
                    );
                  },
                );
              },
              child: ListTile(
                leading: Image(
                  image: NetworkImage(PharmacyCubit.get(context)
                      .productsOrder[index]
                      .image),
                ),
                title: Text(
                    "Title ${PharmacyCubit.get(context).productsOrder[index].title}"),
                subtitle: Text("Price" +
                    PharmacyCubit.get(context)
                        .productsOrder[index]
                        .price
                        .toString()),
                trailing: Text('Total Price: ' +
                    PharmacyCubit.get(context)
                        .orders[index]
                        .totalPrice
                        .toString()),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: PharmacyCubit.get(context).orders.length)
          : Center(
        child: Text("No Accepted Order"),
      );
    },
  );
}

Widget rejected({required BuildContext context}) {
  return BlocConsumer<PharmacyCubit, PharmacyState>(
    listener: (context, state) {
      // TODO: implement listener
    },
    builder: (context, state) {
      return (state is GetProductSuccsseful)
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.separated(
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Accept Order'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              "Title ${PharmacyCubit.get(context).productsOrder[index].title}"),
                          Text(
                              'Address : ${PharmacyCubit.get(context).orders[index].address}'),
                          Text(
                              'Total Price: ${PharmacyCubit.get(context).orders[index].totalPrice}'),
                        ],
                      ),
                      actions: [],
                    );
                  },
                );
              },
              child: ListTile(
                leading: Image(
                  image: NetworkImage(PharmacyCubit.get(context)
                      .productsOrder[index]
                      .image),
                ),
                title: Text(
                    "Title ${PharmacyCubit.get(context).productsOrder[index].title}"),
                subtitle: Text("Price" +
                    PharmacyCubit.get(context)
                        .productsOrder[index]
                        .price
                        .toString()),
                trailing: Text('Total Price: ' +
                    PharmacyCubit.get(context)
                        .orders[index]
                        .totalPrice
                        .toString()),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: PharmacyCubit.get(context).orders.length);
    },
  );
}
