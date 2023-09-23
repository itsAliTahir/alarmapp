import 'package:alarmapp/constants.dart';
import 'package:alarmapp/models/alarms.dart';
import 'package:alarmapp/widgets/weekdaysSelectorSheet.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'RingtoneSelectorSheet.dart';
import '../helper/databasehelper.dart';

// ignore: must_be_immutable
class MyAddAlarm extends StatefulWidget {
  Function remakeState;
  MyAddAlarm(this.remakeState, {super.key});

  @override
  State<MyAddAlarm> createState() => _MyAddAlarmState();
}

class _MyAddAlarmState extends State<MyAddAlarm> {
  TimeOfDay tempTimeofDay = const TimeOfDay(hour: 6, minute: 0);
  double tempVolume = 70;
  String tempRingtone = AvailableTones[0].name;
  String tempWeekDay = "MTWTF--";
  void _presentTimePicker() {
    showTimePicker(
      context: context,
      builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.white,
              onBackground: const Color.fromARGB(255, 27, 27, 41),
            ),
            timePickerTheme: const TimePickerThemeData(
              helpTextStyle: TextStyle(color: Colors.white, fontSize: 11),
              backgroundColor: Color.fromARGB(255, 42, 42, 62),
            ),
            dialogBackgroundColor: const Color.fromARGB(255, 27, 27, 41),
            textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ), // color of button's letters
                    backgroundColor: const Color.fromARGB(
                        255, 27, 27, 41), // Background color
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Colors.transparent,
                            width: 1,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(50)))),
          ),
          child: child!),
      initialTime: tempTimeofDay,
    ).then((pickedTime) {
      if (pickedTime == null) {
        return;
      }
      setState(() {
        tempTimeofDay =
            TimeOfDay(hour: pickedTime.hour, minute: pickedTime.minute);
      });
    });
  }

  void editRingtuneFun(int index) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (_) {
          return Container(
            color: Colors.transparent,
            height: 200,
            child: MyEditRingtoneSheet(index, (int i) {
              tempRingtone = AvailableTones[i].name;
              widget.remakeState(-1);
              setState(() {});
            }),
          );
        });
  }

  void editWeekdaysFun() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (_) {
          return Container(
            color: Colors.transparent,
            height: 200,
            child:
                MyWeekDaysSelector(tempWeekDay, weekdays, widget.remakeState),
          );
        });
  }

  void weekdays(String data) {
    tempWeekDay = data;
    setState(() {});
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
    return Dialog(
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: 410,
        child: Container(
          margin: const EdgeInsets.only(top: 30),
          height: 350,
          width: MediaQuery.of(context).size.width - 10,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 42, 42, 62),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  _presentTimePicker();
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 40),
                  height: 60,
                  width: 180,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 27, 27, 41),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentTimeFormat(tempTimeofDay),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontFamily: "digital-7"),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Text(
                        dayPeriodFun(tempTimeofDay.period.toString()),
                        style: const TextStyle(
                            color: Colors.white, fontFamily: "TiltNeon"),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  editWeekdaysFun();
                },
                child: Container(
                  width: pageWidth - 103,
                  height: 40,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: tertiaryColor,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 80,
                        child: Text(
                          "Alarm Days: ",
                          style: TextStyle(
                              color: fontColor, fontFamily: "TiltNeon"),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 80,
                            width: pageWidth - 230,
                            child: Center(
                                child: tempWeekDay == 'MTWTFSS'
                                    ? const Text(
                                        "Everyday",
                                        style: TextStyle(
                                            color: fontColorDim,
                                            fontFamily: "TiltNeon"),
                                      )
                                    : tempWeekDay == 'MTWTF--'
                                        ? const Text(
                                            "Mon - Fri",
                                            style: TextStyle(
                                                color: fontColorDim,
                                                fontFamily: "TiltNeon"),
                                          )
                                        : tempWeekDay == '-------'
                                            ? const Text(
                                                "One Time",
                                                style: TextStyle(
                                                    color: fontColorDim,
                                                    fontFamily: "TiltNeon"),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "M",
                                                    style: TextStyle(
                                                        color: tempWeekDay[0] ==
                                                                'M'
                                                            ? mainColor
                                                            : fontColorDim,
                                                        fontWeight: tempWeekDay[
                                                                    0] ==
                                                                'M'
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                        fontFamily: "TiltNeon"),
                                                  ),
                                                  Text(
                                                    "T",
                                                    style: TextStyle(
                                                        color: tempWeekDay[1] ==
                                                                'T'
                                                            ? mainColor
                                                            : fontColorDim,
                                                        fontWeight: tempWeekDay[
                                                                    1] ==
                                                                'T'
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                        fontFamily: "TiltNeon"),
                                                  ),
                                                  Text(
                                                    "W",
                                                    style: TextStyle(
                                                        color: tempWeekDay[2] ==
                                                                'W'
                                                            ? mainColor
                                                            : fontColorDim,
                                                        fontWeight: tempWeekDay[
                                                                    2] ==
                                                                'W'
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                        fontFamily: "TiltNeon"),
                                                  ),
                                                  Text(
                                                    "T",
                                                    style: TextStyle(
                                                        color: tempWeekDay[3] ==
                                                                'T'
                                                            ? mainColor
                                                            : fontColorDim,
                                                        fontWeight: tempWeekDay[
                                                                    3] ==
                                                                'T'
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                        fontFamily: "TiltNeon"),
                                                  ),
                                                  Text(
                                                    "F",
                                                    style: TextStyle(
                                                        color: tempWeekDay[4] ==
                                                                'F'
                                                            ? mainColor
                                                            : fontColorDim,
                                                        fontWeight: tempWeekDay[
                                                                    4] ==
                                                                'F'
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                        fontFamily: "TiltNeon"),
                                                  ),
                                                  Text(
                                                    "S",
                                                    style: TextStyle(
                                                        color: tempWeekDay[5] ==
                                                                'S'
                                                            ? mainColor
                                                            : fontColorDim,
                                                        fontWeight: tempWeekDay[
                                                                    5] ==
                                                                'S'
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                        fontFamily: "TiltNeon"),
                                                  ),
                                                  Text(
                                                    "S",
                                                    style: TextStyle(
                                                        color: tempWeekDay[6] ==
                                                                'S'
                                                            ? mainColor
                                                            : fontColorDim,
                                                        fontWeight: tempWeekDay[
                                                                    6] ==
                                                                'S'
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                        fontFamily: "TiltNeon"),
                                                  ),
                                                ],
                                              )),
                          ),
                          const Icon(
                            Icons.navigate_next,
                            color: fontColorDim,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  editRingtuneFun(-1);
                },
                child: Container(
                  width: pageWidth - 103,
                  height: 40,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: tertiaryColor,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 80,
                        child: Text(
                          "Ringtone: ",
                          style: TextStyle(
                              color: fontColor, fontFamily: "TiltNeon"),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 80,
                            width: pageWidth - 230,
                            child: Center(
                                child: Text(
                              tempRingtone,
                              style: const TextStyle(
                                  color: fontColorDim, fontFamily: "TiltNeon"),
                            )),
                          ),
                          const Icon(
                            Icons.navigate_next,
                            color: fontColorDim,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.only(left: 20, top: 20),
                      child: const Text(
                        "Volume:",
                        style:
                            TextStyle(color: fontColor, fontFamily: "TiltNeon"),
                      )),
                  SizedBox(
                    width: pageWidth - 65,
                    child: Center(
                      child: Slider(
                        value: tempVolume,
                        max: 100,
                        min: 20,
                        divisions: 80,
                        overlayColor:
                            const MaterialStatePropertyAll(Colors.transparent),
                        thumbColor: tempVolume >= 85 ? dangerColor : mainColor,
                        activeColor: tempVolume >= 85 ? dangerColor : mainColor,
                        inactiveColor:
                            tempVolume >= 85 ? dangerColorDim : mainColorDim,
                        onChanged: (double value) {
                          tempVolume = value;
                          if (isDeleteEnable != -1) {
                            isDeleteEnable = -1;
                            // widget.remakeState(index);
                          }
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              )),
              const SizedBox(
                height: 10,
              ),
              Dialog(
                insetPadding: const EdgeInsets.all(0),
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Ink(
                      width: 100,
                      height: 44,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: tertiaryColor)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        splashColor: secondaryColor,
                        splashFactory: InkRipple.splashFactory,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "TiltNeon"),
                          ),
                        ),
                      ),
                    ),
                    Ink(
                      width: 100,
                      height: 44,
                      decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        splashColor: const Color.fromARGB(255, 0, 83, 152),
                        splashFactory: InkRipple.splashFactory,
                        onTap: () {
                          var obj = Alarms(
                              id: const Uuid().v4().toString(),
                              alarmHour: tempTimeofDay.hour,
                              alarmMin: tempTimeofDay.minute,
                              alarmDays: tempWeekDay,
                              alarmTone: tempRingtone,
                              isEnable: 1,
                              volume: tempVolume,
                              isEditable: false);

                          myAlarms.add(obj);
                          DatabaseHelper.instance.addIntoDatabase(obj);

                          widget.remakeState(-1);
                          Navigator.of(context).pop();
                        },
                        child: const Center(
                          child: Text(
                            "Set",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "TiltNeon"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
