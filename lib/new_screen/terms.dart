import 'dart:async';
import 'dart:convert';


import 'package:taxi_schedule_driver/new_screen/privacy_policy.dart';
import 'package:taxi_schedule_driver/new_utils/ApiBaseHelper.dart';
import 'package:taxi_schedule_driver/new_utils/Demo_Localization.dart';
import 'package:taxi_schedule_driver/new_utils/colors.dart';
import 'package:taxi_schedule_driver/new_utils/common_ui.dart';
import 'package:taxi_schedule_driver/new_utils/constant.dart';





import 'package:flutter/material.dart';




import 'package:http/http.dart' as http;
import 'package:taxi_schedule_driver/new_utils/ui.dart';




class Terms extends StatefulWidget {

  @override
  _TermsState createState() => _TermsState();

  const Terms();
}

class _TermsState extends State<Terms> {


  bool loading = true;
  @override
  void initState() {
    super.initState();
    getRules();
  }
  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  List<PrivacyModel> ruleList = [];
  getRules() async {
    await App.init();
    isNetwork = await Common.checkInternet();
    if (isNetwork) {
      try {
        Map data = {
          "user_id": Constants.curUserId,
        };
        var res = await http.get(Uri.parse(Constants.baseUrl + "Authentication/get_terms"));
        Map response = jsonDecode(res.body);
        print(response);
        print(response);
        setState(() {
          loading = false;
        });
        if (response['status']) {
          for(var v in response['data']){
            setState(() {
              ruleList.add(new PrivacyModel(v['id'], v['title']??"Terms & Conditions", v['description']));
            });
          }
        } else {}
      } on TimeoutException catch (_) {
        UI.setSnackBar(getTranslated(context, "WRONG")!, context);
      }
    } else {
      UI.setSnackBar(getTranslated(context, "NO_INTERNET")!, context);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MyColorName.mainColor,
        title: Text(
          getTranslated(context, "terms")??'Terms & Conditions',
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height:20),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: ruleList.length,
                      itemBuilder: (context,index){
                        return Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height:10),
                              Text(Common.getString1(ruleList[index].title),style: Theme.of(context).textTheme.titleMedium,),
                              SizedBox(height:10),
                              Text(Common.getString1(ruleList[index].description)),
                            ],
                          ),
                        );
                      }),
                ),
                SizedBox(
                  height: 80,
                )
              ],
            ),
          ),
          if (loading) CircularProgressIndicator(),
        ],
      ),
    );
  }
}
