String getTimestamp(int timestamp) {
  int postTime = timestamp;
  int currentTime = DateTime.now().millisecondsSinceEpoch;
  int diff;
  diff = currentTime - postTime;

  int placeholder;
  String time;

  if (0 < diff && diff < 2000) {
    placeholder = diff ~/ 1000;
    time = "$placeholder" + " " + "Second Ago";
    return time;
  }
  else if (2000 <= diff && diff < 60000) {
    placeholder = diff ~/ 1000;
    time = "$placeholder" + " " + "Seconds Ago";
    return time;
  }
  else if (60000 <= diff && diff < 120000){
    placeholder = diff ~/ 60000;
    time = "$placeholder" + " " + "Minute Ago";
    return time;
  }
  else if (120000 <= diff && diff < 3600000) {
    placeholder = diff ~/ 60000;
    time = "$placeholder" + " " + "Minutes Ago";
    return time;
  }
  else if (3600000 <= diff && diff < 7200000) {
    placeholder = diff ~/ 3600000;
    time = "$placeholder" + " " + "Hour Ago";
    return time;
  }
  else if (7200000 <= diff && diff < 86400000) {
    placeholder = diff ~/ 3600000;
    time = "$placeholder" + " " + "Hours Ago";
    return time;
  }
  else if (86400000 <= diff && diff < 172800000) {
    placeholder = diff ~/ 86400000;
    time = "$placeholder" + " " + "Day Ago";
    return time;
  }
  else if (172800000 <= diff && diff < 604800000) {
    placeholder = diff ~/ 86400000;
    time = "$placeholder" + " " + "Days Ago";
    return time;
  }
  else if (604800000 <= diff && diff < 1209600000) {
    placeholder = diff ~/ 604800000;
    time = "$placeholder" + " " + "Week Ago";
    return time;
  }
  else if (1209600000 <= diff) {
    placeholder = diff ~/ 604800000;
    time = "$placeholder" + " " + "Weeks Ago";
    return time;
  }
  return time;
}