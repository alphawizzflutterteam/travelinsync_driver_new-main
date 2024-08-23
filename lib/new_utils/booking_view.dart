import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taxi_schedule_driver/new_model/ride_model.dart';
import 'package:taxi_schedule_driver/new_model/schedule_model.dart';
import 'package:taxi_schedule_driver/new_utils/colors.dart';
import 'package:taxi_schedule_driver/new_utils/common_ui.dart';
import 'package:taxi_schedule_driver/new_utils/constant.dart';
import 'package:taxi_schedule_driver/new_utils/ui.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingView extends StatelessWidget {
  final RideModel model;
  const BookingView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    print('${model.type}_dddd___');
    return Material(
      color: Colors.transparent,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: MyColorName.mainColor.withOpacity(0.1))),
        child: Column(
          children: [
            ListTile(
              tileColor: Colors.white,
              leading: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Trip ID",
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontSize: 10.0, color: MyColorName.secondColor),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${model.id}",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: MyColorName.secondColor),
                  ),
                ],
              ),
              trailing: UI.commonButton(
                  title: "${model.status}",
                  fontColor: Colors.white,
                  bgColor:
                      model.status == "Pending" || model.status == "Assigned"
                          ? Colors.orange
                          : model.status == "Started"
                              ? Colors.deepPurple
                              : model.status == "Completed"
                                  ? Colors.green
                                  : Colors.red,
                  borderColor: model.status == "Pending"
                      ? Colors.orange
                      : model.status == "Started"
                          ? Colors.deepPurple
                          : model.status == "Completed"
                              ? Colors.green
                              : Colors.red,
                  onPressed: null),
              title: Text(
                /*"${Common.getString1(model.type ?? '')} Ride"*/ '',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 16.0,
                    ),
              ),
              /*subtitle: Text(
                "Start Ride OTP: ${model.bookingOtp}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),*/
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: Text(
                    model.pickupAddress ?? '',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 12.0,
                        ),
                  ),
                ),
                UI.commonIconButton(
                    iconData: Icons.directions,
                    iconColor: MyColorName.secondColor,
                    message: "Direction of pickup",
                    onPressed: () {
                      String url =
                          "https://www.google.com/maps/dir/?api=1&origin=${latitude.toString()},${longitude.toString()}&destination=${model.latitude},${model.longitude}&travelmode=driving&dir_action=navigate";
                      launchUrl(Uri.parse(url));
                    }),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ),
                ),
                Expanded(
                  child: Text(
                    model.dropAddress ?? '',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 12.0,
                        ),
                  ),
                ),
                UI.commonIconButton(
                    iconData: Icons.directions,
                    iconColor: MyColorName.secondColor,
                    message: "Direction of pickup",
                    onPressed: () {
                      String url =
                          "https://www.google.com/maps/dir/?api=1&origin=${latitude.toString()},${longitude.toString()}&destination=${model.dropLatitude},${model.dropLongitude}&travelmode=driving&dir_action=navigate";
                      launchUrl(Uri.parse(url));
                    }),
              ],
            ),
            ListTile(
              tileColor: Colors.white,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    child: Image.network(
                      model.userImage ?? "",
                      fit: BoxFit.cover,
                    )),
              ),
              trailing: UI.commonIconButton(
                  iconData: Icons.call,
                  iconColor: MyColorName.secondColor,
                  message: "Call To Customer",
                  onPressed: () {
                    launchUrl(Uri.parse("tel://${model.usermobile}"));
                  }),
              title: Text(
                model.username ?? "",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              subtitle: Text(
                model.usermobile ?? "",
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Date: ${model.pickupDate}",
                      style:
                          Theme.of(context).textTheme.headlineLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 13.0,
                              ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Time: ${formatTime(model.pickupTime)}",
                      textAlign: TextAlign.end,
                      style:
                          Theme.of(context).textTheme.headlineLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 13.0,
                              ),
                    ),
                  ),
                ],
              ),
            ),
            if (model.remark != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Remark: ${model.remark}",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: MyColorName.secondColor,
                        fontSize: 12.0,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
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
}
