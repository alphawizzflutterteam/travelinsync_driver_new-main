import 'dart:math';


import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_schedule_driver/new_utils/ApiBaseHelper.dart';
import 'package:taxi_schedule_driver/new_utils/constant.dart';
import 'package:taxi_schedule_driver/new_utils/toast_widget.dart';

class Common{
  static String mainDownloadPath = "";
  static String downloadPath = "";
  static const baseUrl = "https://backup.wadhwaniinfotech.com/";
  //static const baseUrl = "http://localhost/backup_app/";
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static final Random _rnd = Random();
  static String formatBytes(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (bytes > 0) ? (log(bytes) / log(1024)).floor() : 0;
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
  static String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  static void setSnackBar(String msg, BuildContext context1,
      {double right = 20.0,
        double bottom = 50.0,
        String title = "",
        Color color = Colors.red}) {
    var overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        right:  right,
        bottom:  bottom,
        top: bottom,
        //left: MediaQuery.of(context).size.width * 0.2,
        child: Align(
          alignment:  Alignment.topRight,
          child: SlideToast(
            onRemove: () {
              overlayEntry.remove();
            },
            title: title,
            message: msg,
            color: color,
          ),
        ),
      ),
    );
    Overlay.of(context1).insert(overlayEntry);
  }
  static double getHeight(double height, BuildContext context) {
    return (MediaQuery.of(context).size.height * height) / 100;
  }
  static String getString1(String? name) {
    String temp = "";
    if (name != null && name != "") {
      temp = name[0].toString().toUpperCase() +
          name.toString().substring(1).toLowerCase();
    } else {
      temp = "No Data";
    }
    return temp;
  }
  static Future<bool> checkInternet()async{
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      return true;
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      // I am connected to a ethernet network.
      return true;
    } else if (connectivityResult == ConnectivityResult.vpn) {
      // I am connected to a vpn network.
      // Note for iOS and macOS:
      // There is no separate network interface type for [vpn].
      // It returns [other] on any device (also simulator)
      return true;
    } else if (connectivityResult == ConnectivityResult.bluetooth) {
      // I am connected to a bluetooth.
      return true;
    } else if (connectivityResult == ConnectivityResult.other) {
      return true;
      // I am connected to a network which is not in the above mentioned networks.
    } else if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return false;
  }
  static double getWidth(double width, BuildContext context) {

    return (MediaQuery.of(context).size.width * width) / 100;
  }
  static debugPrintApp(val){
    if (kDebugMode) {
      print(val);
    }
  }
  static logoutApi()async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    Map data = {
      "user_id":Constants.curUserId,
      "device_id":androidInfo.id.toString(),
    };
    ApiBaseHelper().postAPICall(Uri.parse(baseUrl + "logout_user"), data).then((value){});
  }
}
class App {
  static late SharedPreferences localStorage;
  static Future init() async {
    localStorage = await SharedPreferences.getInstance();
  }
}
