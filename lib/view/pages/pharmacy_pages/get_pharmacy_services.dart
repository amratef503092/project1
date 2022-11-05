import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/view_model/bloc/services/services_cubit.dart';

import 'edit_service.dart';

class GetPharmacyServices extends StatefulWidget {
  const GetPharmacyServices({Key? key}) : super(key: key);

  @override
  State<GetPharmacyServices> createState() => _GetPharmacyServicesState();
}

class _GetPharmacyServicesState extends State<GetPharmacyServices> {
  @override
  void initState() {
    context.read<ServicesCubit>().getServices();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pharmacy Services'),
        ),
        body: BlocConsumer<ServicesCubit, ServicesState>(
            listener: (context, state) {},
            builder: (context, state) {
              return (state is GetServiceLoading)
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      itemBuilder: (context, index) => Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Text("Title : ${ServicesCubit.get(context)
                                  .serviceModel[index]
                                  .title }",style: TextStyle(
                                fontSize: 20
                              ),)),
                          Expanded(
                              child: Text("price : ${ServicesCubit.get(context)
                                  .serviceModel[index]
                                  .cost.toString() }",style: TextStyle(
                                  fontSize: 20
                              ),)),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return EditService(index: index,);

                                    },));

                                  }, icon: Icon(Icons.edit ,color: Colors.blue,)),
                              IconButton(
                                  onPressed: () {
                                    ServicesCubit.get(context)
                                        .deleteService(id: ServicesCubit.get(context)
                                        .serviceModel[index]
                                        .id);
                                  }, icon: Icon(Icons.delete ,color: Colors.red,)),
                            ],
                          ),
                        ],
                      )),
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: ServicesCubit.get(context).serviceModel.length,
                    );
            }));
  }
}
