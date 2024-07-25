import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';

class TripDetailRow extends StatelessWidget {
  final String leftText;
  final String rightText;
  final bool showDottedLine;
  final double spaceHeight;

  const TripDetailRow({
    Key? key,
    required this.leftText,
    required this.rightText,
    this.showDottedLine = true, // Default value is true
    required this.spaceHeight, // Height for the SizedBox
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: spaceHeight,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              leftText,
              style: TextStyle(
                  color: Color(0xff676767),
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              rightText,
              style: TextStyle(
                  color: Color(0xff000000),
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(
          height: spaceHeight / 2, 
        ),
        if (showDottedLine) DottedLine(),
      ],
    );
  }
}
