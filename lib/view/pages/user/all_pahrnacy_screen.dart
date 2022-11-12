import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/view/pages/user/layout_pharmacy_user.dart';
import 'package:graduation_project/view/pages/user/pharmacy_product.dart';

import '../../../view_model/bloc/layout/layout__cubit.dart';
import '../../../view_model/bloc/user_cubit/user_cubit.dart';

class AllPharmacyScreen extends StatefulWidget {
  const AllPharmacyScreen({Key? key}) : super(key: key);

  @override
  State<AllPharmacyScreen> createState() => _AllPharmacyScreenState();
}

class _AllPharmacyScreenState extends State<AllPharmacyScreen> {
  @override
  void initState() {
    // TODO: implement initState
    UserCubit.get(context).getPharmacy();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      buildWhen: (previous, current) {
        if (current is GetPharmacySuccessfulState) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        var cubit = UserCubit.get(context);
        return (state is GetPharmacySuccessfulState)
            ? SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15.w,
                        mainAxisSpacing: 15.h,
                        mainAxisExtent: 300.h,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cubit.pahrmacyModel.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            LayoutCubit.get(context).x(cubit.pahrmacyModel[index]);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LayOutUserPharmacy(
                                          pahrmacyModel:
                                              cubit.pahrmacyModel[index],
                                        )));

                          },
                          child: Container(
                            width: 514.w,
                            height: 540.h,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.r)),
                            child: Column(
                              children: [
                                SizedBox(height: 20,),
                                Image.network(
                                  cubit.pahrmacyModel[index].photo,
                                  width: 80.w,
                                  height: 168.h,
                                ),
                                SizedBox(height: 20,),
                                Text(cubit.pahrmacyModel[index].name,
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                SizedBox(height: 20,),
                                Text(cubit.pahrmacyModel[index].address,
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
