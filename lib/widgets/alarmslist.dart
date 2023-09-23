import 'package:alarmapp/constants.dart';
import 'package:alarmapp/helper/databasehelper.dart';
import 'package:flutter/material.dart';
import '../models/alarms.dart';

// ignore: must_be_immutable
class MyAlarmsList extends StatefulWidget {
  Function editRingtuneFun;
  Function remakeState;
  MyAlarmsList(this.editRingtuneFun, this.remakeState, {super.key});

  @override
  State<MyAlarmsList> createState() => _MyAlarmsListState();
}

class _MyAlarmsListState extends State<MyAlarmsList> {
  void _presentTimePicker(int index) {
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
      initialTime: TimeOfDay(
          hour: myAlarms[index].alarmHour, minute: myAlarms[index].alarmMin),
    ).then((pickedTime) {
      if (pickedTime == null) {
        return;
      } else {
        setState(() {
          myAlarms[index].alarmHour = pickedTime.hour;
          myAlarms[index].alarmMin = pickedTime.minute;
          DatabaseHelper.instance.updateDatabase(myAlarms[index]);
        });
      }
    });
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

  Widget dayMaker(String today, int enable, int index, int i) {
    return GestureDetector(
      onTap: () {
        if (isDeleteEnable != -1) {
          isDeleteEnable = -1;
          widget.remakeState(index);
        }
        if (myAlarms[index].isEditable == true) {
          if (myAlarms[index].alarmDays[i] == today) {
            myAlarms[index].alarmDays =
                '${myAlarms[index].alarmDays.substring(0, i)}-${myAlarms[index].alarmDays.substring(i + 1)}';
          } else {
            myAlarms[index].alarmDays =
                '${myAlarms[index].alarmDays.substring(0, i)}$today${myAlarms[index].alarmDays.substring(i + 1)}';
          }
          DatabaseHelper.instance.updateDatabase(myAlarms[index]);
          setState(() {});
        }
      },
      child: Container(
        height: 22,
        width: 22,
        padding: const EdgeInsets.all(2),
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: myAlarms[index].alarmDays[i] == today &&
                    myAlarms[index].isEnable == 1
                ? mainColor
                : myAlarms[index].alarmDays[i] == today &&
                        myAlarms[index].isEnable == 0
                    ? mainColorDim
                    : myAlarms[index].isEnable == 0
                        ? disabledColorDim
                        : disabledColor,
            borderRadius: BorderRadius.circular(45)),
        child: Center(
            child: Text(
          today,
          style: TextStyle(
              fontSize: 10,
              color: myAlarms[index].isEnable == 1 ? fontColor : fontColorDim
              // fontWeight: FontWeight.bold
              ),
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    myAlarms.sort((a, b) => a.alarmMin.compareTo(b.alarmMin));
    myAlarms.sort((a, b) => a.alarmHour.compareTo(b.alarmHour));
    final double pageWidth = MediaQuery.of(context).size.width;
    final double pageHeight = MediaQuery.of(context).size.height;
    return SizedBox(
        height: pageHeight - 225,
        child: myAlarms.isEmpty
            ? const Icon(
                Icons.alarm,
                color: secondaryColor,
                size: 200,
              )
            : ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: myAlarms.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onLongPress: () {
                      isDeleteEnable = index;
                      widget.remakeState(index);
                    },
                    onTap: () {
                      if (isDeleteEnable != -1) {
                        isDeleteEnable = -1;
                        widget.remakeState(index);
                        return;
                      }

                      if (myAlarms[index].isEditable == false) {
                        if (tempIndex != -1 && tempIndex < myAlarms.length) {
                          myAlarms[tempIndex].isEnable = temp;
                        }
                        temp = myAlarms[index].isEnable;
                        tempIndex = index;
                        for (int i = 0; i < myAlarms.length; i++) {
                          myAlarms[i].isEditable = false;
                        }
                        myAlarms[index].isEditable = true;
                        myAlarms[index].isEnable = 1;
                      } else {
                        if (tempIndex != -1) {
                          myAlarms[tempIndex].isEnable = temp;
                        }
                        myAlarms[index].isEditable = false;
                      }

                      setState(() {});
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      padding: const EdgeInsets.only(
                          top: 7, bottom: 7, left: 20, right: 10),
                      decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: isDeleteEnable == index
                                  ? mainColor
                                  : Colors.transparent)),
                      height: myAlarms[index].isEditable ? 220 : 80,
                      child: Stack(children: [
                        myAlarms[index].isEditable
                            ? const SizedBox()
                            : Align(
                                alignment: Alignment.centerRight,
                                child: Tooltip(
                                  waitDuration: const Duration(seconds: 2),
                                  message: "Toggle Enable",
                                  child: Switch(
                                    value: myAlarms[index].isEnable == 1
                                        ? true
                                        : false,
                                    onChanged: (value) {
                                      if (isDeleteEnable != -1) {
                                        isDeleteEnable = -1;
                                        widget.remakeState(index);
                                      }
                                      tempIndex = -1;
                                      if (value == true) {
                                        myAlarms[index].isEnable = 1;
                                      } else {
                                        myAlarms[index].isEnable = 0;
                                      }
                                      DatabaseHelper.instance
                                          .updateDatabase(myAlarms[index]);
                                      setState(() {});
                                    },
                                  ),
                                )),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: SizedBox(
                            width: 185,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: myAlarms[index].isEditable
                                      ? () {
                                          if (isDeleteEnable != -1) {
                                            isDeleteEnable = -1;
                                            widget.remakeState(index);
                                          }
                                          _presentTimePicker(index);
                                        }
                                      : null,
                                  child: Row(
                                    children: [
                                      Text(
                                        currentTimeFormat(
                                          TimeOfDay(
                                            hour: myAlarms[index].alarmHour,
                                            minute: myAlarms[index].alarmMin,
                                          ),
                                        ),
                                        style: TextStyle(
                                            color: myAlarms[index].isEnable == 1
                                                ? fontColor
                                                : fontColorDim,
                                            fontSize: 28,
                                            fontFamily: "WorkSans",
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        dayPeriodFun(TimeOfDay(
                                          hour: myAlarms[index].alarmHour,
                                          minute: myAlarms[index].alarmMin,
                                        ).period.toString()),
                                        style: TextStyle(
                                            color: myAlarms[index].isEnable == 1
                                                ? fontColor
                                                : fontColorDim,
                                            fontSize: 14,
                                            fontFamily: "TiltNeon"),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                myAlarms[index].alarmDays == '-------' &&
                                        myAlarms[index].isEditable == false
                                    ? Text(
                                        "One Time",
                                        style: TextStyle(
                                            color: myAlarms[index].isEnable == 1
                                                ? fontColor
                                                : fontColorDim,
                                            fontFamily: "TiltNeon"),
                                      )
                                    : Row(
                                        children: [
                                          dayMaker(
                                              'M',
                                              myAlarms[index].isEnable,
                                              index,
                                              0),
                                          dayMaker(
                                              'T',
                                              myAlarms[index].isEnable,
                                              index,
                                              1),
                                          dayMaker(
                                              'W',
                                              myAlarms[index].isEnable,
                                              index,
                                              2),
                                          dayMaker(
                                              'T',
                                              myAlarms[index].isEnable,
                                              index,
                                              3),
                                          dayMaker(
                                              'F',
                                              myAlarms[index].isEnable,
                                              index,
                                              4),
                                          dayMaker(
                                              'S',
                                              myAlarms[index].isEnable,
                                              index,
                                              5),
                                          dayMaker(
                                              'S',
                                              myAlarms[index].isEnable,
                                              index,
                                              6),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ),
                        myAlarms[index].isEditable == false
                            ? const SizedBox()
                            : Positioned(
                                top: 80,
                                child: GestureDetector(
                                  onTap: () {
                                    if (isDeleteEnable != -1) {
                                      isDeleteEnable = -1;
                                      widget.remakeState(index);
                                    }
                                    widget.editRingtuneFun(index);
                                  },
                                  child: Container(
                                    width: pageWidth - 63,
                                    height: 40,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: tertiaryColor,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(
                                          width: 80,
                                          child: Text(
                                            "Ringtone: ",
                                            style: TextStyle(
                                                color: fontColor,
                                                fontFamily: "TiltNeon"),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              height: 80,
                                              width: pageWidth - 230,
                                              child: Center(
                                                  child: Text(
                                                myAlarms[index].alarmTone,
                                                style: const TextStyle(
                                                    color: fontColorDim,
                                                    fontFamily: "TiltNeon"),
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
                              ),
                        myAlarms[index].isEditable == false
                            ? const SizedBox()
                            : Positioned(
                                top: 120,
                                left: 0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, top: 20),
                                        child: const Text(
                                          "Volume:",
                                          style: TextStyle(
                                              color: fontColor,
                                              fontFamily: "TiltNeon"),
                                        )),
                                    SizedBox(
                                      width: pageWidth - 65,
                                      child: Center(
                                        child: Slider(
                                          value: myAlarms[index].volume,
                                          max: 100,
                                          min: 20,
                                          divisions: 80,
                                          overlayColor:
                                              const MaterialStatePropertyAll(
                                                  Colors.transparent),
                                          thumbColor:
                                              myAlarms[index].volume >= 85
                                                  ? dangerColor
                                                  : mainColor,
                                          activeColor:
                                              myAlarms[index].volume >= 85
                                                  ? dangerColor
                                                  : mainColor,
                                          inactiveColor:
                                              myAlarms[index].volume >= 85
                                                  ? dangerColorDim
                                                  : mainColorDim,
                                          onChanged: (double value) {
                                            myAlarms[index].volume = value;
                                            if (isDeleteEnable != -1) {
                                              isDeleteEnable = -1;
                                              widget.remakeState(index);
                                            }
                                            DatabaseHelper.instance
                                                .updateDatabase(
                                                    myAlarms[index]);
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                      ]),
                    ),
                  );
                },
              ));
  }
}
