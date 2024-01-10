/// {@category Widget}
library session_summary_title_and_value_widget;
import 'package:flutter/material.dart';

class SessionSummaryTitleAndValueWidget extends StatelessWidget {
  final String title;
  final String value;

  const SessionSummaryTitleAndValueWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              color: Colors.grey,
              fontSize: 14.0
          ),
        ),
        Text(
          value,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 20.0,
              fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }
}