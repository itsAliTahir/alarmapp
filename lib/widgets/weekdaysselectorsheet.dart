import 'package:flutter/material.dart';

import '../constants.dart';

// ignore: must_be_immutable
class MyWeekDaysSelector extends StatefulWidget {
  String tempWeekdays;
  Function weekdaysFun;
  Function remakeState;
  MyWeekDaysSelector(this.tempWeekdays, this.weekdaysFun, this.remakeState,
      {super.key});

  @override
  State<MyWeekDaysSelector> createState() => _MyWeekDaysSelectorState();
}

class _MyWeekDaysSelectorState extends State<MyWeekDaysSelector> {
  List<String> options = ["One Time", "Mon - Fri", "Everyday"];
  Widget dayMaker(String today, int index, int i) {
    return GestureDetector(
      onTap: () {
        if (widget.tempWeekdays[i] == today) {
          widget.tempWeekdays =
              '${widget.tempWeekdays.substring(0, i)}-${widget.tempWeekdays.substring(i + 1)}';
        } else {
          widget.tempWeekdays =
              '${widget.tempWeekdays.substring(0, i)}$today${widget.tempWeekdays.substring(i + 1)}';
        }
        widget.weekdaysFun(widget.tempWeekdays);
        widget.remakeState(-1);
        setState(() {});
      },
      child: Container(
        height: 22,
        width: 22,
        padding: const EdgeInsets.all(2),
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: widget.tempWeekdays == today
                ? mainColor
                : widget.tempWeekdays[i] == today
                    ? mainColor
                    : disabledColor,
            borderRadius: BorderRadius.circular(45)),
        child: Center(
            child: Text(
          today,
          style: const TextStyle(fontSize: 10, color: fontColor
              // fontWeight: FontWeight.bold
              ),
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double pageWidth = MediaQuery.of(context).size.width;
    int highlightIndex = -1;

    if (widget.tempWeekdays == "-------") {
      highlightIndex = 0;
    } else if (widget.tempWeekdays == "MTWTF--") {
      highlightIndex = 1;
    } else if (widget.tempWeekdays == "MTWTFSS") {
      highlightIndex = 2;
    } else {
      highlightIndex = -1;
    }

    return Container(
      decoration: BoxDecoration(
          color: quaternaryColor, borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 8, left: 20, right: 20),
      child: Column(children: [
        Container(
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.only(left: 10),
          width: pageWidth,
          height: 64,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Weekdays",
                style: TextStyle(color: fontColorDim, fontFamily: "TiltNeon"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  dayMaker('M', 0, 0),
                  dayMaker('T', 0, 1),
                  dayMaker('W', 0, 2),
                  dayMaker('T', 0, 3),
                  dayMaker('F', 0, 4),
                  dayMaker('S', 0, 5),
                  dayMaker('S', 0, 6),
                ],
              )
            ],
          ),
        ),
        const Divider(
          color: primaryColor,
          height: 0,
        ),
        SizedBox(
            width: pageWidth,
            height: 106,
            // color: Colors.amber,
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (index == 0) {
                        widget.tempWeekdays = "-------";
                      } else if (index == 1) {
                        widget.tempWeekdays = "MTWTF--";
                      } else if (index == 2) {
                        widget.tempWeekdays = "MTWTFSS";
                      }
                      widget.weekdaysFun(widget.tempWeekdays);
                      widget.remakeState(-1);
                      setState(() {});
                    },
                    child: Container(
                        color: highlightIndex == index
                            ? Colors.black45
                            : Colors.transparent,
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 2),
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          height: 24,
                          width: pageWidth,
                          child: Text(
                            options[index],
                            style: TextStyle(
                                color: highlightIndex == index
                                    ? fontColor
                                    : fontColorDim,
                                fontFamily: "TiltNeon",
                                fontWeight: highlightIndex == index
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        )),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(
                    width: pageWidth,
                    height: 1,
                    color: primaryColor,
                  );
                },
                itemCount: 3))
      ]),
    );
  }
}
