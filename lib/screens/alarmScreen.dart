import 'package:alarmapp/constants.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../models/alarms.dart';

// ignore: must_be_immutable
class MyAlarmScreen extends StatefulWidget {
  Alarms myAlarm;
  int index;
  Function remakeState;
  MyAlarmScreen(this.myAlarm, this.index, this.remakeState, {super.key});

  @override
  State<MyAlarmScreen> createState() => _MyAlarmScreenState();
}

class _MyAlarmScreenState extends State<MyAlarmScreen> {
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

  double barValue = 0.0;
  late Timer _timer;
  @override
  Widget build(BuildContext context) {
    final double pageWidth = MediaQuery.of(context).size.width;
    final double pageHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: pageWidth,
        height: pageHeight,
        color: const Color.fromARGB(255, 21, 21, 21),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: pageHeight * 0.13),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 160,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          currentTimeFormat(TimeOfDay(
                              hour: widget.myAlarm.alarmHour,
                              minute: widget.myAlarm.alarmMin)),
                          style: const TextStyle(
                              color: fontColor,
                              // fontWeight: FontWeight.bold,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              fontFamily: "WorkSans"),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              dayPeriodFun(TimeOfDay(
                                      hour: widget.myAlarm.alarmHour,
                                      minute: widget.myAlarm.alarmMin)
                                  .period
                                  .toString()),
                              style: const TextStyle(
                                  color: fontColor,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: "TiltNeon"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(top: pageHeight * 0.25),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: pageWidth * 0.7,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(225, 17, 17, 17),
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                      child: Text(
                    widget.myAlarm.alarmTone,
                    style: const TextStyle(
                      color: fontColorDim,
                    ),
                  )),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: pageHeight * 0.35),
              child: const Align(
                alignment: Alignment.topCenter,
                child: Icon(
                  Icons.alarm,
                  color: fontColorDim,
                  size: 28,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: pageHeight * 0.06),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    myAlarms[widget.index].isEnable = 0;
                    widget.remakeState(-1);
                    timerSubscription.resume();
                    Navigator.of(context).pop();
                  },
                  onLongPress: () {
                    if (barValue < 1.0) {
                      setState(() {
                        _timer = Timer.periodic(
                            const Duration(milliseconds: 10), (timer) {
                          setState(() {
                            barValue = barValue + 0.01;
                          });
                        });
                      });
                    } else {
                      myAlarms[widget.index].isEnable = 0;
                      _timer.cancel();
                      widget.remakeState(-1);
                      timerSubscription.resume();
                      Navigator.of(context).pop();
                    }
                  },
                  onLongPressUp: () {
                    myAlarms[widget.index].isEnable = 0;
                    _timer.cancel();
                    widget.remakeState(-1);
                    timerSubscription.resume();
                    Navigator.of(context).pop();
                    barValue = 0.0;
                    setState(() {});
                  },
                  child: Stack(children: [
                    Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(225, 17, 17, 17),
                          border: Border.all(color: mainColor),
                          borderRadius: BorderRadius.circular(120)),
                      child: Stack(children: [
                        Center(
                            child: Text(
                          barValue < 1.0 ? "Snooze" : "Stopped",
                          style: const TextStyle(
                              color: fontColor,
                              fontSize: 20,
                              fontFamily: "TiltNeon"),
                        )),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                barValue < 1.0 ? "Hold To Stop" : " ",
                                style: const TextStyle(
                                    color: fontColorDim,
                                    fontSize: 12,
                                    fontFamily: "TiltNeon"),
                              )),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 110,
                      width: 110,
                      child: CircularProgressIndicator(
                        color: dangerColor,
                        strokeWidth: 2,
                        value: barValue,
                      ),
                    ),
                  ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
