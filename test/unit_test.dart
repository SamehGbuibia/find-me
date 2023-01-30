import 'package:flutter_test/flutter_test.dart';

// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math.dart' show radians, degrees;
import 'dart:math' show atan, cos, sin, tan;

void main() {
  group("Compass Angle function", () {
    const accuracy = 1;
    test('Same Position Test', () async {
      for (int longitude = -180 * accuracy;
          longitude <= 180 * accuracy;
          longitude++) {
        for (int latitude = -90 * accuracy;
            latitude <= 90 * accuracy;
            latitude++) {
          final angle = getOffsetFromNorth(latitude / accuracy,
              longitude / accuracy, latitude / accuracy, longitude / accuracy);
          expect(angle, 0);
        }
      }
    });
  });
}

double getOffsetFromNorth(
    double latitude1, double longitude1, double latitude2, double longitude2) {
  if (latitude1 == latitude2 && longitude1 == longitude2) {
    //added after the test fail
    return 0;
  }
  // ignore: no_leading_underscores_for_local_identifiers
  final _deLa = radians(latitude2);
  // ignore: no_leading_underscores_for_local_identifiers
  final _deLo = radians(longitude2);
  var laRad = radians(latitude1);
  var loRad = radians(longitude1);

  var toDegrees = degrees(atan(sin(_deLo - loRad) /
      ((cos(laRad) * tan(_deLa)) - (sin(laRad) * cos(_deLo - loRad)))));
  if (laRad > _deLa) {
    if ((loRad > _deLo || loRad < radians(-180.0) + _deLo) &&
        toDegrees > 0.0 &&
        toDegrees <= 90.0) {
      toDegrees += 180.0;
    } else if (loRad <= _deLo &&
        loRad >= radians(-180.0) + _deLo &&
        toDegrees > -90.0 &&
        toDegrees < 0.0) {
      toDegrees += 180.0;
    }
  }
  if (laRad < _deLa) {
    if ((loRad > _deLo || loRad < radians(-180.0) + _deLo) &&
        toDegrees > 0.0 &&
        toDegrees < 90.0) {
      toDegrees += 180.0;
    }
    if (loRad <= _deLo &&
        loRad >= radians(-180.0) + _deLo &&
        toDegrees > -90.0 &&
        toDegrees <= 0.0) {
      toDegrees += 180.0;
    }
  }
  return -radians(toDegrees);
}
