import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/code/constants_value.dart';
import 'package:graduation_project/view/components/custom_button.dart';
import 'package:graduation_project/view_model/bloc/approve/approve_cubit.dart';

class ApproveScreen extends StatefulWidget {
  const ApproveScreen({Key? key}) : super(key: key);

  @override
  State<ApproveScreen> createState() => _ApproveScreenState();
}

class _ApproveScreenState extends State<ApproveScreen> {
  @override
  void initState() {
    // TODO: implement initState
    setState(() {

      ApproveCubit.get(context).getDataToApproved(
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApproveCubit, ApproveState>(listener: (context, state) {
      // TODO: implement listener
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Approve'),
        ),
        body: (state is GetDataToApprovedStateLoading)
            ? const Center(child: CircularProgressIndicator(),)
            : (  ApproveCubit.get(context)
            .pharmacyModel.isNotEmpty)?ListView.builder(
                itemBuilder: (context, index) {

                  return Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              ApproveCubit.get(context)
                                  .pharmacyModel[index]
                                  .photo.toString(),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: 200.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ApproveCubit.get(context)
                                      .pharmacyModel[index]
                                      .name,
                                  style: const TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                Text(
                               ApproveCubit.get(context)
                                    .pharmacyModel[index]
                                    .email,
                                  style: const TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),

                              ],
                            ),
                          ),
                          Column(children: [
                            TextButton(onPressed: (){

                              ApproveCubit.get(context).approvePharmacy(

                                userID: ApproveCubit.get(context)
                                    .detailsModelPharmacyAdminApproved[index].id,
                                index :index
                              );

                            }, child: const Text('Approve',style: TextStyle(color: Colors.green ,fontSize: 20),)),

                          ],)
                        ],
                      ),
                    ),
                  );
                },
                itemCount: ApproveCubit.get(context).pharmacyModel.length,
              ):const Center(child: Text("No Pharmacy to Approve"),),
      );
    });
  }
}
