import 'package:flutter/material.dart';
import 'package:independet/presentation/resources/assets_manager.dart';
import 'package:independet/presentation/resources/ui_constants_manager.dart';
import 'dart:math' as math;

class CompassContent extends StatelessWidget {
  final double angle;
  final double direction;

  const CompassContent({
    Key? key,
    required this.direction,
    required this.angle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      elevation: UiConstantsManager.compassElevation,
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Transform.rotate(
          angle: (direction * (math.pi / 180) * -1),
          child: Stack(
            children: [
              Image.asset(ImageAssets.compass),
              Positioned(
                left: width * 0.5 - 25,
                bottom: width * 0.5 - 8,
                child: Transform.rotate(
                  origin: Offset(0, width / 4 - 4),
                  angle: -angle,
                  child:
                      Image.asset(ImageAssets.arrowUp, height: width / 2 - 8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
