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
      context.read<ApproveCubit>().getDataToApproved();
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
            ? const Text('Witting data')
            : ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    color: buttonColor,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              ApproveCubit.get(context)
                                  .pharmacyModel[index]
                                  .photo,
                            ),
                            radius: 50.r,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
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
                              Text(
                                ApproveCubit.get(context)
                                    .detailsModelPharmacyAdminApproved[index]
                                    .dis,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(children: [
                            TextButton(onPressed: (){}, child: Text('Approve')),
                            TextButton(onPressed: (){}, child: Text('Rejected')),

                          ],)
                        ],
                      ),
                    ),
                  );
                },
                itemCount: ApproveCubit.get(context).pharmacyModel.length,
              ),
      );
    });
  }
}
