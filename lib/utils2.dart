String getHours(String from, String to) {
  int hFrom = int.parse(from.split(":")[0]);
  int mFrom = int.parse(from.split(":")[1]);
  int hTo = int.parse(to.split(":")[0]);
  int mTo = int.parse(to.split(":")[1]);
  DateTime dt = DateTime(2018, 1, 1, hFrom, mFrom);
  DateTime dt2 = DateTime(2018, 1, 1, hTo, mTo);
  Duration d = dt2.difference(dt);
  return (d.inMinutes / 60).toString();
}

String getTotalHours(List<dynamic> overview) {
  double total = 0.0;
  overview.forEach((field) {
    total += double.parse(getHours(field["workFrom"], field["workTo"]));
  });
  return total.toString();
}

String convertDate(DateTime date) {
  return "${withZero(date.day)}.${withZero(date.month)}.${date.year}";
}

String convertDateBackend(DateTime date) {
  return "${date.year}-${withZero(date.month)}-${withZero(date.day)}";
}

String convertDateFull(DateTime date) {
  return convertDate(date) +
      ", ${withZero(date.hour)}:${withZero(date.minute)}:${withZero(date.second)}";
}

String withZero(int numb) {
  if (numb < 10) {
    return "0$numb";
  }
  return numb.toString();
}

String formatTime(int time) {
  DateTime dt = DateTime.fromMillisecondsSinceEpoch(time);
  String h = (dt.hour - 1) < 10 ? "0${(dt.hour - 1)}" : "${(dt.hour)}"; //??
  String m = dt.minute < 10 ? "0${dt.minute}" : "${dt.minute}";
  String s = dt.second < 10 ? "0${dt.second}" : "${dt.second}";

  return "$h:$m:$s";
}

String formatTimeRounded(int time) {
  DateTime dt = DateTime.fromMillisecondsSinceEpoch(time);
  String h = (dt.hour) < 10 ? "0${(dt.hour)}" : "${(dt.hour)}"; //??

  return "$h:${roundMinutes(dt.minute)}";
}

String roundMinutes(m) {
  if (m <= 7)
    return "00";
  else if (m >= 8 && m <= 22)
    return "15";
  else if (m >= 23 && m <= 37)
    return "30";
  else if (m >= 38 && m <= 52)
    return "45";
  else
    return "00";
}
