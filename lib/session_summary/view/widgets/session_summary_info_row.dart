/// {@category Widget}
library session_summary_info_row;
import 'package:flutter/material.dart';

class SessionSummaryInfoRow extends StatelessWidget {
  final Widget leftWidget;
  final Widget rightWidget;

  const SessionSummaryInfoRow({super.key, required this.leftWidget, required this.rightWidget});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          leftWidget,
          SizedBox(
            // calculate the width of the parent
            width: MediaQuery.of(context).size.width / 3,
            // width: 120.0,
            child: rightWidget,
          ),
        ],
      ),
    );
  }
}