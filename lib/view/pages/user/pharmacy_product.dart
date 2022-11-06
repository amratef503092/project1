import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/model/pharmacy_model.dart';
import 'package:graduation_project/view_model/bloc/pharmacy_product/pharmacy_cubit.dart';

import 'MedicineDetailsScreen.dart';
import 'chat_screen.dart';

class PharmacyProduct extends StatefulWidget {
  PharmacyProduct({Key? key, required this.pahrmacyModel}) : super(key: key);
  PharmacyModel ? pahrmacyModel;

  @override
  State<PharmacyProduct> createState() => _PharmacyProductState();
}

class _PharmacyProductState extends State<PharmacyProduct> {
  @override
  void initState() {
    // TODO: implement initState
    PharmacyCubit.get(context).getPharmacySpecificProduct(pharmacyID: widget.pahrmacyModel!.id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PharmacyCubit, PharmacyState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = PharmacyCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.pahrmacyModel!.name),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return ChatUserScreen(pahrmacyModel: widget.pahrmacyModel,);
                    },));
                  },
                  icon: Icon(
                    Icons.chat,
                    color: Colors.white,
                  ))
            ],
          ),
          body: (state is GetProductLodaing)?const Center(
            child: Text('Pharmacy Product'),
          ):ListView.separated(
              itemBuilder: (context, index) => SizedBox(
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
                      itemCount:  cubit.productsModel.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MedicineDetailsScreen(productModel: cubit.productsModel[index],)));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r)
                            ),
                            child: Stack(
                              children: [
                                Image.network(
                                  cubit.productsModel[index].image,
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
                                            "Title : ${cubit.productsModel[index].title}",
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
                                            "price : ${ cubit.productsModel[index].price} ",
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
              ),
              separatorBuilder: (context, index) => Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
              itemCount: cubit.productsModel.length),
        );
      },
    );
  }
}
