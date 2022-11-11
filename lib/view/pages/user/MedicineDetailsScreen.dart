import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/model/product_model.dart';
import 'package:graduation_project/view/components/custom_button.dart';
import 'package:graduation_project/view/components/custom_text_field.dart';
import 'package:graduation_project/view_model/bloc/user_cubit/user_cubit.dart';

class MedicineDetailsScreen extends StatefulWidget {
  MedicineDetailsScreen({Key? key, required this.productModel})
      : super(key: key);
  ProductModel productModel;

  @override
  State<MedicineDetailsScreen> createState() => _MedicineDetailsScreenState();
}

class _MedicineDetailsScreenState extends State<MedicineDetailsScreen> {
  int count = 1;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.productModel.title),

      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 200.h,
                width: double.infinity,
                child: Image(
                  image: NetworkImage(widget.productModel.image),
                  fit: BoxFit.cover,
                ),
              ),
               SizedBox(height: 40.h,),
              Text((widget.productModel.title), style:  TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30.sp,
              ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 10,),
              Text("SAR : ${(widget.productModel.price.toString())}",
                style:  TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24.sp
                ),),
              const SizedBox(height: 10,),
              Text("Description :",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24.sp

                ),),
              Text(" ${(widget.productModel.description)}",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    fontSize: 20.sp
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
              ),
              const SizedBox(height: 10,),

              Text("Available Stoke : ${(widget.productModel.quantity.toString())}",
                style:  TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    color: Colors.grey
                ),),
              SizedBox(height: 20.h,),
              Row(
                children: [
                  CircleAvatar(
                    radius:  30.r,
                    backgroundColor: Colors.blueAccent,
                    child: IconButton(onPressed: () {
                      if (count < widget.productModel.quantity) {
                        setState(() {
                          count++;
                        });
                      }
                    }, icon: Icon(Icons.add , color: Colors.white,)),
                  ),
                  SizedBox(width: 20.w,),
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: Color(0xffF8F8F8),
                    child: Text("$count"),
                  ),
                  SizedBox(width: 20.w,),
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: Colors.blueAccent,
                    child: IconButton(onPressed: () {
                      if (count == 0) {

                      } else {
                        setState(() {
                          count--;
                        });
                      }
                    }, icon: Text("-" , style: TextStyle(color: Colors.white, fontSize: 30.sp),)),
                  ),
                ],
              ),
              SizedBox(height: 20.h,),

              Form(
                key: formKey,
                child: CustomTextField(controller: controller, hint: 'EnterAddress', fieldValidator: (String ? value){
                  if(value!.isEmpty){
                    return 'Enter Address';
                  }
                  return null;

                },
                iconData: Icons.location_on_outlined,),
              ),
              SizedBox(height: 20.h,),

              BlocConsumer<UserCubit, UserState>(
                listener: (context, state) {
                if(state is BuyProductSuccessfulState){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('we received your order'),
                  ));
                  Navigator.pop(context);
                }
                  // TODO: implement listener
                },
                builder: (context, state) {
                  return (state is BuyProductLoadingState) ? const Center(
                    child: CircularProgressIndicator(),) : CustomButton(
                    widget: const Text("Buy"),
                    color: Color(0xff30CA00),
                    function: () {
                      if(formKey.currentState!.validate()){
                        UserCubit.get(context).buyProduct(
                            productModel: widget.productModel, quantity: count
                            ,address: controller.text,
                          title: widget.productModel.title
                        );
                      }

                    },
                    disable: true,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
