import 'dart:async';
import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_schedule_driver/new_model/ride_model.dart';
import 'package:taxi_schedule_driver/new_screen/complete_ride_dialog.dart';
import 'package:taxi_schedule_driver/new_screen/start_ride_dialog.dart';
import 'package:taxi_schedule_driver/new_utils/Demo_Localization.dart';
import 'package:taxi_schedule_driver/new_model/address_model.dart';

import 'package:taxi_schedule_driver/new_model/user_model.dart';

import 'package:taxi_schedule_driver/new_screen/drawer_screen.dart';
import 'package:intl/intl.dart';

import 'package:taxi_schedule_driver/new_utils/ApiBaseHelper.dart';
import 'package:taxi_schedule_driver/new_utils/booking_view.dart';
import 'package:taxi_schedule_driver/new_utils/colors.dart';
import 'package:taxi_schedule_driver/new_utils/common_ui.dart';
import 'package:taxi_schedule_driver/new_utils/constant.dart';
import 'package:taxi_schedule_driver/new_utils/firebase_msg.dart';
import 'package:taxi_schedule_driver/new_utils/location_details.dart';
import 'package:taxi_schedule_driver/new_utils/ui.dart';


String name = "", loginType = "";

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen>
    with WidgetsBindingObserver {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    registerToken();
    getProfile();
    getSchedule();
    GetLocation location = GetLocation((result) {
      if (mounted) {
        setState(() {
          //var first = result.first;
        //  address = '${first.name},${first.subLocality},${first.locality},${first.country}';
          latitude = latitudeFirst;
          longitude = longitudeFirst;
          if (googleMapController != null) {
            googleMapController!.moveCamera(
                CameraUpdate.newLatLng(LatLng(latitude, longitude)));
          }
          //pickupCon.text = address;
          // pickupCityCon.text = result.first.locality;
          //  print(pickupCityCon.text);
        });
        updateDriverLatLng();
      }
    });
    location.getLoc();
  }
  Future updateDriverLatLng()async{
    print("driverLatLngUpdating");
    Map data = {
      "driver_id": Constants.curUserId.toString(),
      "heading": heading.toString(),
      "speed": speed.toString(),
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
    };
    Map response = await apiBase.postAPICall(
        Uri.parse("${Constants.baseUrl}Authentication/update_driver_tracking"), data);
    if (response['status']) {
    } else {}
  }
  bool background = false;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (background) {
          background = false;

          getSchedule();
          print("app in resumed from background");
        }
        //you can add your codes here
        break;
      case AppLifecycleState.inactive:
        background = true;
        print("app is in inactive state");
        break;
      case AppLifecycleState.paused:
        background = true;
        print("app is in paused state");
        break;
      case AppLifecycleState.detached:
        background = true;
        print("app has been removed");
        break;
      case AppLifecycleState.hidden:
        background = true;
        print("app has been hidden");
        // TODO: Handle this case.
        break;
    }
  }
  registerToken() async {
    String? deviceToken = await FireBaseMessagingService(context).setDeviceToken();
    Map data = {
      "user_id": Constants.curUserId.toString(),
      "device_id": deviceToken.toString(),
    };
    Map response = await apiBase.postAPICall(
        Uri.parse("${Constants.baseUrl}Authentication/update_Fcm_token_driver"), data);
    if (response['status']) {
    } else {}
  }
  ApiBaseHelper apiBase = ApiBaseHelper();
  bool loading = false;
  Future<void> getProfile() async {
    try {
      setState(() {
        loading = true;
      });
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      Map params = {
        "user_id": Constants.curUserId.toString(),
        "device_info": androidInfo.id.toString(),
      };
      Map response = await apiBase.postAPICall(
          Uri.parse("${Constants.baseUrl}Authentication/get_profile_driver"), params);
      if (response['status'] && response["data"] != null) {
        Constants.imageBaseUrl = response['image_path'].toString();
        Constants.userModel = UserModel.fromJson(response['data']);

        log('${response['data']}');
        setState(() {
          if (Constants.userModel != null) {
            Constants.userName = Constants.userModel!.username ?? '';
            Constants.userProfile = Constants.userModel!.userImage ?? '';
          }
        });
        print("IMAGE========" + Constants.imageBaseUrl.toString());
      } else {
        UI.setSnackBar(response['message'], context);
        // App.localStorage.clear();
        // Common.logoutApi();
        // Navigator.pushNamedAndRemoveUntil(context, Constants.loginRoute, (route) => false);
      }
    } on TimeoutException catch (_) {
      UI.setSnackBar(getTranslated(context, "WRONG")!, context);
      setState(() {
        loading = false;
      });
    }
  }

  AddressModel? pickAddress;
  AddressModel? dropAddress;
  TextEditingController pickupCon = TextEditingController();
  TextEditingController dropCon = TextEditingController();
  TextEditingController pickupTimeCon = TextEditingController();
  TextEditingController dropTimeCon = TextEditingController();
  TextEditingController rideStartCon = TextEditingController();
  String pickTime = "", dropTime = "";
  String initialRoute = Constants.homeRoute;
  GoogleMapController? googleMapController;
  @override
  Widget build(BuildContext context) {
    CameraPosition initialLocation = CameraPosition(
      zoom: 15,
      bearing: 30,
      tilt: 40,
      target: LatLng(20.5937, 78.9629),
    );
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: MyColorName.mainColor,
          leading: IconButton(
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            },
            icon: Icon(
              Icons.menu,
            ),
          ),
          title: Text(Constants.userName),
          actions: [

            UI.commonIconButton(
              message: "Notifications",
              iconData: Icons.notifications_active,
              onPressed: () {
                Navigator.pushNamed(context, Constants.notificationRoute);
              },
            ),
          ],
        ),
        drawer: Drawer(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  //  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(60))),
          child: DrawerScreen(
            onResult: (result) async {
              if (result != null) {
                if (result == 1) {
                  var data = await Navigator.pushNamed(
                      context, Constants.profileRoute);
                  if (data != null) {
                    getProfile();
                  }
                } else if (result == 5) {
                  Navigator.pushNamed(context, Constants.privacyRoute);
                } else if (result == 6) {
                  Navigator.pushNamed(context, Constants.termsRoute);
                } else if (result == 7) {
                  Navigator.pushNamed(context, Constants.faqRoute);
                }  else if (result == 2) {
                  Navigator.pushNamed(context, Constants.rideHistoryRoute);
                }else if (result == 0) {
                  Navigator.pop(context);
                  setState(() {
                    loading = true;
                  });
                  getSchedule();
                }
              }
            },
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  loading = true;
                });
                await getProfile();
                await getSchedule();
              },
              child: Container(
                width: double.infinity,
                child: GoogleMap(
                  myLocationEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    googleMapController = controller;
                  },
                  compassEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  tiltGesturesEnabled: false,
                  mapType: MapType.normal,
                  initialCameraPosition: initialLocation,
                ),
              ),
            ),
            if (loading) CircularProgressIndicator(),
          ],
        ),
        bottomNavigationBar: rideList.isNotEmpty
            ? Container(
                height: rideList.length>1?Common.getHeight(60, context):null,
                padding: const EdgeInsets.all(10),
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Your Next Ride",
                        style:
                            Theme.of(context).textTheme.headlineLarge!.copyWith(
                                  color: MyColorName.mainColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14.0,
                                ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                          itemCount: rideList.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context,index){
                          RideModel model = rideList[index];
                        return Column(
                          children: [
                            BookingView(model: model),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Tooltip(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: MyColorName.mainColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  message:
                                  "Start Ride.",
                                  child: TextButton(
                                    onPressed: () async {
                                      if(rideList[index].status=="Started"){
                                        var result = await showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return CompleteRideScreen(
                                                model: rideList[index],
                                              );
                                            });
                                        if (result != null) {
                                          setState(() {
                                            loading = true;
                                          });
                                          getSchedule();
                                        }
                                      }else{
                                        var result = await showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return StartOTPScreen(
                                                model: rideList[index],
                                              );
                                            });
                                        if (result != null) {
                                          setState(() {
                                            loading = true;
                                          });
                                          getSchedule();
                                        }
                                      }
                                    },
                                    child: Text(
                                      rideList[index].status=="Started"?"Complete Ride":"Start Ride",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(
                                        color: MyColorName.mainColor,
                                        decoration:
                                        TextDecoration.underline,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ],
                        );
                      }),


                    ],
                  ),
                ),
              )
            : null,
      ),
    );
  }
  bool enableButton(String? time){
    if (time == null) {
      return true;
    }
    if (!time.contains(":")) {
      return true;
    }
    List<String> formatTime = time.split(":");
    DateTime firstTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        int.parse(formatTime[0]),
        int.parse(formatTime[1]));
    DateTime secondTime = DateTime.now();
    Common.debugPrintApp(firstTime.difference(secondTime).inMinutes);
    return firstTime.difference(secondTime).inMinutes>120;
  }
  String formatTime(String? time) {
    if (time == null) {
      return "";
    }
    if (!time.contains(":")) {
      return "";
    }
    List<String> formatTime = time.split(":");
    return DateFormat("hh:mm a").format(DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        int.parse(formatTime[0]),
        int.parse(formatTime[1])));
  }

  int selectedIndex = 0;
  Future<AddressModel?> callPickAddress() async {
    var result = await Navigator.pushNamed(
        context, Constants.manageAddressRoute,
        arguments: true);
    return result as AddressModel;
  }

  Future<DateTime?> selectDate(BuildContext context,
      {DateTime? startDate}) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050),
        keyboardType: TextInputType.none,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        builder: (BuildContext? context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: MyColorName.primaryLite,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
          );
        });

    return picked;
  }

  Future<TimeOfDay?> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext? context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: MyColorName.primaryLite,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: MediaQuery(
              data: MediaQuery.of(context!).copyWith(
                alwaysUse24HourFormat: true,
              ),
              child: child!,
            ),
          );
        });

    return picked;
  }

  bool loadingSchedule = false, network = false;
  List<RideModel> rideList = [];
  Future getSchedule() async {
    network = await Common.checkInternet();
    if (network) {
      Map param = {
        'user_id': Constants.curUserId,
        'status': "pending",
      };
      Map response = await apiBase.postAPICall(
          Uri.parse("${Constants.baseUrl}Authentication/get_driver_rides"), param);
      setState(() {
        loading = false;
        rideList.clear();
      });
      if (response['status'] && response['data'] != null) {
        for(var v in response['data']){
          rideList.add(RideModel.fromJson(v));
        }
      } else {
        UI.setSnackBar(response['message'] ?? 'Something went wrong', context);
      }
    } else {
      UI.setSnackBar("No Internet Connection", context);
    }
  }

  Future scheduleRide() async {
    network = await Common.checkInternet();
    if (network) {
      Map param = {
        'user_id': Constants.curUserId,
        'pickup_address': pickAddress!.id ?? '',
        'drop_address': dropAddress!.id ?? '',
        'pickup_time': pickTime.toString(),
        'drop_time': dropTime.toString(),
        'start_date': rideStartCon.text.toString(),
      };
      Map response = await apiBase.postAPICall(
          Uri.parse("${Constants.baseUrl}Authentication/create_schedule"),
          param);
      setState(() {
        loadingSchedule = false;
      });
      if (response['status']) {
        getSchedule();
        UI.setSnackBar(response['message'], context, color: Colors.green);
      } else {
        UI.setSnackBar(response['message'] ?? 'Something went wrong', context);
      }
    } else {
      UI.setSnackBar("No Internet Connection", context);
    }
  }
}
