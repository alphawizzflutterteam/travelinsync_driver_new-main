

import 'package:flutter/material.dart';
import 'package:taxi_schedule_driver/new_model/ride_model.dart';

import 'package:taxi_schedule_driver/new_utils/entry_field.dart';
import 'package:taxi_schedule_driver/new_model/address_model.dart';
import 'package:taxi_schedule_driver/new_model/schedule_model.dart';
import 'package:taxi_schedule_driver/new_utils/ApiBaseHelper.dart';
import 'package:taxi_schedule_driver/new_utils/colors.dart';
import 'package:taxi_schedule_driver/new_utils/common_ui.dart';
import 'package:taxi_schedule_driver/new_utils/constant.dart';
import 'package:taxi_schedule_driver/new_utils/ui.dart';

class StartOTPScreen extends StatefulWidget {

  final RideModel model;
  const StartOTPScreen({super.key,required this.model});

  @override
  State<StartOTPScreen> createState() => _StartOTPScreenState();
}

class _StartOTPScreenState extends State<StartOTPScreen> {
  TextEditingController otpCon = TextEditingController();
  AddressModel? pickAddress;
  bool loading = true, network = false;
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool loadingWeek = false;
  String pickTime = "";
  Future startOTPApi()async{
    network = await Common.checkInternet();
    if(network){
      Map param = {
        'driver_id':Constants.curUserId,
        'booking_id':widget.model.id,
        'otp':otpCon.text,
      };
      Map response = await apiBaseHelper.postAPICall(Uri.parse("${Constants.baseUrl}Authentication/start_ride"), param);
      setState(() {
        loadingWeek = false;
      });
      if(response['status']){
        Navigator.pop(context,true);
        UI.setSnackBar(response['message'], context,color: Colors.green);
      }else{
        UI.setSnackBar(response['message']??'Something went wrong', context);
      }
    }else{
      UI.setSnackBar("No Internet Connection", context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 10),
      title: Text(
        "Start Ride",
      ),
      content:  Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EntryField(
            keyboardType: TextInputType.phone,
            controller: otpCon,
            maxLength: 4,
            suffixIcon: IconButton(
              onPressed: null,
              icon: Icon(
                Icons.pin,
              ),
            ),
            hint: "Enter OTP",
          ),
          Text(
            "To begin the ride, kindly ask the customer for an OTP.",
            style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.red),
          ),
        ],
      ),
      actions: [
        UI.commonButton(
            title: "Cancel",
            loading: false,
            bgColor: MyColorName.secondColor,
            borderColor: MyColorName.secondColor,
            onPressed: (){
              Navigator.pop(context);
            }
        ),
        UI.commonButton(
            title: "Confirm",
            loading: loadingWeek,
            onPressed: (){
              if (otpCon.text == ""||otpCon.text.length!=4) {
                UI.setSnackBar(
                    "Please Enter Valid OTP",
                    context);
                return;
              }
              setState(() {
                loadingWeek = true;
              });
              startOTPApi();
            }
        ),
      ],
    );
  }
  Future<AddressModel?> callPickAddress() async {
    var result = await Navigator.pushNamed(
        context, Constants.manageAddressRoute,
        arguments: true);
    return result as AddressModel;
  }
}
