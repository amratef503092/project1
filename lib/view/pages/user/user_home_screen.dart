import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/view_model/bloc/auth/auth_cubit.dart';
import 'package:graduation_project/view_model/bloc/user_cubit/user_cubit.dart';

import 'MedicineDetailsScreen.dart';

class HomeUserScreen extends StatefulWidget {
  const HomeUserScreen({Key? key}) : super(key: key);

  @override
  State<HomeUserScreen> createState() => _HomeUserScreenState();
}

class _HomeUserScreenState extends State<HomeUserScreen> {
  @override
  void initState() {
    // TODO: implement initState

    AuthCubit.get(context).getUserData();


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {},
          builder: (context, state) {
            return (AuthCubit.get(context).userModel == null)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                  child: Column(
                      children: [
                        BlocBuilder<UserCubit, UserState>(
                          buildWhen: (previous, current) {
                            if(current is GetMedicineSuccessfulState){
                              return true;
                            }else{
                              return false;
                            }
                          },
                          builder: (context, state) {
                            var cubit = UserCubit.get(context);
                            return (state is GetMedicineSuccessfulState)
                                ? CarouselSlider.builder(
                                    options: CarouselOptions(
                                      height: 200.0,
                                      aspectRatio: 16 / 9,
                                      viewportFraction: 0.8,
                                      initialPage: 0,
                                      enableInfiniteScroll: true,
                                      reverse: false,
                                      autoPlay: true,
                                      autoPlayInterval:
                                          const Duration(seconds: 3),
                                      autoPlayAnimationDuration:
                                          const Duration(milliseconds: 800),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enlargeCenterPage: true,
                                      scrollDirection: Axis.horizontal,
                                    ),
                                    itemCount: cubit.productModel.length,
                                    itemBuilder: (BuildContext context,
                                            int itemIndex, int pageViewIndex) =>
                                        Container(
                                            child: Stack(
                                      children: [
                                        Image.network(
                                          cubit.productModel[itemIndex].image,
                                          fit: BoxFit.cover,
                                          width: 1000.0,
                                        ),
                                        Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              width: double.infinity,
                                              height: 30,
                                              color: Colors.black45,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Title : ${cubit.productModel[itemIndex].title}",
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w900),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                    "price : ${cubit.productModel[itemIndex].price}",
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w900),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    )),
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  );
                          },
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Pharmacy",
                            style: TextStyle(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        BlocBuilder<UserCubit, UserState>(
                          buildWhen: (previous, current) {
                            if(current is GetPharmacySuccessfulState){
                              return true;
                            }else{
                              return false;
                            }
                          },
                          builder: (context, state) {
                            var cubit = UserCubit.get(context);
                            return (state is GetPharmacySuccessfulState)
                                ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                                  child: SizedBox(
                                      height: 300.h,
                                      width: double.infinity,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) =>
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15.r)
                                              ),
                                                height: 200,
                                                width: 200,
                                                child: Stack(
                                                  children: [
                                                    Image.network(
                                                      cubit.pahrmacyModel[index].photo,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Align(
                                                        alignment: Alignment.bottomCenter,
                                                        child: Container(
                                                          width: double.infinity,
                                                          height: 30,
                                                          color: Colors.black45,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                "Title : ${cubit.pahrmacyModel[index].name}",
                                                                style: const TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 20,
                                                                    fontWeight:
                                                                    FontWeight.w900),
                                                              ),
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ],
                                                )),
                                        separatorBuilder: (context, index) =>
                                            SizedBox(
                                          width: 39.w,
                                        ),
                                        itemCount:  UserCubit.get(context).pahrmacyModel.length,
                                      ),
                                    ),
                                )
                                : Center(
                                    child: CircularProgressIndicator(),
                                  );
                          },
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        BlocBuilder<UserCubit, UserState>(builder: (context, state) {
                          return Text("Amr");
                        },),

                        BlocBuilder<UserCubit, UserState>(
                          buildWhen: (previous, current) {
                            if(current is GetMedicineSuccessfulState){
                              return true;
                            }else{
                              return false;
                            }
                          },
                          builder: (context, state) {
                            var cubit = UserCubit.get(context);
                            return (state is GetMedicineSuccessfulState)
                                ?  SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: GridView.builder(gridDelegate:  const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    crossAxisSpacing: 20,
                                    childAspectRatio: 3 / 4,
                                    mainAxisSpacing: 20),
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount:  cubit.productModel.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => MedicineDetailsScreen(productModel: cubit.productModel[index],)));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15.r)
                                          ),
                                          child: Stack(
                                            children: [
                                              Image.network(
                                                cubit.productModel[index].image,
                                                fit: BoxFit.cover,
                                              ),
                                              Align(
                                                  alignment: Alignment.bottomCenter,
                                                  child: Container(
                                                    width: double.infinity,
                                                    color: Colors.black45,
                                                    height: 90.h,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          "Title : ${cubit.productModel[index].title}",
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 20,
                                                              fontWeight:
                                                              FontWeight.w900),
                                                        ),
                                                        const SizedBox(
                                                          width: 20,
                                                        ),
                                                        Text(
                                                          "price : ${ cubit.productModel[index].price} ",
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 20,
                                                              fontWeight:
                                                              FontWeight.w900),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
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
                        ),

                      ],
                    ),
                );
          }),
    );
  }
}
