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
            .detailsModelPharmacyAdminApproved.isNotEmpty)?GridView.builder(
            gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(

              childAspectRatio: 1 / 1.23,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              crossAxisCount: 2,


            ),
          shrinkWrap: true,

          itemBuilder: (context, index) {

                  return Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 40.r,
                            backgroundImage: NetworkImage(
                              ApproveCubit.get(context)
                                  .detailsModelPharmacyAdminApproved[index]
                                  .photo.toString(),
                            ),
                          ),
                           SizedBox(
                            width: 10.h,
                          ),
                          SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  ApproveCubit.get(context)
                                      .detailsModelPharmacyAdminApproved[index]
                                      .name,
                                  style: const TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                Text(
                               ApproveCubit.get(context)
                                    .detailsModelPharmacyAdminApproved[index]
                                    .email,
                                  style: const TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ApproveCubit.get(context)
                                      .detailsModelPharmacyAdminApproved[index]
                                      .address,
                                  style: const TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),

                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff30CA00),
                                  fixedSize: Size(70.w, 30.h)
                                ),
                                  onPressed: (){

                                ApproveCubit.get(context).approvePharmacy(

                                  userID: ApproveCubit.get(context)
                                      .detailsModelPharmacyAdminApproved[index].id,
                                  index :index
                                );

                              }, child:  Text('Approve',style: TextStyle(color: Colors.white ,fontSize: 12.sp,fontWeight: FontWeight.bold),)),
                              SizedBox(width: 10.w,),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      fixedSize: Size(70.w, 30.h)

                                  ),

                                  onPressed: (){

                                    ApproveCubit.get(context).rejectPharmacy(

                                        userID: ApproveCubit.get(context)
                                            .detailsModelPharmacyAdminApproved[index].id,
                                        index :index
                                    );

                                  }, child:  Text('Reject',style: TextStyle(color: Colors.white ,fontSize: 12.sp,fontWeight: FontWeight.bold),)),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: ApproveCubit.get(context).detailsModelPharmacyAdminApproved.length,
              ):const Center(child: Text("No Pharmacy to Approve"),),
      );
    });
  }
}
