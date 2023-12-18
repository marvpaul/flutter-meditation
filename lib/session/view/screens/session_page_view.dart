import 'package:flutter/material.dart';
import 'package:flutter_meditation/widgets/gradient_background.dart';
import 'package:flutter_meditation/widgets/kaleidoscope.dart';
import 'package:flutter_meditation/widgets/session_widget.dart';
import '../../../base/base_view.dart';
import '../../view_model/session_page_view_model.dart';

class SessionPageView extends BaseView<SessionPageViewModel> {
  SessionPageView({super.key});

  @override
  Widget build(
      BuildContext context, SessionPageViewModel viewModel, Widget? child) {
    if (!viewModel.running && !viewModel.finished) {
      viewModel.initWithContext(context);
    }
    // return Scaffold(
    //   body: viewModel.settingsModel?.kaleidoscope??false ? Kaleidoscope(
    //     viewModel: viewModel,
    //     child: // Column(
    //     //   children: [
    //         // AppBar(
    //         //   centerTitle: false,
    //         //   titleTextStyle: Theme.of(context).textTheme.headlineLarge,
    //         //   backgroundColor: Colors.transparent,
    //         //   elevation: 0,
    //         // ),
    //         // SessionWidget(viewModel: viewModel)
    //     Container()
    //       // ],
    //     // ),
    //   ):GradientBackground(
    //     child: Column(
    //       children: [
    //         AppBar(
    //           centerTitle: false,
    //           titleTextStyle: Theme.of(context).textTheme.headlineLarge,
    //           backgroundColor: Colors.transparent,
    //           elevation: 0,
    //         ),
    //         SessionWidget(viewModel: viewModel)
    //       ],
    //     ),
    //   ),
    // );

    return Scaffold(
      body: Kaleidoscope(
        viewModel: viewModel,
        child: SessionWidget(viewModel: viewModel)
      ),
    );
  }
}
