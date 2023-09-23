import 'package:alarmapp/constants.dart';
import 'package:alarmapp/models/alarms.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyFloatingActionButton extends StatelessWidget {
  Function alarmDialogue;
  Function deleteAlarmFun;

  MyFloatingActionButton(this.alarmDialogue, this.deleteAlarmFun, {super.key});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "Hello",
      // backgroundColor: isDeleteEnable == -1 ? mainColor : dangerColor,
      backgroundColor: Colors.transparent,
      elevation: 5,
      onPressed: () {
        if (isDeleteEnable != -1) {
          deleteAlarmFun();
          isDeleteEnable = -1;
          tempIndex = -1;
          return;
        }
        if (tempIndex != -1) myAlarms[tempIndex].isEnable = temp;
        for (int i = 0; i < myAlarms.length; i++) {
          myAlarms[i].isEditable = false;
        }
        alarmDialogue();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45),
          color: isDeleteEnable == -1 ? mainColor : dangerColor,
        ),
        width: double.infinity,
        child: Icon(isDeleteEnable == -1
            ? Icons.add_alarm_sharp
            : Icons.delete_forever),
      ),
    );
  }
}
