import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../di/Setup.dart';
import 'base_view_model.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

abstract class BaseView<T extends BaseViewModel> extends StatefulWidget {
  BaseView({Key? key}) : super(key: key);

  Widget build(BuildContext context, T viewModel, Widget? child);

  @override
  State<BaseView> createState() => BaseViewState<T>();
}

class BaseViewState<T extends BaseViewModel> extends State<BaseView<T>>
    with RouteAware {
  T? viewModel = getIt<T>();

  @mustCallSuper
  @override
  void initState() {
    super.initState();
    viewModel?.init();
  }

  @mustCallSuper
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // subscribe for the change of route
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  /// Called when the top route has been popped off, and the current route
  /// shows up.
  @mustCallSuper
  @override
  void didPopNext() {

    viewModel?.routingDidPopNext();
  }

  /// Called when the current route has been pushed.
  @mustCallSuper
  @override
  void didPush() {

    viewModel?.routingDidPush();
  }

  /// Called when the current route has been popped off.
  @mustCallSuper
  @override
  void didPop() {

    viewModel?.routingDidPop();
  }

  /// Called when a new route has been pushed, and the current route is no
  /// longer visible.
  @mustCallSuper
  @override
  void didPushNext() {

    viewModel?.routingDidPushNext();
  }

  @mustCallSuper
  @override
  void dispose() {
    routeObserver.unsubscribe(this);

    viewModel?.dispose();
    viewModel = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<T>(builder: widget.build),
    );
  }
}
