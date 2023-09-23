import 'dart:async';

import 'package:alarmapp/constants.dart';
import 'package:alarmapp/models/alarms.dart';
import 'package:alarmapp/screens/alarmScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class MyCurrentTime extends StatefulWidget {
  Function remakeState;
  MyCurrentTime(this.remakeState, {super.key});

  @override
  State<MyCurrentTime> createState() => _MyCurrentTimeState();
}

class _MyCurrentTimeState extends State<MyCurrentTime> {
  TimeOfDay currentTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    // Create a timer stream that emits an event every minute.
    timerStream = Stream.periodic(const Duration(seconds: 1), (i) => i);

    // Subscribe to the timer stream and update the current time when an event is emitted.
    timerSubscription = timerStream.listen((_) {
      setState(() {
        currentTime = TimeOfDay.now();
      });
      for (int i = 0; i < myAlarms.length; i++) {
        if (myAlarms[i].isEditable == false &&
            myAlarms[i].isEnable == 1 &&
            currentTime.hour == myAlarms[i].alarmHour &&
            currentTime.minute == myAlarms[i].alarmMin) {
          timerSubscription.pause();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return MyAlarmScreen(myAlarms[i], i, widget.remakeState);
            },
          ));
        }
      }
    });
  }

  @override
  void dispose() {
    // Cancel the timer subscription when the screen is disposed.
    timerSubscription.cancel();
    super.dispose();
  }

  String currentTimeFormat(TimeOfDay time) {
    String returnHour = time.hour.toString();
    String returnMin = time.minute.toString();
    if (time.hour > 12) {
      returnHour = (time.hour - 12).toString();
    } else if (returnHour == "0") {
      returnHour = "12";
    }
    if (int.parse(returnHour) > 0 && int.parse(returnHour) < 10) {
      returnHour = "0$returnHour";
    } else {
      returnHour = returnHour;
    }
    if (time.minute < 10) {
      returnMin = "0${time.minute}";
    } else {
      returnMin = "${time.minute}";
    }
    return "$returnHour:$returnMin";
  }

  String dayPeriodFun(String timePeriod) {
    return "${timePeriod[timePeriod.length - 2]}${timePeriod[timePeriod.length - 1]}"
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final double pageWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(10),
      width: pageWidth,
      height: 120,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            DateFormat.yMMMEd().format(DateTime.now()),
            style: const TextStyle(
                color: fontColor,
                fontWeight: FontWeight.bold,
                fontFamily: "TiltNeon"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                currentTimeFormat(currentTime),
                style: const TextStyle(
                    color: fontColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 48,
                    fontFamily: "WorkSans"),
              ),
              const SizedBox(
                width: 5,
              ),
              Column(
                children: [
                  Text(
                    dayPeriodFun(currentTime.period.toString()),
                    style: const TextStyle(
                        color: fontColor,
                        // fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: "TiltNeon"),
                  ),
                  const SizedBox(
                    height: 7,
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
