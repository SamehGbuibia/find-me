import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:independet/presentation/main_screen/compass_content.dart';
import 'package:independet/presentation/resources/string_manager.dart';

class Compass extends StatefulWidget {
  const Compass({Key? key, required this.angle}) : super(key: key);
  final double angle;
  @override
  // ignore: library_private_types_in_public_api
  _CompassState createState() => _CompassState();
}

class _CompassState extends State<Compass> {
  double previousDirection = 0;

  @override
  Widget build(BuildContext context) {
    return _buildCompass(widget.angle);
  }

  Widget _buildCompass(double angle) {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text(StringsManager.directionNullError));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CompassContent(
            direction: previousDirection,
            angle: angle,
          );
        }

        double? direction = snapshot.data!.heading;
        if (direction == null) {
          return const Center(
            child: Text(StringsManager.directionNullError),
          );
        }
        previousDirection = direction;
        return CompassContent(
          direction: direction,
          angle: angle,
        );
      },
    );
  }
}
