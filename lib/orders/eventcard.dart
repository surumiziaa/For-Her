// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:for_her/Core/utilities.dart';
import 'package:google_fonts/google_fonts.dart';

class EventCard extends StatelessWidget {
  final bool isPast;
  final String text;
  const EventCard({super.key, required this.isPast, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          text,
          style: GoogleFonts.acme(
              color: text == "Cancelled"
                  ? Colors.red
                  : isPast
                  ? Colors.black
                  : Colors.blueGrey),
        ),
      ),
    );
  }
}
