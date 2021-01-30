import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

/// Simplifies managing a [Cubit] coupled to a [State].
///
/// Override [cubit] as a final field creating an instance of your cubit (type
/// [C]). You can then override [onCubitData] to get notified of cubit state
/// changes (type [S]).
///
/// See the state of the sign-in page for an example implementation.
mixin StateWithCubit<C extends Cubit<S>, S, W extends StatefulWidget>
    on State<W> {
  @protected
  C get cubit;
  StreamSubscription<S> _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = cubit.listen((state) {
      setState(() => onCubitData(state));
    });
    if (cubit is WidgetsBindingObserver) {
      WidgetsBinding.instance.addObserver(cubit as WidgetsBindingObserver);
    }
  }

  @override
  void dispose() {
    if (cubit is WidgetsBindingObserver) {
      WidgetsBinding.instance.removeObserver(cubit as WidgetsBindingObserver);
    }
    _subscription.cancel();
    cubit.close();
    super.dispose();
  }

  @protected
  void onCubitData(S state) {}
}
