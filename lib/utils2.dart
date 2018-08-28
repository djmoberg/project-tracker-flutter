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

String withZero(int numb) {
  if (numb < 10) {
    return "0$numb";
  }
  return numb.toString();
}
