import 'dart:math' as math;

import 'package:intl/intl.dart';

class CalculateETA {
  static double distanceTo(
      {double posLat1, double posLon1, double destLat2, double destLon2, String unit: 'K'}) {
    double rlat1 = math.pi * posLat1 / 180;
    double rlat2 = math.pi * destLat2 / 180;
    double theta = posLon1 - destLon2;
    double rtheta = math.pi * theta / 180;
    double dist =
        math.sin(rlat1) * math.sin(rlat2) + math.cos(rlat1) * math.cos(rlat2) * math.cos(rtheta);
    dist = math.acos(dist);
    dist = dist * 180 / math.pi;
    dist = dist * 60 * 1.1515;
    switch (unit) {
      case 'K': //Kilometers -> default
        return dist;
      case 'N': //Nautical Miles
        return dist * 0.8684;
      case 'M': //Miles
        return dist;
    }
  }

  static String calculateETA(
      double posLat1, double posLon1, double lat2, double lon2, String unit) {
    //TODO pass user current location
    // double currentLat = 22.924376;
    // double currentLong = 72.408972;
    double etaHours =
        distanceTo(posLat1: posLat1, posLon1: posLon1, destLat2: lat2, destLon2: lon2, unit: unit) /
            50;
    print(etaHours);
    return DateFormat('yyyy-MM-dd HH:mm')
        .format(DateTime.now().add(Duration(hours: etaHours.toInt())));
  }
}
