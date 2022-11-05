import 'package:flutter/material.dart';
class GetPharmacyServices extends StatefulWidget {
  const GetPharmacyServices({Key? key}) : super(key: key);

  @override
  State<GetPharmacyServices> createState() => _GetPharmacyServicesState();
}

class _GetPharmacyServicesState extends State<GetPharmacyServices> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Pharmacy Services'),
      ),
      body: Center(
        child: Text('Get Pharmacy Services'),
      ),
    );
  }
}
