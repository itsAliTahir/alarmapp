import 'package:alarmapp/constants.dart';
import 'package:alarmapp/models/alarms.dart';
import 'package:flutter/material.dart';
import '../helper/databasehelper.dart';

// ignore: must_be_immutable
class MyEditRingtoneSheet extends StatefulWidget {
  int i;
  Function remakeState;
  MyEditRingtoneSheet(this.i, this.remakeState, {super.key});

  @override
  State<MyEditRingtoneSheet> createState() => _MyEditRingtoneSheetState();
}

class _MyEditRingtoneSheetState extends State<MyEditRingtoneSheet> {
  int highlighIndex = 0;

  @override
  Widget build(BuildContext context) {
    double pageWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          color: quaternaryColor, borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 8, left: 20, right: 20),
      child: Column(children: [
        Container(
            height: 180,
            width: pageWidth,
            margin:
                const EdgeInsets.only(left: 10, right: 10, top: 7, bottom: 5),
            child: ListView.separated(
              itemCount: AvailableTones.length,
              itemBuilder: (context, index) {
                if (widget.i != -1) {
                  for (int i = 0; i < AvailableTones.length; i++) {
                    if (myAlarms[widget.i].alarmTone ==
                        AvailableTones[i].name) {
                      highlighIndex = i;
                    }
                  }
                }
                return GestureDetector(
                  onTap: () async {
                    if (widget.i != -1) {
                      myAlarms[widget.i].alarmTone = AvailableTones[index].name;
                      DatabaseHelper.instance
                          .updateDatabase(myAlarms[widget.i]);
                      setState(() {});
                      widget.remakeState(index);
                    } else {
                      highlighIndex = index;
                      widget.remakeState(index);
                      setState(() {});
                    }
                  },
                  child: Container(
                    color: (widget.i != -1 &&
                                myAlarms[widget.i].alarmTone ==
                                    AvailableTones[index]) ||
                            highlighIndex == index
                        ? Colors.black45
                        : Colors.transparent,
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 2),
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      height: 24,
                      width: pageWidth,
                      child: Text(
                        AvailableTones[index].name,
                        style: TextStyle(
                            color: (widget.i != -1 &&
                                        myAlarms[widget.i].alarmTone ==
                                            AvailableTones[index]) ||
                                    highlighIndex == index
                                ? fontColor
                                : fontColorDim,
                            fontWeight: (widget.i != -1 &&
                                        myAlarms[widget.i].alarmTone ==
                                            AvailableTones[index]) ||
                                    highlighIndex == index
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontFamily: "TiltNeon"),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Container(
                  width: pageWidth,
                  height: 1,
                  color: primaryColor,
                );
              },
            )),
      ]),
    );
  }
}
