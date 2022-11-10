import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/view_model/bloc/pharmacy_product/pharmacy_cubit.dart';

import '../../components/custom_button.dart';

class ShowOrders extends StatefulWidget {
  const ShowOrders({Key? key}) : super(key: key);

  @override
  State<ShowOrders> createState() => _ShowOrdersState();
}

class _ShowOrdersState extends State<ShowOrders> {
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
    PharmacyCubit.get(context).getOrders(widget.data);
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
            : (PharmacyCubit.get(context).orders.isNotEmpty)
                ?  Padding(
          padding: const EdgeInsets.all(20),
          child: GridView.builder(
            gridDelegate:
            SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                crossAxisSpacing: 20,
                childAspectRatio:  (widget.data=="pending")?0.5.w :0.6.w,
                mainAxisSpacing: 20),
            itemCount: PharmacyCubit.get(context)
                .orders
                .length,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(2),
                width: 200.w,
                height: 300.h,

                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius:
                  BorderRadius.circular(10.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 200,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          image: DecorationImage(
                            image: NetworkImage(
                                PharmacyCubit.get(
                                    context)
                                    .productsOrder[
                                index]
                                    .image),
                            fit: BoxFit.cover,
                          )),
                    ),
                    SizedBox(height: 10.h,),
                    Text(
                     "Name : ${ PharmacyCubit.get(context).orders[index].title}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 24.sp , fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 10.h,),
                    Text(
                      "SAR : ${  PharmacyCubit.get(context).orders[index].totalPrice.toString()}",
                      style: TextStyle(
                          fontSize: 24.sp),
                    ),
                    SizedBox(height: 10.h,),
                    Text(
                      "quantity : ${  PharmacyCubit.get(context).orders[index].quantity.toString()}",
                      style: TextStyle(
                          fontSize: 24.sp),
                    ),
                    SizedBox(height: 10.h,),
                    SizedBox(height: 10.h,),
                    Text(
                      "address : ${  PharmacyCubit.get(context).orders[index].address.toString()}",
                      style: TextStyle(
                          fontSize: 24.sp),
                    ),
                    SizedBox(height: 10.h,),
                    (widget.data=="pending")?Row(
                      children: [

                        ElevatedButton(onPressed: ()
                        {
                          PharmacyCubit.get(context).acceptOrder(orderID: PharmacyCubit.get(context).orders[index].id, productID: PharmacyCubit.get(context).orders[index].productID);
                        }, child: const Text("Accept")),
                        SizedBox(width: 10.w,),
                        ElevatedButton(onPressed: () {
                          PharmacyCubit.get(context).reject(orderID: PharmacyCubit.get(context).orders[index].id, productID: PharmacyCubit.get(context).orders[index].productID);

                        }, child: Text("Reject")),
                      ],
                    ):SizedBox(),
                  ],
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
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    PharmacyCubit.get(context).acceptOrder(
                                      orderID: PharmacyCubit.get(context)
                                          .orders[index]
                                          .id,
                                      productID: PharmacyCubit.get(context)
                                          .orders[index]
                                          .productID,
                                    );
                                  },
                                  child: const Text('Accepted'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Reject'),
                                ),
                              ],
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
                          actions: [
                            TextButton(
                              onPressed: () {
                                PharmacyCubit.get(context).acceptOrder(
                                  orderID: PharmacyCubit.get(context)
                                      .orders[index]
                                      .id,
                                  productID: PharmacyCubit.get(context)
                                      .orders[index]
                                      .productID,
                                );
                              },
                              child: const Text('Accepted'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Reject'),
                            ),
                          ],
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
