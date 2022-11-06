import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/view_model/bloc/pharmacy_product/pharmacy_cubit.dart';

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
            title: Text("GeeksForGeeks"),
        bottom: TabBar(
        tabs: [
        Tab(text: "Pending"),
        Tab(text: "Accepted"),
          Tab(text: "Rejected"),
        ],
        ),
        ),
          body:  TabBarView(children:
                  [
                    Pending(data: 'pending'),
                    Pending(data: 'Accepted'),
                    Pending(data: 'Rejected'),
                  ],),
                
              
        ));
      },
    );
  }
}
class Pending extends StatefulWidget {
  String data;
   Pending({Key? key,required this.data}) : super(key: key);

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
        return (state is GetProductSuccsseful)? const Center(child: CircularProgressIndicator(),):ListView.separated(
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
                            Text('Address : ${PharmacyCubit.get(context)
                                .orders[index]
                                .address}'),
                            Text('Total Price: ${PharmacyCubit.get(context)
                                .orders[index]
                                .totalPrice}'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              PharmacyCubit.get(context).acceptOrder(orderID: PharmacyCubit.get(context).orders[index].id, productID: PharmacyCubit.get(context).orders[index].productID,);
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
}

Widget accepted({required BuildContext context}){
  return BlocConsumer<PharmacyCubit, PharmacyState>(
    listener: (context, state) {
      // TODO: implement listener
    },
    builder: (context, state) {
      return (state is GetProductSuccsseful)? Center(child: CircularProgressIndicator(),):ListView.separated(
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
                          Text('Address : ${PharmacyCubit.get(context)
                              .orders[index]
                              .address}'),
                          Text('Total Price: ${PharmacyCubit.get(context)
                              .orders[index]
                              .totalPrice}'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            PharmacyCubit.get(context).acceptOrder(orderID: PharmacyCubit.get(context).orders[index].id, productID: PharmacyCubit.get(context).orders[index].productID,);
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
Widget rejected({required BuildContext context}){
  return BlocConsumer<PharmacyCubit, PharmacyState>(
    listener: (context, state) {
      // TODO: implement listener
    },
    builder: (context, state) {
      return (state is GetProductSuccsseful)? Center(child: CircularProgressIndicator(),):ListView.separated(
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
                          Text('Address : ${PharmacyCubit.get(context)
                              .orders[index]
                              .address}'),
                          Text('Total Price: ${PharmacyCubit.get(context)
                              .orders[index]
                              .totalPrice}'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            PharmacyCubit.get(context).acceptOrder(orderID: PharmacyCubit.get(context).orders[index].id, productID: PharmacyCubit.get(context).orders[index].productID,);
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

