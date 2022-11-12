import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/model/pharmacy_model.dart';
import 'package:graduation_project/view_model/bloc/layout/layout__cubit.dart';
import 'package:graduation_project/view_model/bloc/layout/layout__cubit.dart';
import 'package:graduation_project/view_model/bloc/layout/layout__cubit.dart';
import 'package:graduation_project/view_model/bloc/layout/layout__cubit.dart';
import 'package:graduation_project/view_model/bloc/layout/layout__cubit.dart';
import 'package:graduation_project/view_model/bloc/layout/layout__cubit.dart';
import 'package:graduation_project/view_model/bloc/layout/layout__cubit.dart';
import 'package:graduation_project/view_model/bloc/layout/layout__cubit.dart';
import 'package:graduation_project/view_model/bloc/pharmacy_product/pharmacy_cubit.dart';

import 'MedicineDetailsScreen.dart';
import 'chat_screen.dart';

class PharmacyProduct extends StatefulWidget {
  PharmacyProduct({Key? key,}) : super(key: key);

  @override
  State<PharmacyProduct> createState() => _PharmacyProductState();
}

class _PharmacyProductState extends State<PharmacyProduct> {
  @override
  void initState() {
    // TODO: implement initState
    PharmacyCubit.get(context).getPharmacySpecificProduct(
        pharmacyID: LayoutCubit.get(context).pahrmacyModel!.id.toString());
    super.initState();
  }

  double? rating;

  @override
 Widget build(BuildContext context) {
    return BlocConsumer<PharmacyCubit, PharmacyState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = PharmacyCubit.get(context);
        print(cubit.productsModel.length);
        return Scaffold(
          backgroundColor: Color(0xffF2F3F7),
          appBar: AppBar(
            title: Text(LayoutCubit.get(context).pahrmacyModel!.name),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ChatUserScreen(
                          pahrmacyModel: LayoutCubit.get(context).pahrmacyModel,
                        );
                      },
                    ));
                  },
                  icon: Icon(
                    Icons.chat,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {
                    cubit
                        .getRatePharmacy(
                            pharmacyId: LayoutCubit.get(context).pahrmacyModel!.id.toString())
                        .then((value) {
                      cubit
                          .getUserRate(pharmacyId: LayoutCubit.get(context).pahrmacyModel!.id)
                          .then((value) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Text("Current Rate : ${cubit.currentRate}"),
                                  ],
                                ),
                                Text("User Rate : ${cubit.userRate}"),
                                SizedBox(
                                  height: 10.h,
                                ),
                                RatingBar.builder(
                                  initialRating: 3,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    setState(() {
                                      this.rating = rating;
                                    });
                                  },
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    PharmacyCubit.get(context)
                                        .postRateToPharmacy(
                                            pharmacyId:
                                                LayoutCubit.get(context).pahrmacyModel!.id,
                                            rate: rating!)
                                        .then((value) {
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: const Text("confirm")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("cancel")),
                            ],
                          ),
                        );
                      });
                    });
                  },
                  icon: Icon(
                    Icons.star,
                    color: Colors.white,
                  )),
            ],
          ),
          body: (state is GetProductLodaing)
              ? const Center(
                  child: Text('Pharmacy Product'),
                )
              : SizedBox(
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
                        itemCount: cubit.productsModel.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MedicineDetailsScreen(
                                            productModel:
                                                cubit.productsModel[index],
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
                                  Image.network(
                                    cubit.productsModel[index].image,
                                    width: 80.w,
                                    height: 168.h,
                                  ),
                                  Text(cubit.productsModel[index].title,
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  Text(
                                      "SAR ${cubit.productsModel[index].price}",
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  ElevatedButton.icon(
                                    icon: Icon(Icons.shopping_cart),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MedicineDetailsScreen(
                                                    productModel: cubit
                                                        .productsModel[index],
                                                  )));
                                    },
                                    label: const Text("BUY"),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xff30CA00)),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ),
        );
      },
    );
  }
}
