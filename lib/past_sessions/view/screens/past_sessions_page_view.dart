import 'package:flutter/material.dart';
import 'package:flutter_meditation/common/helpers.dart';
import 'package:flutter_meditation/widgets/breathing_circle_widget.dart';
import 'package:flutter_meditation/widgets/gradient_background.dart';
import 'package:flutter_meditation/widgets/heart_rate_graph.dart';
import 'package:flutter_meditation/widgets/information_box.dart';
import '../../../base/base_view.dart';
import '../../view_model/past_sessions_page_view_model.dart';

class PastSessionsPageView extends BaseView<PastSessionsPageViewModel> {
  PastSessionsPageView({super.key});

  @override
  Widget build(BuildContext context, PastSessionsPageViewModel viewModel,
      Widget? child) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleTextStyle: Theme.of(context).textTheme.headlineLarge,
        backgroundColor: Colors.black,
        title: Text("Past Sessions"),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.black),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Details',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text("Hey"),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Meditation info',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Theme.of(context).colorScheme.surfaceTint,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
