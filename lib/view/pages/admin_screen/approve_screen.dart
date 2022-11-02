import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/view_model/bloc/auth/auth_cubit.dart';

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
      context.read<AuthCubit>().getDataToApproved();

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Approve'),
          ),
          body: (state is GetDataToApprovedStateSuccessful)
              ? SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: state is GetDataToApprovedStateSuccessfulEmpty
                          ? Center(
                        child: Text( AuthCubit.get(context).detailsModelPharmacyAdminApproved.length.toString()),
                      ):ListView.builder(itemBuilder: (context, index) {
                        return Column(children:
                        [
                          Text(AuthCubit.get(context).detailsModelPharmacyAdminApproved[index].address.toString()),
                        ],);
                      },itemCount: AuthCubit.get(context).detailsModelPharmacyAdminApproved.length,)
                    )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
    );
  }
}
