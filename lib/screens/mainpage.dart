import 'package:alarmapp/helper/databasehelper.dart';
import 'package:alarmapp/models/alarms.dart';
import 'package:alarmapp/widgets/addAlarmDialog.dart';
import 'package:alarmapp/widgets/ringtoneSelectorSheet.dart';
import 'package:flutter/material.dart';
import '../widgets/alarmsList.dart';
import '../widgets/currentTime.dart';
import '../widgets/floatingAction.dart';
import 'package:alarmapp/constants.dart';

class MyMainPage extends StatefulWidget {
  const MyMainPage({super.key});

  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  @override
  Widget build(BuildContext context) {
    final double pageWidth = MediaQuery.of(context).size.width;
    final double pageHeight = MediaQuery.of(context).size.height;

    void remakeState(int index) {
      toDeleteIndex = index;
      setState(() {});
    }

    void addAlarmFun() {
      setState(() {});
      showDialog(
          context: context,
          builder: (_) {
            return MyAddAlarm(remakeState);
          });
    }

    void deleteAlarmFun() {
      if (toDeleteIndex != -1) {
        DatabaseHelper.instance.deleteFromDatabase(myAlarms[toDeleteIndex]);
        myAlarms.removeAt(toDeleteIndex);
      }
      setState(() {});
    }

    void editRingtuneFun(int index) {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (_) {
            return Container(
              color: Colors.transparent,
              height: 200,
              child: MyEditRingtoneSheet(index, remakeState),
            );
          });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Container(
        width: pageWidth,
        height: pageHeight,
        color: primaryColor,
        child: Column(
          children: [
            const SizedBox(
              height: 22,
            ),
            MyCurrentTime(remakeState),
            Container(
              height: 0.2,
              width: pageWidth,
              color: Colors.black,
            ),
            MyAlarmsList(editRingtuneFun, remakeState),
            Container(
              height: 0.2,
              width: pageWidth,
              color: Colors.black,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: MyFloatingActionButton(
        addAlarmFun,
        deleteAlarmFun,
      ),
    );
  }
}
