import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      appBar: AppBar(
        title: Text(widget.productModel.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                child: Image(
                  image: NetworkImage(widget.productModel.image),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10,),
              Text("Title : ${(widget.productModel.title)}", style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 45
              ),),
              const SizedBox(height: 10,),
              const Divider(
                thickness: 2,
              ),
              Text("Description : ${(widget.productModel.description)}",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24
                ),),
              const SizedBox(height: 10,),
              Text("Price : ${(widget.productModel.price.toString())}",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24
                ),),
              Text("quantity : ${(widget.productModel.quantity.toString())}",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24
                ),),
              Row(
                children: [
                  IconButton(onPressed: () {
                    if (count < widget.productModel.quantity) {
                      setState(() {
                        count++;
                      });
                    }
                  }, icon: Icon(Icons.add)),
                  Container(
                    child: Text("$count"),
                  ),
                  IconButton(onPressed: () {
                    if (count == 0) {

                    } else {
                      setState(() {
                        count--;
                      });
                    }
                  }, icon: const Icon(Icons.minimize)),
                ],
              ),
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
                    function: () {
                      if(formKey.currentState!.validate()){
                        UserCubit.get(context).buyProduct(
                            productModel: widget.productModel, quantity: count
                            ,address: controller.text);
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
