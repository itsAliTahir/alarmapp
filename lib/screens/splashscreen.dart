import 'package:alarmapp/constants.dart';
import 'package:alarmapp/helper/databasehelper.dart';
import 'package:flutter/material.dart';
import '../models/alarms.dart';
import 'mainPage.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  int buildScreen = 1;
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1, milliseconds: 400)).then((value) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const MyMainPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> listInitialize() async {
      if (buildScreen == 1) {
        buildScreen++;
        myAlarms = [];
        try {
          List<Alarms> tempList = await DatabaseHelper.instance.getData();
          for (int i = 0; i < tempList.length; i++) {
            myAlarms.add(tempList[i]);
          }
        } catch (e) {
          return;
        }
      }
    }

    listInitialize();

    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(color: mainColor),
            child: Center(
              child: SizedBox(
                child: Stack(children: [
                  Center(
                    child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(
                                color: const Color.fromARGB(255, 0, 88, 159)),
                            borderRadius: BorderRadius.circular(45)),
                        child: const Icon(
                          Icons.alarm,
                          color: mainColor,
                          size: 55,
                        )),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 35),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "Alarm App",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontFamily: "TiltNeon"),
                        )),
                  )
                ]),
              ),
            )));
  }
}
