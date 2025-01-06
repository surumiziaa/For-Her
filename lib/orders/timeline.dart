import'package:flutter/material.dart';
import 'package:for_her/Core/utilities.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'eventcard.dart';

class TimelineTileWidget extends StatefulWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final String text;
  const TimelineTileWidget(
      {super.key,
        required this.isFirst,
        required this.isLast,
        required this.isPast,
        required this.text});

  @override
  State<TimelineTileWidget> createState() => _TimelineTileWidgetState();
}

class _TimelineTileWidgetState extends State<TimelineTileWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: TimelineTile(
        hasIndicator: true,
        isFirst: widget.isFirst,
        isLast: widget.isLast,
        beforeLineStyle: LineStyle(
            color: widget.text == "Cancelled"
                ? Colors.red
                : widget.isPast
                ? Colors.green
                : Colors.grey),
        indicatorStyle: IndicatorStyle(
            color: widget.isPast ?Colors.green: org,
            width: 15,
            iconStyle:
            IconStyle(iconData: Icons.done,
                color: widget.text=='Cancelled'
                    ?Colors.red
                    :Colors.white, fontSize: 16)),
        endChild: EventCard(
          isPast: widget.isPast,
          text: widget.text,
        ),
      ),
    );
  }
}
