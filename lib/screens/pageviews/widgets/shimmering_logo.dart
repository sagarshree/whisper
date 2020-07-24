import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:whisper/utils/universal_constants.dart';

class ShimmeringLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
      child: Shimmer.fromColors(
          direction: ShimmerDirection.ltr,
          baseColor: UniversalVariables.blackColor,
          highlightColor: Colors.white,
          child: Center(
            child: Text(
              'NAMO',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          )),
    );
  }
}
