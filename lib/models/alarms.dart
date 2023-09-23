class Alarms {
  final String? id;
  int alarmHour;
  int alarmMin;
  String alarmDays;
  String alarmTone;
  int isEnable;
  double volume;
  bool isEditable = false;
  Alarms(
      {required this.id,
      required this.alarmHour,
      required this.alarmMin,
      required this.alarmDays,
      required this.alarmTone,
      required this.isEnable,
      required this.volume,
      required this.isEditable});

  factory Alarms.fromMap(Map<String, dynamic> json) => Alarms(
        id: json['ID'],
        alarmHour: json['Hour'],
        alarmMin: json['MIN'],
        alarmDays: json['DAYS'],
        alarmTone: json['TONE'],
        isEnable: json['isEnable'],
        volume: json['Volume'],
        isEditable: false,
      );

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'Hour': alarmHour,
      'MIN': alarmMin,
      'DAYS': alarmDays,
      'TONE': alarmTone,
      'isEnable': isEnable,
      'Volume': volume,
    };
  }
}

List<Alarms> myAlarms = [
  // Alarms(
  //     id: "0",
  //     alarmHour: 10,
  //     alarmMin: 30,
  //     alarmDays: "MTWTFSS",
  //     alarmTone: AvailableTones[0],
  //     isEnable: 1,
  //     volume: 70,
  //     isEditable: false),
  // Alarms(
  //     id: "0",
  //     alarmHour: 10,
  //     alarmMin: 30,
  //     alarmDays: "-----SS",
  //     alarmTone: AvailableTones[2],
  //     isEnable: 1,
  //     volume: 70,
  //     isEditable: false),
  // Alarms(
  //     id: "0",
  //     alarmHour: 10,
  //     alarmMin: 30,
  //     alarmDays: "-------",
  //     alarmTone: AvailableTones[1],
  //     isEnable: 0,
  //     volume: 70,
  //     isEditable: false),
  // Alarms(
  //     id: "0",
  //     alarmHour: 10,
  //     alarmMin: 30,
  //     alarmDays: "MTWTF--",
  //     alarmTone: AvailableTones[0],
  //     isEnable: 1,
  //     volume: 70,
  //     isEditable: false),
];

class Tones {
  final String name;
  final String file;
  Tones(this.name, this.file);
}

// ignore: constant_identifier_names, non_constant_identifier_names
List<Tones> AvailableTones = [
  Tones("Daily Routine", "daily_routine"),
  Tones("Dusk Till Dawn", "dusk_till_dawn"),
  Tones("Little Do You Know", "little_do_you_know"),
  Tones("One Step Forward", "one_step_forward"),
  Tones("Say Yes To Heaven", "say_yes_to_heaven"),
];
