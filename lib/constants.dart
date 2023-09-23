import 'dart:async';
import 'package:flutter/material.dart';

const MaterialColor materialColor = Colors.blue;
const Color mainColor = Colors.blue;
const Color mainColorDim = Color.fromARGB(104, 20, 93, 152);
const Color disabledColor = Color.fromARGB(255, 114, 113, 113);
const Color disabledColorDim = Color.fromARGB(139, 114, 113, 113);
const Color fontColor = Colors.white;
const Color fontColorDim = Color.fromARGB(157, 255, 255, 255);
const Color primaryColor = Color.fromARGB(255, 42, 42, 62);
const Color secondaryColor = Color.fromARGB(134, 29, 29, 42);
const Color tertiaryColor = Color.fromARGB(255, 21, 21, 31);
const Color quaternaryColor = Color.fromARGB(255, 27, 27, 41);
const Color dangerColor = Colors.red;
const Color dangerColorDim = Color.fromARGB(66, 255, 82, 82);

// Variables
int temp = 0;
int tempIndex = -1;
int isDeleteEnable = -1;
int toDeleteIndex = -1;

late Stream<int> timerStream;
late StreamSubscription<int> timerSubscription;
